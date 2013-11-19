/***********************************************************************
 *	File name:	_______________.h
 *	Project:	Location Camera
 *	Description:
 *  Author:		Dat Nguyen Mau
 *  Created:    on 18/02/2013.
 *	Device:		Iphone vs IPad
 *  Company:	__MyCompanyName__
 *  Copyright:	2012 . All rights reserved.
 ***********************************************************************/

#import <UIKit/UIKit.h>
#import "UIDevice+additions.h"
#import "UINavigation+Additions.h"
#import "FacebookView.h"

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationControllerRotate *navigationController;

@property (strong, nonatomic) FBLoginView *facebookLoginView;

+ (AppDelegate *) shareApp;

@end
