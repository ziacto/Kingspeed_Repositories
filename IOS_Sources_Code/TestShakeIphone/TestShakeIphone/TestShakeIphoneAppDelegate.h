//
//  TestShakeIphoneAppDelegate.h
//  TestShakeIphone
//
//  Created by iMac02 on 10/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TestShakeIphoneViewController;

@interface TestShakeIphoneAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet TestShakeIphoneViewController *viewController;

@end
