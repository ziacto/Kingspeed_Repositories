//
//  User.h
//  TestCoreData
//
//  Created by iMac02 on 9/8/2012.
//  Copyright (c) 2012 iMac02. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class UserInfor;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) UserInfor *userinfor;

@end
