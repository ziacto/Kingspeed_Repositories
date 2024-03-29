//
//  RHAddressBook.m
//  RHAddressBook
//
//  Created by Richard Heard on 11/11/11.
//  Copyright (c) 2011 Richard Heard. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions
//  are met:
//  1. Redistributions of source code must retain the above copyright
//  notice, this list of conditions and the following disclaimer.
//  2. Redistributions in binary form must reproduce the above copyright
//  notice, this list of conditions and the following disclaimer in the
//  documentation and/or other materials provided with the distribution.
//  3. The name of the author may not be used to endorse or promote products
//  derived from this software without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
//  IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
//  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
//  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
//  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
//  NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
//  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
//  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
//  THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

#import "RHAddressBook.h"

#import "RHRecord.h"
#import "RHRecord_Private.h"

#import "RHSource.h"
#import "RHGroup.h"
#import "RHPerson.h"
#import "RHAddressBookSharedServices.h"

#if RH_AB_INCLUDE_GEOCODING
#import "RHAddressBookGeoResult.h"
#endif //end Geocoding

#import "NSThread+RHBlockAdditions.h"
#import "RHAddressBookThreadMain.h"
#import "RHAddressBook_private.h"
#import "RHARCSupport.h"

#define USE_REF_MAP 1
#define USE_PERSON_ID_MAP 1

NSString * const RHAddressBookExternalChangeNotification = @"RHAddressBookExternalChangeNotification";

#if RH_AB_INCLUDE_GEOCODING
NSString * const RHAddressBookPersonAddressGeocodeCompleted = @"RHAddressBookPersonAddressGeocodeCompleted";
#endif //end Geocoding

//private
@interface RHAddressBook ()
-(NSArray*)sourcesForABRecordRefs:(CFArrayRef)sourceRefs; //bulk performer
-(NSArray*)groupsForABRecordRefs:(CFArrayRef)groupRefs; //bulk performer
-(NSArray*)peopleForABRecordRefs:(CFArrayRef)peopleRefs; //bulk performer

-(void)addressBookExternallyChanged:(NSNotification*)notification; //notification on external changes. (revert if no local changes so always up-to-date)

#if USE_PERSON_ID_MAP
-(void)rebuildPersonIDToRecordMap:(BOOL)waitTillDone;
#endif

@end

@implementation RHAddressBook {
    __unsafe_unretained RHAddressBookSharedServices *_sharedServices; //weak, single instance
    
    
#if USE_REF_MAP
    //ref to record weak map. (we maintain this for faster access directly to RHRecord objects)
    CFMutableDictionaryRef _refToRecordMap;
    
#endif
    
#if USE_PERSON_ID_MAP
    //further optimizations specifically for looking up RHPerson records based on recordID
    CFMutableDictionaryRef _personIDToRecordMap;
    
#endif
}

@synthesize addressBookThread=_addressBookThread;
@synthesize addressBookRef = _addressBookRef;

-(id)init{
    self = [super init];
    if (self){
        
        //do all our work on a single thread.
        //because NSThread retains its target, we use a placeholder object that contains the threads main method
        RHAddressBookThreadMain *threadMain = arc_autorelease([[RHAddressBookThreadMain alloc] init]);
        _addressBookThread = [[NSThread alloc] initWithTarget:threadMain selector:@selector(threadMain:) object:nil];
        [_addressBookThread setName:[NSString stringWithFormat:@"RHAddressBookInstanceThread for instance %p", self]];
        [_addressBookThread start];
        
        _sharedServices = [RHAddressBookSharedServices sharedInstance]; //pointer to singleton (this causes the geo cache to be rebuilt if needed)
        
        //setup
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 60000
        if (ABAddressBookCreateWithOptions != NULL){
            __block CFErrorRef errorRef = NULL;
            [_addressBookThread rh_performBlock:^{
                _addressBookRef = ABAddressBookCreateWithOptions(nil, &errorRef);
            }];
            
            if (!_addressBookRef){
                //bail
                RHErrorLog(@"Error: Failed to create RHAddressBook instance. Underlying ABAddressBookCreateWithOptions() failed with error: %@", errorRef);
                if (errorRef) CFRelease(errorRef);
                arc_release_nil(self);
            
                return nil;
            }
            
        } else {
#endif //end iOS6+
            
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            [_addressBookThread rh_performBlock:^{
                _addressBookRef = ABAddressBookCreate();
            }];
#pragma clang diagnostic pop
            
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 60000
        }
#endif //end iOS6+
        
        [_addressBookThread rh_performBlock:^{
            //weak linking mutable sets
            _sources = (__bridge_transfer NSMutableSet *)CFSetCreateMutable(NULL, 0, NULL);
            _groups = (__bridge_transfer NSMutableSet *)CFSetCreateMutable(NULL, 0, NULL);
            _people = (__bridge_transfer NSMutableSet *)CFSetCreateMutable(NULL, 0, NULL);
            
#if USE_REF_MAP
            _refToRecordMap = CFDictionaryCreateMutable(nil, 0, NULL, NULL); //weak for both keys and values
#endif
            
#if USE_PERSON_ID_MAP            
            _personIDToRecordMap = CFDictionaryCreateMutable(nil, 0, &kCFTypeDictionaryKeyCallBacks, NULL); //weak for both keys and values
#endif
        }];
        
        //subscribe to external change notifications
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addressBookExternallyChanged:) name:RHAddressBookExternalChangeNotification object:nil];
        
    }
    
    return self;
}

