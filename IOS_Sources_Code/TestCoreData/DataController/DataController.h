/***********************************************************************
 *	File name:	DataController.h
 *	Project:	Universal
 *	Description:
 *  Author:		Dat Nguyen Mau
 *  Created:    on 10/8/12.
 *	Device:		Iphone vs IPad
 *  Company:	__MyCompanyName__
 *  Copyright:	2012 . All rights reserved.
 ***********************************************************************/

#import <CoreData/CoreData.h>
#import "User.h"
#import "UserInfor.h"

@protocol DataControllerDelegate;

@interface DataController : NSObject <NSFetchedResultsControllerDelegate>
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@property (readonly, strong, retain) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, assign) id<DataControllerDelegate> delegate;

+ (DataController*) sharedInstance;

- (NSFetchedResultsController*) getFetchedResultsControllerWithEntityName:(NSString*) entityName sortKey:(NSString*) sortKey filterPredicate:(NSPredicate*) predicate;

- (void)insertObject:(NSManagedObject *)object;
- (void) deleteObject:(NSManagedObject*) object;
- (void) saveContext;

@end



    // For Update Interface when ManagedObjectContext changes
@protocol DataControllerDelegate <NSObject>
@optional
- (void) dataControllerBeginUpdate:(DataController*) dataController_;
@optional
- (void) dataController:(DataController*) dataController_ didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger) sectionIndex forType:(NSFetchedResultsChangeType) type;
@optional
- (void) dataController:(DataController*) dataController_ didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath
          forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath;
@optional
- (void) dataControllerDidEndUpdate:(DataController*) dataController_;

@end








