//
//  AddressPrivacyStatus.m
//  LibObjectKingspeed
//
//  Created by iMac02 on 25/10/2012.
//  Copyright (c) 2012 iMac02. All rights reserved.
//

#import "AddressBookPrivacyStatus.h"

@implementation AddressBookPrivacyStatus

+ (ABPrivacyStatus) privacyStatus
{
#if (__IPHONE_OS_VERSION_MAX_ALLOWED <= __IPHONE_5_1)
    return -1;
#else
    return ABAddressBookGetAuthorizationStatus();
#endif
}

@end