-(void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];

    _sharedServices = nil; //just throw away our pointer (its a singleton)

    [_addressBookThread cancel]; //notify the thread that it is no longer needed
    arc_release_nil(_addressBookThread);
    
    if (_addressBookRef) CFRelease(_addressBookRef); _addressBookRef = NULL;
    
    arc_release_nil(_sources);
    arc_release_nil(_groups);
    arc_release_nil(_people);
    
#if USE_REF_MAP
    if (_refToRecordMap) CFRelease(_refToRecordMap); _refToRecordMap = NULL;
#endif
    
#if USE_PERSON_ID_MAP
    if (_personIDToRecordMap) CFRelease(_personIDToRecordMap); _personIDToRecordMap = NULL;
#endif

    arc_super_dealloc();
}


#pragma mark - authorization

+(RHAuthorizationStatus)authorizationStatus{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 60000
    if (ABAddressBookGetAuthorizationStatus != NULL){
        ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
        switch (status) {
            case kABAuthorizationStatusNotDetermined: return RHAuthorizationStatusNotDetermined;
            case kABAuthorizationStatusRestricted: return RHAuthorizationStatusRestricted;
            case kABAuthorizationStatusDenied: return RHAuthorizationStatusDenied;
            case kABAuthorizationStatusAuthorized: return RHAuthorizationStatusAuthorized;
        }
    }
#endif //end iOS6+
    
    //Pre iOS6, always return authorized
    return RHAuthorizationStatusAuthorized;
}

-(void)requestAuthorizationWithCompletion:(void (^)(bool granted, NSError* error))completion{
    completion = (__bridge id)Block_copy((__bridge void *)completion);
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 60000
    
    if (ABAddressBookRequestAccessWithCompletion != NULL){
        
        [self performAddressBookAction:^(ABAddressBookRef addressBookRef) {

            ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
                completion(granted, (__bridge NSError*)error);
                if (error) CFRelease(error);
                Block_release((__bridge void *)completion);
            });
         
        } waitUntilDone:YES];
        
        return; //if we were able to call ABAddressBookRequestAccessWithCompletion
    }
    
#endif //end iOS6+

    //else, run the completion block async (access is always allowed pre iOS6)
    dispatch_async(dispatch_get_main_queue(), ^{
        completion(YES, nil);
        Block_release((__bridge void *)completion);
    });
}


#pragma mark - threads

-(void)performAddressBookAction:(void (^)(ABAddressBookRef addressBookRef))actionBlock waitUntilDone:(BOOL)wait{
   if (_addressBookRef) CFRetain(_addressBookRef);
    [_addressBookThread rh_performBlock:^{
        actionBlock(_addressBookRef);
        if (_addressBookRef) CFRelease(_addressBookRef);
    } waitUntilDone:wait];
}


#pragma mark - access - sources

-(NSArray*)sources{
    __block NSArray *result = nil;
    [_addressBookThread rh_performBlock:^{
        CFArrayRef sourceRefs = ABAddressBookCopyArrayOfAllSources(_addressBookRef);
        if (sourceRefs){
            result = arc_retain([self sourcesForABRecordRefs:sourceRefs]);
            if (sourceRefs) CFRelease(sourceRefs);
        }
    }];
    return arc_autorelease(result);
}

-(RHSource*)defaultSource{
    __block RHSource* source = nil;
    [_addressBookThread rh_performBlock:^{
        ABRecordRef sourceRef = ABAddressBookCopyDefaultSource(_addressBookRef);
        source = arc_retain([self sourceForABRecordRef:sourceRef]);
        if (sourceRef) CFRelease(sourceRef);
    }];
    return arc_autorelease(source);
}

