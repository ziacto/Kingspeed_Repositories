/***********************************************************************
 *	File name:
 *	Project:
 *	Description:
 *  Author:		Dat Nguyen Mau
 *  Created:    on 3/1/12.
 *	Device:		Iphone vs IPad
 *  Company:	__MyCompanyName__
 *  Copyright:	2012 . All rights reserved.
 ***********************************************************************/


#import <UIKit/UIKit.h>
#import <DLBaseClassAdditions/DLBaseClassAdditions.h>

#import "RHAddressBook+DLAdditions.h"
#import <AddressBookUI/AddressBookUI.h>

@class AppDelegate;

@interface AppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet DLNavigationControllerRotate *navigationController;

@property (nonatomic, retain) RHAddressBook *addressBook;

+ (AppDelegate*)shareApp;

@end
