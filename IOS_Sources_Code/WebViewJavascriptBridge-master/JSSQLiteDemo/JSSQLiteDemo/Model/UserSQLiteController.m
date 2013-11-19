//
//  UserSQLiteController.m
//  MyWineList
//
//  Created by Kevin Languedoc on 11/25/11.
//  Copyright (c) 2011 kCodebook. All rights reserved.
//

#import "UserSQLiteController.h"

@implementation UserSQLiteController

-(id)init{
    
    
    return self;
}
- (NSMutableArray *) getListUsers{
    NSMutableArray *listUsers = [[NSMutableArray alloc] init];
    
    @try {
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        // Get the documents directory
        NSArray * dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);;
        NSString *docsDir = [dirPaths objectAtIndex:0];

        // Build the path to the database file
        NSString *dbPath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"JSSQLiteDemo.sqlite"]];

        BOOL success = [fileMgr fileExistsAtPath:dbPath];
        if(!success)
        {
            NSLog(@"Cannot locate database file '%@'.", dbPath);
        }
        if(!(sqlite3_open([dbPath UTF8String], &db) == SQLITE_OK))
        {
            NSLog(@"An error has occured.");
        }
        
        const char *sql = "SELECT * FROM  users";
        sqlite3_stmt *sqlStatement;
        if(sqlite3_prepare(db, sql, -1, &sqlStatement, NULL) != SQLITE_OK)
        {
            NSLog(@"Problem with prepare statement");
        }
        //
        while (sqlite3_step(sqlStatement)==SQLITE_ROW) {
            NSMutableDictionary * dict  = [[NSMutableDictionary alloc] init];
            
             [dict setValue:[NSNumber numberWithInt:sqlite3_column_int(sqlStatement, 0)]  forKey:@"id"];
             [dict setValue:[NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,1)] forKey:@"nickname"];
             [dict setValue:[NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,2)] forKey:@"birth_month"];
             [dict setValue:[NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,3)] forKey:@"mail"];
             [dict setValue:[NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,4)] forKey:@"live_area"];
            
             [listUsers addObject:dict];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured: %@", [exception reason]);
    }
    @finally {
        return listUsers;
    }
}


- (BOOL) insertUser:(NSDictionary*) dictUser{
    BOOL isSuccess = FALSE;
    NSMutableArray *listUsers = [[NSMutableArray alloc] init];
    
    @try {
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        // Get the documents directory
        NSArray * dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);;
        NSString *docsDir = [dirPaths objectAtIndex:0];
        
        // Build the path to the database file
        NSString *dbPath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"JSSQLiteDemo.sqlite"]];
        
        BOOL success = [fileMgr fileExistsAtPath:dbPath];
        if(!success)
        {
            NSLog(@"Cannot locate database file '%@'.", dbPath);
        }
        if(!(sqlite3_open([dbPath UTF8String], &db) == SQLITE_OK))
        {
            NSLog(@"An error has occured.");
        }
        
        NSString *sql =[ NSString stringWithFormat: @"INSERT INTO users (nickname, birth_month, mail, live_area) VALUES (\"%@\", \"%@\", \"%@\", \"%@\")", [dictUser objectForKey:@"nickname"],[dictUser objectForKey:@"birth_month"],[dictUser objectForKey:@"mail"],[dictUser objectForKey:@"live_area"]];
        const char *insert_stmt = [sql UTF8String];
        sqlite3_stmt *sqlStatement;
        
        if(sqlite3_prepare(db, insert_stmt, -1, &sqlStatement, NULL) != SQLITE_OK)
        {
            NSLog(@"Problem with prepare statement");
        }
        //
        if (sqlite3_step(sqlStatement)==SQLITE_DONE) {
            isSuccess = TRUE;
           NSLog(@"INSERR OK");
        }else{
             NSLog(@"INSERR ERROR");
        }
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured: %@", [exception reason]);
    }
    @finally {
        return isSuccess;
    }
}