-(RHSource*)sourceForABRecordRef:(ABRecordRef)sourceRef{

    if (sourceRef == NULL) return nil; //bail
    
    //if we find the exact ref in the current cache its safe to return that object, however its not save to add a ref directly if not found, instead we use the recordID
    // (this allows us to return not yet saved, newly created objects that have invalid RecordIDs without breaking the multiple ab barrier)
    // these not yet saved objects are added to the cache via the weak record check in / out system when they are created / dealloc'd

    
#if USE_REF_MAP
    
    //look for an exact match using recordRef
    __block RHSource *source = nil;
    [_addressBookThread rh_performBlock:^{
        id mapSource = CFDictionaryGetValue(_refToRecordMap, sourceRef);
        if ([mapSource isKindOfClass:[RHSource class]]){
            source = arc_retain(mapSource);
        }
    }];

    if (source) return arc_autorelease(source);
    
#else
    
    //search for an exact match using recordRef
    __block RHSource *source = nil;
    [_addressBookThread rh_performBlock:^{
        //look in the cache
        for (RHSource *entry in _sources) {
            //compare using ref
            if (sourceRef == entry.recordRef){
                source = arc_retain(entry);
                break;
            }
        }
    }];
    
    if (source) return arc_autorelease(source);
    
#endif
    
    //get the sourceID
    __block ABRecordID sourceID = kABRecordInvalidID;
    [_addressBookThread rh_performBlock:^{
        sourceID = ABRecordGetRecordID(sourceRef);
    }];
    
    if (sourceID == kABRecordInvalidID) return nil; //bail

    
    //search for the actual source
    [_addressBookThread rh_performBlock:^{
        
        //look in the cache
        for (RHSource *entry in _sources) {
            //compare using ID not ref
            if (sourceID == entry.recordID){
                source = arc_retain(entry);
                break;
            }
        }
        
        //if not in the cache, create and add a new one
        if (! source){
            //we don't use the sourceRef directly so as to ensure we are using the correct _addressBook
            ABRecordRef sourceRef = ABAddressBookGetSourceWithRecordID(_addressBookRef, sourceID);
            
            if (sourceRef){
                source = [[RHSource alloc] initWithAddressBook:self recordRef:sourceRef];
                //the record will check in with the addressbook, so its automatically added to the cache and available for future calls..
            }
        }
            
    }];
    if (!source) RHLog(@"Source lookup miss");
    return arc_autorelease(source);
}

-(NSArray*)sourcesForABRecordRefs:(CFArrayRef)sourceRefs{
    if (!sourceRefs) return nil;
    CFRetain(sourceRefs);
    NSMutableArray *sources = [NSMutableArray array];
    
    [_addressBookThread rh_performBlock:^{
        
        for (CFIndex i = 0; i < CFArrayGetCount(sourceRefs); i++) {
            ABRecordRef sourceRef = CFArrayGetValueAtIndex(sourceRefs, i);
            
            RHSource *source = [self sourceForABRecordRef:sourceRef];
            if (source) [sources addObject:source];
        }
    }];
    CFRelease(sourceRefs);
    return [NSArray arrayWithArray:sources];
}

-(RHSource*)sourceForABRecordID:(ABRecordID)sourceID{
    __block ABRecordRef recordRef = NULL;
    
    [_addressBookThread rh_performBlock:^{
        recordRef = ABAddressBookGetSourceWithRecordID(_addressBookRef, sourceID);
    }];    
    
    return [self sourceForABRecordRef:recordRef];
}


#pragma mark - access - groups

-(NSArray*)groups{
    __block NSArray *result = nil;
    [_addressBookThread rh_performBlock:^{
        CFArrayRef groupRefs = ABAddressBookCopyArrayOfAllGroups(_addressBookRef);
        if (groupRefs){
            result = arc_retain([self groupsForABRecordRefs:groupRefs]);
            CFRelease(groupRefs);
        }
    }];
    return arc_autorelease(result);
}

-(long)numberOfGroups{
    __block long result = 0;
    [_addressBookThread rh_performBlock:^{
        result = ABAddressBookGetGroupCount(_addressBookRef);
    }];
    return result;
}

-(NSArray*)groupsInSource:(RHSource*)source{
    __block NSArray *result = nil;
    [_addressBookThread rh_performBlock:^{
        CFArrayRef groupRefs = ABAddressBookCopyArrayOfAllGroupsInSource(_addressBookRef, source.recordRef);
        if (groupRefs){
            result = arc_retain([self groupsForABRecordRefs:groupRefs]);
            CFRelease(groupRefs);
        }
    }];
    return arc_autorelease(result);
}

-(RHGroup*)groupForABRecordRef:(ABRecordRef)groupRef{
    
    if (groupRef == NULL) return nil; //bail
    
    //if we find the exact ref in the current cache its safe to return that object, however its not save to add a ref directly if not found, instead we use the recordID
    // (this allows us to return not yet saved, newly created objects that have invalid RecordIDs without breaking the multiple ab barrier)
    // these not yet saved objects are added to the cache via the weak record check in / out system when they are created / dealloc'd

    
#if USE_REF_MAP

    //look for an exact match using recordRef
    __block RHGroup *group = nil;
    [_addressBookThread rh_performBlock:^{
        id mapGroup = CFDictionaryGetValue(_refToRecordMap, groupRef);
        if ([mapGroup isKindOfClass:[RHGroup class]]){
            group = arc_retain(mapGroup);
        }
    }];
    
    if (group) return arc_autorelease(group);

#else
    
    //search for an exact match using recordRef
    __block RHGroup *group = nil;
    [_addressBookThread rh_performBlock:^{
        //look in the cache
        for (RHGroup *entry in _groups) {
            //compare using ref
            if (groupRef == entry.recordRef){
                group = arc_retain(entry);
                break;
            }
        }
    }];
    
    if (group) return arc_autorelease(group);

#endif
    
    //if no direct match found, try using recordID
    __block ABRecordID groupID = kABRecordInvalidID;
    [_addressBookThread rh_performBlock:^{
        groupID = ABRecordGetRecordID(groupRef);
    }];
    
    //is valid ?
    if (groupID == kABRecordInvalidID) return nil; //invalid, (no further lookup possible, return nil)

    
    //search for the actual group via recordID
    [_addressBookThread rh_performBlock:^{

        //look in the cache
        for (RHGroup *entry in _groups) {
            //compare using ID not ref
            if (groupID == entry.recordID){
                group = arc_retain(entry);
                break;
            }
        }

        //if not in the cache, create and add a new one
        if (! group){
            
            //we don't use the groupRef directly to ensure we are using the correct _addressBook
            __block ABRecordRef groupRef = ABAddressBookGetGroupWithRecordID(_addressBookRef, groupID);

            if (groupRef){
                group = [[RHGroup alloc] initWithAddressBook:self recordRef:groupRef];
                //the record will check in with the addressbook, so its automatically added to the cache and available for future calls..
            }
        }
        
    }];
    
    return arc_autorelease(group);
}

