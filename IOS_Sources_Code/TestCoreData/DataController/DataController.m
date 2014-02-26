/***********************************************************************
 *	File name:	DataController.m
 *	Project:	Universal
 *	Description:
 *  Author:		Dat Nguyen Mau
 *  Created:    on 10/8/12.
 *	Device:		Iphone vs IPad
 *  Company:	__MyCompanyName__
 *  Copyright:	2012 . All rights reserved.
 ***********************************************************************/

#import "DataController.h"

@interface DataController ()
{
    BOOL _beginUpdates;
}

@end

@implementation DataController

@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

@synthesize delegate = _delegate;

static DataController *sharedInstance_ = nil;

#pragma mark -
#pragma mark Init Class
    //===================================================
    // Init
+ (DataController*) sharedInstance
{
	@synchronized(self) {
        if (!sharedInstance_) {
            sharedInstance_ = [[DataController alloc] init];
        }
	}
    
	return sharedInstance_;
}

+ (id) alloc
{
	@synchronized(self) {
        NSAssert(sharedInstance_ == nil, @"Attempted to allocate a second instance of a singleton.");
        return [super alloc];
	}
	return nil;
}

- (id) init
{
    if((self = [super init])) {
        
    }
    
    return self;
}
    //==============================================================================
- (void)insertObject:(NSManagedObject *)object
{
    [self.managedObjectContext insertObject:object];
    [self.managedObjectContext save:nil];
}
- (void) deleteObject:(NSManagedObject*) object
{
    [self.managedObjectContext deleteObject:object];
    [self.managedObjectContext save:nil];
}

- (void)saveContext
{
    NSError *error = nil;
    if (__managedObjectContext != nil) {
        if ([__managedObjectContext hasChanges] && ![__managedObjectContext save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (NSFetchedResultsController*) getFetchedResultsControllerWithEntityName:(NSString*) entityName sortKey:(NSString*) sortKey filterPredicate:(NSPredicate*) predicate
{
        // 1 - Decide what Entity you want
//    NSString *entityName = @"User"; // Put your entity name here
    NSLog(@"Get An Fetched Results Controller for the Entity named: \"%@\"", entityName);
    
        // 2 - Request that Entity
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    
        // 3 - Filter it if you want
    if (predicate) request.predicate = predicate;   //[NSPredicate predicateWithFormat:@"Role.name = Blah"];
    
        // 4 - Sort it if you want
    if (sortKey) {
        request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:sortKey
                                                                                         ascending:YES
                                                                                          selector:@selector(localizedCaseInsensitiveCompare:)]];
    }
        // 5 - Fetch it
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    if (self.fetchedResultsController) {
        NSError *error;
        [self.fetchedResultsController performFetch:&error];
        if (error) {
            NSLog(@"[%@ %@] %@ (%@)", NSStringFromClass([self class]), NSStringFromSelector(_cmd), [error localizedDescription], [error localizedFailureReason]);
            return nil;
        }
        return __fetchedResultsController;
    }
    return nil;
}


#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil) {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil) {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"TestCoreData.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return __persistentStoreCoordinator;
}


#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}




#pragma mark - NSFetchedResultsControllerDelegate
#pragma mark - NSFetchedResultsControllerDelegate
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    _beginUpdates = YES;
    if (_delegate && [_delegate respondsToSelector:@selector(dataControllerBeginUpdate:)]) {
        [_delegate dataControllerBeginUpdate:self];
    }
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
		   atIndex:(NSUInteger)sectionIndex
	 forChangeType:(NSFetchedResultsChangeType)type
{
    if (_delegate && [_delegate respondsToSelector:@selector(dataController:didChangeSection:atIndex:forType:)]) {
        [_delegate dataController:self didChangeSection:sectionInfo atIndex:sectionIndex forType:type];
    }
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
	   atIndexPath:(NSIndexPath *)indexPath
	 forChangeType:(NSFetchedResultsChangeType)type
	  newIndexPath:(NSIndexPath *)newIndexPath
{
    if (_delegate && [_delegate respondsToSelector:@selector(dataController:didChangeObject:atIndexPath:forChangeType:newIndexPath:)]) {
        [_delegate dataController:self didChangeObject:anObject atIndexPath:indexPath forChangeType:type newIndexPath:newIndexPath];
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    if (_beginUpdates && _delegate && [_delegate respondsToSelector:@selector(dataControllerDidEndUpdate:)])
        [_delegate dataControllerDidEndUpdate:self];
}

@end
