//
//  TestColorPixelAppDelegate.h
//  TestColorPixel
//
//  Created by iMac02 on 12/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TestColorPixelViewController;

@interface TestColorPixelAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet TestColorPixelViewController *viewController;

@end