-(NSArray*)groupsForABRecordRefs:(CFArrayRef)groupRefs{
    if (!groupRefs) return nil;

    NSMutableArray *groups = [NSMutableArray array];
    
    [_addressBookThread rh_performBlock:^{
        
        for (CFIndex i = 0; i < CFArrayGetCount(groupRefs); i++) {
            ABRecordRef groupRef = CFArrayGetValueAtIndex(groupRefs, i);
            
            RHGroup *group = [self groupForABRecordRef:groupRef];
            if (group) [groups addObject:group];
        }
    }];
    return [NSArray arrayWithArray:groups];
}

-(RHGroup*)groupForABRecordID:(ABRecordID)groupID{

    __block ABRecordRef recordRef = NULL;
    
    [_addressBookThread rh_performBlock:^{
        recordRef = ABAddressBookGetGroupWithRecordID(_addressBookRef, groupID);
    }];    
    
    return [self groupForABRecordRef:recordRef];
}


#pragma mark - access - people

-(NSArray*)people{
    __block NSArray *result = nil;
    [_addressBookThread rh_performBlock:^{
        CFArrayRef peopleRefs = ABAddressBookCopyArrayOfAllPeople(_addressBookRef);
        if (peopleRefs){
            result = arc_retain([self peopleForABRecordRefs:peopleRefs]);
            CFRelease(peopleRefs);
        }
    }];
    return arc_autorelease(result);
}

-(long)numberOfPeople{
    __block long result = 0;
    [_addressBookThread rh_performBlock:^{
        result = ABAddressBookGetPersonCount(_addressBookRef);
    }];
    return result;
}

-(NSArray*)peopleOrderedBySortOrdering:(ABPersonSortOrdering)ordering{
    __block NSArray *result = nil;
    [_addressBookThread rh_performBlock:^{
        
        CFArrayRef peopleRefs = ABAddressBookCopyArrayOfAllPeople(_addressBookRef);
        
        if (peopleRefs){
            CFMutableArrayRef mutablePeopleRefs = CFArrayCreateMutableCopy(kCFAllocatorDefault, CFArrayGetCount(peopleRefs), peopleRefs);
            if (mutablePeopleRefs){

                //sort 
                CFArraySortValues(mutablePeopleRefs, CFRangeMake(0, CFArrayGetCount(mutablePeopleRefs)), (CFComparatorFunction) ABPersonComparePeopleByName, (void*) ordering);
                result = arc_retain([self peopleForABRecordRefs:mutablePeopleRefs]);
                CFRelease(mutablePeopleRefs);
                
            }
            
            CFRelease(peopleRefs);
            
        }
    }];
    
    return arc_autorelease(result);
}

-(NSArray*)peopleOrderedByUsersPreference{
    return [self peopleOrderedBySortOrdering:[RHAddressBook sortOrdering]];
}
-(NSArray*)peopleOrderedByFirstName{
    return [self peopleOrderedBySortOrdering:kABPersonSortByFirstName];
}
-(NSArray*)peopleOrderedByLastName{
    return [self peopleOrderedBySortOrdering:kABPersonSortByLastName];
}

-(NSArray*)peopleWithName:(NSString*)name{
    __block NSArray *result = nil;
    [_addressBookThread rh_performBlock:^{
        CFArrayRef peopleRefs = ABAddressBookCopyPeopleWithName(_addressBookRef, (__bridge CFStringRef)name);
        if (peopleRefs) {
            result = arc_retain([self peopleForABRecordRefs:peopleRefs]);
            CFRelease(peopleRefs);
        }
    }];
    return arc_autorelease(result);
}

