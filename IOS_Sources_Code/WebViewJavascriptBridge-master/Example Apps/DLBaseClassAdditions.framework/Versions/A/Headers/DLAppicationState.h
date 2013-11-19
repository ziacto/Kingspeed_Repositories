/***********************************************************************
 *	File name:	___________
 *	Project:	DLBaseClassFramework
 *	Description:
 *  Author:		Dat Nguyen Mau
 *  Created:    on 9/4/2013.
 *	Device:		Iphone vs IPad
 *  Company:	__MyCompanyName__
 *  Copyright:	2012 . All rights reserved.
 ***********************************************************************/

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    DLAppicationStateActive = 0,        // Application is active
    DLAppicationStateMultitask,         // Application in active, click home button 2 times -> on multitask tabbar.
    DLAppicationStateLockScreen,        // Application in active, click power button to lock device.
    DLAppicationStateBackground         // Application is in background mode.
} DLAppicationStateStatus;


// Require: This class must be init in "- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions"
// to can check correct state of your application.

@interface DLAppicationState : NSObject

@property (nonatomic, readonly) DLAppicationStateStatus applicationStateStatus;

+ (DLAppicationState*)monitorAppicationState;

@end


