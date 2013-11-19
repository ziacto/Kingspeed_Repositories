


#import <Foundation/Foundation.h>
#import <sqlite3.h>


@interface UserSQLiteController : NSObject{
    sqlite3 *db;
}

- (NSMutableArray *) getListUsers;
- (BOOL) insertUser:(NSDictionary*) dictUser;
- (BOOL) updateUser:(NSDictionary*) dictUser;
- (NSMutableArray *) deleteUserWithId:(int) userId;
- (BOOL) clearAll;

@end