-(RHPerson*)personForABRecordRef:(ABRecordRef)personRef{
    
    if (personRef == NULL) return nil; //bail
    
    //if we find the exact ref in the current cache its safe to return that object, however its not save to add a ref directly if not found, instead we use the recordID
    // (this allows us to return not yet saved, newly created objects that have invalid RecordIDs without breaking the multiple ab barrier)
    // these not yet saved objects are added to the cache via the weak record check in / out system when they are created / dealloc'd

    
#if USE_REF_MAP

    //look for an exact match using recordRef
    __block RHPerson *person = nil;
    [_addressBookThread rh_performBlock:^{
        id mapPerson = CFDictionaryGetValue(_refToRecordMap, personRef);
        if ([mapPerson isKindOfClass:[RHPerson class]]){
            person = arc_retain(mapPerson);
        }
    }];
    
    if (person) return arc_autorelease(person);
    
#else

    //search for an exact match using recordRef
    __block RHPerson *person = nil;
    [_addressBookThread rh_performBlock:^{
        //look in the cache
        for (RHPerson *entry in _people) {
            //compare ref directly
            if (personRef == entry.recordRef){
                person = arc_retain(entry);
                break;
            }
        }
    }];
    
    if (person) return arc_autorelease(person);
    
#endif
    
    //if exact matching failed, look using recordID;
    __block ABRecordID personID = kABRecordInvalidID;
    [_addressBookThread rh_performBlock:^{
        personID = ABRecordGetRecordID(personRef);
    }];
    
    //is valid ?
    if (personID == kABRecordInvalidID) return nil; //invalid, (no further lookup possible, return nil)
    
    
    //search for the actual person using recordID
    [_addressBookThread rh_performBlock:^{

#if USE_PERSON_ID_MAP
        
        id mapPerson = CFDictionaryGetValue(_personIDToRecordMap, (__bridge const void *)([NSNumber numberWithInt:personID]));
        if (mapPerson) person = arc_retain(mapPerson);
        
#else        
        //look in the cache
        for (RHPerson *entry in _people) {
            //compare using ID not ref
            if (personID == entry.recordID){
                person = arc_retain(entry);
                break;
            }
        }
        
#endif
        
        //if not in the cache, create and add a new one
        if (! person){
            
            //we don't use the personRef directly to ensure we are using the correct _addressBook
            __block ABRecordRef personRef = ABAddressBookGetPersonWithRecordID(_addressBookRef, personID);
            
            if (personRef){
                person = [[RHPerson alloc] initWithAddressBook:self recordRef:personRef];
                //the record will check in with the addressbook, so its automatically added to the cache and available for future calls..
            }
        }
        
    }];
    
    return arc_autorelease(person);

}

-(NSArray*)peopleForABRecordRefs:(CFArrayRef)peopleRefs{
    if (!peopleRefs) return nil;

    NSMutableArray *people = [NSMutableArray array];

    [_addressBookThread rh_performBlock:^{

        for (CFIndex i = 0; i < CFArrayGetCount(peopleRefs); i++) {
            ABRecordRef personRef = CFArrayGetValueAtIndex(peopleRefs, i);
            
            RHPerson *person = [self personForABRecordRef:personRef];
            if (person) [people addObject:person];
        }
    }];
    return [NSArray arrayWithArray:people];
}

-(RHPerson*)personForABRecordID:(ABRecordID)personID{

    __block ABRecordRef recordRef = NULL;
    
    [_addressBookThread rh_performBlock:^{
        recordRef = ABAddressBookGetPersonWithRecordID(_addressBookRef, personID);
    }];    
    
    return [self personForABRecordRef:recordRef];
}

#pragma mark - add
-(RHPerson*)newPersonInDefaultSource{
    RHPerson *newPerson = [RHPerson newPersonInSource:[self defaultSource]];
    [self addPerson:newPerson];
    return newPerson;
}

-(RHPerson*)newPersonInSource:(RHSource*)source{
    
    //make sure the passed source is actually associated with self
    if (self != source.addressBook) [NSException raise:NSInvalidArgumentException format:@"Error: RHSource object does not belong to this addressbook instance."];
    
    RHPerson *newPerson = [RHPerson newPersonInSource:source];
    [self addPerson:newPerson];
    return newPerson;
}

-(BOOL)addPerson:(RHPerson*)person{
    NSError *error = nil;
    BOOL result = [self addPerson:person error:&error];
    if (!result) {
        RHErrorLog(@"RHAddressBook: Error adding person: %@", error);
    }
    return result;
}

-(BOOL)addPerson:(RHPerson*)person error:(NSError**)error{
    if (!person){
        RHErrorLog(@"Error: Unable to add a nil RHPerson to the AddressBook.");
        return NO;
    }
    
    //check to make sure person has not already been added to another addressbook, if so bail;
    if (person.addressBook != nil && person.addressBook != self) [NSException raise:NSInvalidArgumentException format:@"Person has already been added to another addressbook."];
    
    __block BOOL result = NO;
    __block CFErrorRef cfError = NULL;
    
    [_addressBookThread rh_performBlock:^{
        result = ABAddressBookAddRecord(_addressBookRef, person.recordRef, &cfError);
    }];
    
    if (!result){
        if (error && cfError) *error = (NSError*)ARCBridgingRelease(CFRetain(cfError));
        if (cfError) CFRelease(cfError);
    }
    return result;
}


