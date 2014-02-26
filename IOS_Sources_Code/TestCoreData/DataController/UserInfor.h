//
//  UserInfor.h
//  TestCoreData
//
//  Created by iMac02 on 9/8/2012.
//  Copyright (c) 2012 iMac02. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface UserInfor : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSDate * age;
@property (nonatomic, retain) User *user;

@end
