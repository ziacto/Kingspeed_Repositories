//
//  AppDelegate.h
//  TestCoreData
//
//  Created by iMac02 on 9/8/2012.
//  Copyright (c) 2012 iMac02. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataController.h"
#import "MacroFunctions.h"

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    DataController *_dataController;
}
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;

@property (nonatomic, retain) DataController *dataController;

+ (AppDelegate*) shareAppdelegate;

@end