#pragma mark - add groups
-(RHGroup*)newGroupInDefaultSource{
    RHGroup *newGroup = [RHGroup newGroupInSource:[self defaultSource]];
    [self addGroup:newGroup];
    return newGroup;
}

-(RHGroup*)newGroupInSource:(RHSource*)source{
    
    //make sure the passed source is actually associated with self
    if (self != source.addressBook) [NSException raise:NSInvalidArgumentException format:@"Error: RHSource object does not belong to this addressbook instance."];
    
    RHGroup *newGroup = [RHGroup newGroupInSource:source];
    [self addGroup:newGroup];
    return newGroup;
}

-(BOOL)addGroup:(RHGroup *)group{
    NSError *error = nil;
    BOOL result = [self addGroup:group error:&error];
    if (!result) {
        RHErrorLog(@"RHAddressBook: Error adding group: %@", error);
    }
    return result;
}

-(BOOL)addGroup:(RHGroup *)group error:(NSError**)error{
    if (!group){
        RHErrorLog(@"Error: Unable to add a nil RHGroup to the AddressBook.");
        return NO;
    }
    
    //check to make sure group has not already been added to another addressbook, if so bail;
    if (group.addressBook != nil && group.addressBook != self) [NSException raise:NSInvalidArgumentException format:@"Group has already been added to another addressbook."];
    
    __block BOOL result = NO;
    __block CFErrorRef cfError = NULL;
    
    [_addressBookThread rh_performBlock:^{
        result = ABAddressBookAddRecord(_addressBookRef, group.recordRef, &cfError);
    }];
    
    if (!result){
        if (error && cfError) *error = (NSError*)ARCBridgingRelease(CFRetain(cfError));
        if (cfError) CFRelease(cfError);
    }
    return result;
}


#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 50000

#pragma mark - add from vCard (iOS5+)
-(NSArray*)addPeopleFromVCardRepresentationToDefaultSource:(NSData*)representation{
    return [self addPeopleFromVCardRepresentation:representation toSource:[self defaultSource]];
}

-(NSArray*)addPeopleFromVCardRepresentation:(NSData*)representation toSource:(RHSource*)source{
    if (!ABPersonCreatePeopleInSourceWithVCardRepresentation) return nil; //availability check

    NSMutableArray *newPeople = [NSMutableArray array];

    [_addressBookThread rh_performBlock:^{

        CFArrayRef peopleRefs = ABPersonCreatePeopleInSourceWithVCardRepresentation(source.recordRef, (__bridge CFDataRef)representation);

        if (peopleRefs){
            for (CFIndex i = 0; i < CFArrayGetCount(peopleRefs); i++) {
                ABRecordRef personRef = CFArrayGetValueAtIndex(peopleRefs, i);
                if (personRef){
                    BOOL success = ABAddressBookAddRecord(_addressBookRef, personRef, NULL);

                    if (success){
                        RHPerson *person = arc_autorelease([[RHPerson alloc] initWithAddressBook:self recordRef:personRef]);
                        if (person)[newPeople addObject:person];
                    }
                }
            }
            CFRelease(peopleRefs);
        }
    }];
    return [NSArray arrayWithArray:newPeople];
}

-(NSData*)vCardRepresentationForPeople:(NSArray*)people{
    if (!ABPersonCreateVCardRepresentationWithPeople) return nil; //availability check

    NSData *result = nil;
    
    CFMutableArrayRef refs = CFArrayCreateMutable(NULL, 0, NULL);
    if (refs){

        for (RHPerson *person in people) {
            CFArrayAppendValue(refs, person.recordRef);
        }
        
        result = (__bridge_transfer NSData*)ABPersonCreateVCardRepresentationWithPeople(refs);
        
        CFRelease(refs);
    }
    return arc_autorelease(result);
}

#endif //end iOS5+


#pragma mark - remove
-(BOOL)removePerson:(RHPerson*)person{
    NSError *error = nil;
    BOOL result = [self removePerson:person error:&error];
    if (!result) {
        RHErrorLog(@"RHAddressBook: Error removing person: %@", error);
    }
    return result;
}

-(BOOL)removePerson:(RHPerson*)person error:(NSError**)error{
    if (!person){
        RHErrorLog(@"Error: Unable to remove a nil RHPerson from the AddressBook.");
        return NO;
    }
    
    //need to make sure it is actually part of the current addressbook
    if (person.addressBook != self) [NSException raise:NSInvalidArgumentException format:@"Person does not belong to this addressbook instance."];
    
    __block BOOL result = YES;
    __block CFErrorRef cfError = NULL;
    
    [_addressBookThread rh_performBlock:^{
        result = ABAddressBookRemoveRecord(_addressBookRef, person.recordRef, &cfError);
    }];
    
    if (!result){
        if (error && cfError) *error = (NSError*)ARCBridgingRelease(CFRetain(cfError));
        if (cfError) CFRelease(cfError);
    }
    return result;
}

