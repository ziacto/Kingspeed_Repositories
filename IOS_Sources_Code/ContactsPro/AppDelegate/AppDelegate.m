/***********************************************************************
 *	File name:	fasdg.h
 *	Project:	Universal
 *	Description:
 *  Author:		Dat Nguyen Mau
 *  Created:    on 3/1/12.
 *	Device:		Iphone vs IPad
 *  Company:	__MyCompanyName__
 *  Copyright:	2012 . All rights reserved.
 ***********************************************************************/


#import "AppDelegate.h"

#import "MainViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;
@synthesize addressBook = _addressBook;

+ (AppDelegate*)shareApp
{
    return (AppDelegate*)[[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    self.addressBook = [[[RHAddressBook alloc] init] autorelease];
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    MainViewController *_viewController = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    self.navigationController = [[DLNavigationControllerRotate alloc] initWithRootViewController:_viewController supportOrientation:OrientationMaskAll];
    self.navigationController.sendNotificationWhenChangeRotate = YES;
    if (![DLDevice isIOS7OrLater])
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    else
        self.navigationController.dlNavigationBar.dlBackgroundImage = [UIImage imageNamed:@"header_IOS7.png"];
    
    [self.window setRootViewController:self.navigationController];
    [self.window makeKeyAndVisible];
    
    if ([DLDevice isIOS7OrLater]) {
        UIImageView *tempV = [[[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, 320.f, 20.f)] autorelease];
        tempV.image = [UIImage imageNamed:@"hStatusbar_IOS7@2x.png"];
        [self.window addSubview:tempV];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [_window release];
    [_navigationController release];
    [super dealloc];
}

@end