- (BOOL) updateUser:(NSDictionary*) dictUser{
    BOOL isSuccess = FALSE;
    NSMutableArray *listUsers = [[NSMutableArray alloc] init];
    
    @try {
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        // Get the documents directory
        NSArray * dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);;
        NSString *docsDir = [dirPaths objectAtIndex:0];
        
        // Build the path to the database file
        NSString *dbPath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"JSSQLiteDemo.sqlite"]];
        
        BOOL success = [fileMgr fileExistsAtPath:dbPath];
        if(!success)
        {
            NSLog(@"Cannot locate database file '%@'.", dbPath);
        }
        if(!(sqlite3_open([dbPath UTF8String], &db) == SQLITE_OK))
        {
            NSLog(@"An error has occured.");
        }
        
        NSString *sql = [NSString stringWithFormat:@"UPDATE users SET nickname = \"%@\", birth_month = \"%@\", mail = \"%@\" , live_area = \"%@\" WHERE id = \"%d\"", [dictUser objectForKey:@"nickname"],[dictUser objectForKey:@"birth_month"],[dictUser objectForKey:@"mail"],[dictUser objectForKey:@"live_area"], [[dictUser objectForKey:@"id"] intValue]];
        const char *insert_stmt = [sql UTF8String];
        sqlite3_stmt *sqlStatement;
        
        if(sqlite3_prepare(db, insert_stmt, -1, &sqlStatement, NULL) != SQLITE_OK)
        {
            NSLog(@"Problem with prepare statement");
        }
        //
        if (sqlite3_step(sqlStatement)==SQLITE_DONE) {
            isSuccess = TRUE;
        }else{
            NSLog(@"INSERR ERROR");
        }
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured: %@", [exception reason]);
    }
    @finally {
        return isSuccess;
    }
}


- (NSMutableArray *) deleteUserWithId:(int) userId{
    NSMutableArray *listUsers = [[NSMutableArray alloc] init];
    
    @try {
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        // Get the documents directory
        NSArray * dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);;
        NSString *docsDir = [dirPaths objectAtIndex:0];
        
        // Build the path to the database file
        NSString *dbPath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"JSSQLiteDemo.sqlite"]];
        
        BOOL success = [fileMgr fileExistsAtPath:dbPath];
        if(!success)
        {
            NSLog(@"Cannot locate database file '%@'.", dbPath);
        }
        if(!(sqlite3_open([dbPath UTF8String], &db) == SQLITE_OK))
        {
            NSLog(@"An error has occured.");
        }
        
        NSString *sql =[NSString stringWithFormat: @"DELETE FROM users WHERE id =%d" ,userId];
        const char *insert_stmt = [sql UTF8String];
        sqlite3_stmt *sqlStatement;
        
        if(sqlite3_prepare(db, insert_stmt, -1, &sqlStatement, NULL) != SQLITE_OK)
        {
            NSLog(@"Problem with prepare statement");
        }
        //
        if (sqlite3_step(sqlStatement)==SQLITE_DONE) {
            NSLog(@"DELETE OK");
        }else{
            NSLog(@"DELETE ERROR");
        }
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured: %@", [exception reason]);
    }
    @finally {
        return listUsers;
    }
}

- (BOOL) clearAll{
   BOOL isSuccess = FALSE;
    
    @try {
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        // Get the documents directory
        NSArray * dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);;
        NSString *docsDir = [dirPaths objectAtIndex:0];
        
        // Build the path to the database file
        NSString *dbPath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"JSSQLiteDemo.sqlite"]];
        
        BOOL success = [fileMgr fileExistsAtPath:dbPath];
        if(!success)
        {
            NSLog(@"Cannot locate database file '%@'.", dbPath);
        }
        if(!(sqlite3_open([dbPath UTF8String], &db) == SQLITE_OK))
        {
            NSLog(@"An error has occured.");
        }
        
        NSString *sql = @"DELETE FROM users";
        const char *insert_stmt = [sql UTF8String];
        sqlite3_stmt *sqlStatement;
        
        if(sqlite3_prepare(db, insert_stmt, -1, &sqlStatement, NULL) != SQLITE_OK)
        {
            NSLog(@"Problem with prepare statement");
        }
        //
        if (sqlite3_step(sqlStatement)==SQLITE_DONE) {
            isSuccess = TRUE;
            NSLog(@"DELETE OK");
        }else{
            NSLog(@"DELETE ERROR");
        }
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured: %@", [exception reason]);
    }
    @finally {
        return isSuccess;
    }
}


@end