-(BOOL)removeGroup:(RHGroup*)group{
    NSError *error = nil;
    BOOL result = [self removeGroup:group error:&error];
    if (!result) {
        RHErrorLog(@"RHAddressBook: Error removing group: %@", error);
    }
    return result;
}

-(BOOL)removeGroup:(RHGroup*)group error:(NSError**)error{
    if (!group){
        RHErrorLog(@"Error: Unable to remove a nil RHGroup from the AddressBook.");
        return NO;
    }
    
    //make sure it is actually part of the current addressbook
    if (group.addressBook != self) [NSException raise:NSInvalidArgumentException format:@"Group does not belong to this addressbook instance."];

    __block BOOL result = YES;
    __block CFErrorRef cfError = NULL;
    
    [_addressBookThread rh_performBlock:^{
        result = ABAddressBookRemoveRecord(_addressBookRef, group.recordRef, &cfError);
    }];

    if (!result){
        if (error && cfError) *error = (NSError*)ARCBridgingRelease(CFRetain(cfError));
        if (cfError) CFRelease(cfError);
    }
    return result;
}


#pragma mark - save
-(BOOL)save{
    NSError *error = nil;
    BOOL result = [self saveWithError:&error];
    if (!result) {
        RHErrorLog(@"RHAddressBook: Error saving: %@", error);
    }
    return result;
}

//renamed method shim
-(BOOL)save:(NSError**)error{
    RHErrorLog(@"RHAddressBook: The save: method has been renamed to saveWithError: You should update your sources appropriately.");
    return [self saveWithError:error];
}

-(BOOL)saveWithError:(NSError**)error{
    __block BOOL result = YES;
    __block CFErrorRef cfError = NULL;
    
    [_addressBookThread rh_performBlock:^{
        if ([self hasUnsavedChanges]) {
            result = ABAddressBookSave(_addressBookRef, &cfError);
        }
    }];
    if (!result){
        if (error && cfError) *error = (NSError*)ARCBridgingRelease(CFRetain(cfError));
        if (cfError) CFRelease(cfError);
    }

#if USE_PERSON_ID_MAP
    [self rebuildPersonIDToRecordMap:YES];
#endif

    return result;
}

-(BOOL)hasUnsavedChanges{
    __block BOOL result;
    [_addressBookThread rh_performBlock:^{
        result = ABAddressBookHasUnsavedChanges(_addressBookRef);
    }];
    
    return result;
}

-(void)revert{
    [_addressBookThread rh_performBlock:^{
        ABAddressBookRevert(_addressBookRef);
    }];
}

-(void)addressBookExternallyChanged:(NSNotification*)notification{
    //notification on external changes. (revert if no local changes so always up-to-date)
    if (![self hasUnsavedChanges]){
        [self revert];
    } else {
        RHLog(@"Not auto-reverting on notification of external address book changes as we have unsaved local changes.");
    }

}


#if USE_PERSON_ID_MAP

-(void)rebuildPersonIDToRecordMap:(BOOL)waitTillDone{
    [_addressBookThread rh_performBlock:^{

        CFDictionaryRemoveAllValues(_personIDToRecordMap);

        for (RHPerson *person in _people) {
            if (person.recordID != kABRecordInvalidID){
                //add the person record to the id map
                CFDictionarySetValue(_personIDToRecordMap, (__bridge const void *)([NSNumber numberWithInt:person.recordID]), (__bridge const void *)(person));
            }
        }
        
    } waitUntilDone:waitTillDone];
    
}

#endif

#pragma mark - prefs
+(ABPersonSortOrdering)sortOrdering{
    return ABPersonGetSortOrdering();
}
+(BOOL)orderByFirstName{
    return [RHAddressBook sortOrdering] == kABPersonSortByFirstName;
}
+(BOOL)orderByLastName{
    return [RHAddressBook sortOrdering] == kABPersonSortByLastName;
}

+(ABPersonCompositeNameFormat)compositeNameFormat{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if (ABPersonGetCompositeNameFormatForRecord != NULL){
        return ABPersonGetCompositeNameFormatForRecord(NULL);
    } else {
#endif //end iOS7+
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        return ABPersonGetCompositeNameFormat();
#pragma clang diagnostic pop
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    }
#endif //end iOS7+
    
}

+(BOOL)compositeNameFormatFirstNameFirst{
    return [RHAddressBook compositeNameFormat] == kABPersonCompositeNameFormatFirstNameFirst;
}
+(BOOL)compositeNameFormatLastNameFirst{
    return [RHAddressBook compositeNameFormat] == kABPersonCompositeNameFormatLastNameFirst;
}

