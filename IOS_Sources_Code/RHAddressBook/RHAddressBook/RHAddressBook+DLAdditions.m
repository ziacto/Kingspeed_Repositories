//
//  RHAddressBook+DLAdditions.m
//  RHAddressBook
//
//  Created by Nguyen Mau Dat on 11/19/13.
//
//

#import "RHAddressBook+DLAdditions.h"
#import "RHARCSupport.h"

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

@implementation RHAddressBook (DLAdditions)

+ (BOOL)hasBirthdayTodayInPeople:(NSArray*)people
{
    for (RHPerson* person in people) {
        if ([person isKindOfClass:[RHPerson class]]) {
            if ([person.birthday isEqualToDateIgnoringTime:[NSDate dateToday]]) {
                return YES;
            }
        }
    }
    
    return NO;
}

- (NSMutableArray*)peopleOrderedBySortOrderingAndSectioned
{
    __block NSMutableArray *results = [[NSMutableArray alloc] init];
    
    [_addressBookThread rh_performBlock:^{
        NSArray *array = [self peopleOrderedBySortOrdering:ABPersonGetSortOrdering()];
        if (array.count > 0) {
            NSMutableArray *section = [[[NSMutableArray alloc] init] autorelease];
            RHPerson *person = [array objectAtIndex:0];
            NSString *currentStr = person.nameSortOrdering.length > 0 ? [[person.nameSortOrdering substringToIndex:1] uppercaseString] : @"";
            [section addObject:currentStr];
            [results addObject:section];
            
            for (RHPerson *person in array) {
                NSString *secStr = person.nameSortOrdering.length > 0 ? [[person.nameSortOrdering substringToIndex:1] uppercaseString] : @"";
                if ([secStr isEqualToString:currentStr]) {
                    [section addObject:person];
                }
                else {
                    section = [[[NSMutableArray alloc] init] autorelease];
                    [results addObject:section];
                    [section addObject:secStr];
                    [section addObject:person];
                    currentStr = secStr;
                }
            }
        }
    }];
    
    return arc_autorelease(results);
}

@end




@implementation RHPerson (DLAdditions)

- (NSString *)nameSortOrdering
{
    if (self.firstName && self.lastName) {
        if (ABPersonGetSortOrdering () == kABPersonSortByFirstName) {
            return self.firstName;
        }
        else {
            return self.lastName;
        }
    }
    else {
        return self.nameCompositeName;
    }
}

@end


