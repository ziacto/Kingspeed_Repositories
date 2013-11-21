//
//  AddressPrivacyStatus.h
//  LibObjectKingspeed
//
//  Created by iMac02 on 25/10/2012.
//  Copyright (c) 2012 iMac02. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

typedef NS_ENUM(NSInteger, ABPrivacyStatus) {
    ABPrivacyStatusNotDetermined = 0,
    ABPrivacyStatusRestricted,
    ABPrivacyStatusDenied,
    ABPrivacyStatusAuthorized
};

@interface AddressBookPrivacyStatus : NSObject
+ (ABPrivacyStatus) privacyStatus;
@end