#if RH_AB_INCLUDE_GEOCODING
+(BOOL)isGeocodingSupported{
    return [RHAddressBookSharedServices isGeocodingSupported];
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 50000

#pragma mark - geocoding (iOS5+)
//cache
+(BOOL)isPreemptiveGeocodingEnabled{
    return [RHAddressBookSharedServices isPreemptiveGeocodingEnabled];
}

+(void)setPreemptiveGeocodingEnabled:(BOOL)enabled{
    [RHAddressBookSharedServices setPreemptiveGeocodingEnabled:enabled];
}
-(float)preemptiveGeocodingProgress{
    return [_sharedServices preemptiveGeocodingProgress];
}

//forward
-(CLPlacemark*)placemarkForPerson:(RHPerson*)person addressID:(ABMultiValueIdentifier)addressID{
    return [_sharedServices placemarkForPersonID:person.recordID addressID:addressID];
}

-(CLLocation*)locationForPerson:(RHPerson*)person addressID:(ABMultiValueIdentifier)addressID{
    return [_sharedServices locationForPersonID:person.recordID addressID:addressID];
}

//reverse geo
-(NSArray*)peopleWithinDistance:(double)distance ofLocation:(CLLocation*)location{
    NSArray *results = [_sharedServices geoResultsWithinDistance:distance ofLocation:location];
    NSMutableArray *array = [NSMutableArray array];
    if (results){
        [_addressBookThread rh_performBlock:^{
            for (RHAddressBookGeoResult *result in results) {
                RHPerson *person = [self personForABRecordID:result.personID];
                if (person) [array addObject:person];
            }
        }];
    }
    return [NSArray arrayWithArray:array];
}

-(RHPerson*)personClosestToLocation:(CLLocation*)location{
    RHAddressBookGeoResult *result = [_sharedServices geoResultClosestToLocation:location];
    __block RHPerson *person = nil;
    if (result){
        [_addressBookThread rh_performBlock:^{
            person = arc_retain([self personForABRecordID:result.personID]);
        }];
    }
    return arc_autorelease(person);
    
}

-(RHPerson*)personClosestToLocation:(CLLocation*)location distanceOut:(double*)distanceOut{
    RHAddressBookGeoResult *result = [_sharedServices geoResultClosestToLocation:location distanceOut:distanceOut];
    __block RHPerson *person = nil;
    if (result){
        [_addressBookThread rh_performBlock:^{
            person = arc_retain([self personForABRecordID:result.personID]);
        }];
    }
    return arc_autorelease(person);
}

#endif //end iOS5+

#endif //end Geocoding


#pragma mark - private

//used to implement the weak linking cache 
-(void)_recordCheckIn:(RHRecord*)record{
    if (!record) return;

    record = arc_retain(record); //keep it around for a while

    [_addressBookThread rh_performBlock:^{

#if USE_REF_MAP
        //add it to the record Ref map
        CFDictionarySetValue(_refToRecordMap, record.recordRef, (__bridge const void *)(record));
#endif

#if USE_PERSON_ID_MAP
        if ([record isKindOfClass:[RHPerson class]] && record.recordID != kABRecordInvalidID){
            //add the person record to the id map
            CFDictionarySetValue(_personIDToRecordMap, (__bridge const void *)([NSNumber numberWithInt:record.recordID]), (__bridge const void *)(record));
        }
#endif

        //if person, add to _people
        if ([record isKindOfClass:[RHPerson class]]){
            [_people addObject:record];
            return;
        }

        //if group, add to _groups
        if ([record isKindOfClass:[RHGroup class]]){
            [_groups addObject:record];
            return;
        }

        //if source, add to _sources
        if ([record isKindOfClass:[RHSource class]]){
            [_sources addObject:record];
            return;
        }

    }];
    
    arc_release(record);
}

-(void)_recordCheckOut:(RHRecord*)record{
    //called from inside records dealloc method, so not safe to use any instance variables implemented below RHRecord.
    if (!record) return;
    
    __unsafe_unretained __block RHRecord *_safeRecord = record;
    
    [_addressBookThread rh_performBlock:^{
        
#if USE_REF_MAP
        //remove it from the map
        CFDictionaryRemoveValue(_refToRecordMap, _safeRecord.recordRef);
#endif
      
#if USE_PERSON_ID_MAP
        if ([_safeRecord isKindOfClass:[RHPerson class]]){
            //remove it from the id map
            CFDictionaryRemoveValue(_personIDToRecordMap, (__bridge const void *)([NSNumber numberWithInt:_safeRecord.recordID]));
        }
#endif

        //if person, remove from _people
        if ([_safeRecord isKindOfClass:[RHPerson class]]){
            CFSetRemoveValue((CFMutableSetRef)_people, (__bridge const void *)(_safeRecord));
            return;
        }

        //if group, remove from _groups
        if ([_safeRecord isKindOfClass:[RHGroup class]]){
            CFSetRemoveValue((CFMutableSetRef)_groups, (__bridge const void *)(_safeRecord));
            return;
        }

        //if source, remove from _sources
        if ([_safeRecord isKindOfClass:[RHSource class]]){
            CFSetRemoveValue((CFMutableSetRef)_sources, (__bridge const void *)(_safeRecord));
            return;
        }

    }];
    
}

@end
