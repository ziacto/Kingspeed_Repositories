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

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <DLBaseClassAdditions/DLLabel.h>

#pragma mark -
#pragma mark AdditionsViewController Option For Iphone 5 ______________________________________
/*********************************************************************************************/
//                                  AdditionsViewController
/*********************************************************************************************/
// Addition xib name for iPhone 5, example, if xib iPhone 4 is @"MainViewController.xib", xib for iPhone 5 will be @"MainViewControllerI5.xib" or @"MainViewController5.xib",
// If xib for iPhone 5 is null, initWithNibName will take xib of iPhone 4,
// This add for initWithNibName with xib iPhone 5,
/*********************************************************************************************/

@interface DLBaseViewController : UIViewController

// a subview on self.view, default is nil, you can outlet to a view on xib file for use,
// you can't not release this, it released in framework.
@property (nonatomic, retain, readonly) IBOutlet UIView *subParrentView;
// for receive Notifications UIApplicationWillResignActiveNotification, UIApplicationDidEnterBackgroundNotification,
//  UIApplicationWillEnterForegroundNotification, UIApplicationDidBecomeActiveNotification, UIApplicationWillTerminateNotification
// default is NO, if YES, notifications will be received in self.
@property (nonatomic, assign) BOOL receiveApplicationNotifications;
// for receive StatusBar Notifications, default is NO.
// UIApplicationWillChangeStatusBarOrientationNotification, UIApplicationDidChangeStatusBarOrientationNotification,
// UIApplicationWillChangeStatusBarFrameNotification, UIApplicationDidChangeStatusBarFrameNotification
@property (nonatomic, assign) BOOL receiveStatusBarNotifications;

+ (id)shareViewControllerFromClass:(Class)class__;
- (id)initWithNibNameFromClass:(Class)class__;

// If receiveApplicationNotification = YES
- (void)dlApplicationWillResignActiveNotification:(NSNotification*)notification__;
- (void)dlApplicationDidEnterBackgroundNotification:(NSNotification*)notification__;
- (void)dlApplicationWillEnterForegroundNotification:(NSNotification*)notification__;
- (void)dlApplicationDidBecomeActiveNotification:(NSNotification*)notification__;
- (void)dlApplicationWillTerminateNotification:(NSNotification*)notification__;

// if receiveStatusBarNotifications = YES
- (void)dlApplicationWillChangeStatusBarOrientation:(NSNotification*)notification__;
- (void)dlApplicationDidChangeStatusBarOrientation:(NSNotification*)notification__;
- (void)dlApplicationWillChangeStatusBarFrame:(NSNotification*)notification__;
- (void)dlApplicationDidChangeStatusBarFrame:(NSNotification*)notification__;

// called when this pop from navigation stack back to previous viewcontroller
- (void)didPopViewControllerOnNavigationStack;
// called when dealloc called, for arc project, you can not call dealoc function, you can use deallocDLBaseViewController instead
// when deallocDLBaseViewController called, all subviews in viewcontroller are removed from super view,
- (void)deallocDLBaseViewController;

// custom title label use for self.navigationItem.titleView
- (DLLabel*)setTitle:(NSString *)title withTextColor:(UIColor*)textColor font:(UIFont*)font;
- (DLLabel*)setTitle:(NSString *)title withTextColor:(UIColor*)textColor font:(UIFont*)font shadowColor:(UIColor*)shadowColor shadowOffset:(NSValue*)shadowOffset;

// use for set a blank button at left or right navigation bar,
// this help title of navigation bar alignment at center of screen
// to title of navigation bar alignment at center of screen, then size of left bar button must be equal to size of right bar button
- (void)setBlankRightButtonNavigationWithSize:(CGSize)size;
- (void)setBlankLeftButtonNavigationWithSize:(CGSize)size;

@end

/*********************************************************************************************
 //                                  UIApplication Notifications
 **********************************************************************************************
 UIKIT_EXTERN NSString *const UIApplicationDidEnterBackgroundNotification       NS_AVAILABLE_IOS(4_0);
 UIKIT_EXTERN NSString *const UIApplicationWillEnterForegroundNotification      NS_AVAILABLE_IOS(4_0);
 UIKIT_EXTERN NSString *const UIApplicationDidFinishLaunchingNotification;
 UIKIT_EXTERN NSString *const UIApplicationDidBecomeActiveNotification;
 UIKIT_EXTERN NSString *const UIApplicationWillResignActiveNotification;
 UIKIT_EXTERN NSString *const UIApplicationDidReceiveMemoryWarningNotification;
 UIKIT_EXTERN NSString *const UIApplicationWillTerminateNotification;
 UIKIT_EXTERN NSString *const UIApplicationSignificantTimeChangeNotification;
 UIKIT_EXTERN NSString *const UIApplicationWillChangeStatusBarOrientationNotification; // userInfo contains NSNumber with new orientation
 UIKIT_EXTERN NSString *const UIApplicationDidChangeStatusBarOrientationNotification;  // userInfo contains NSNumber with old orientation
 UIKIT_EXTERN NSString *const UIApplicationStatusBarOrientationUserInfoKey;            // userInfo dictionary key for status bar orientation
 UIKIT_EXTERN NSString *const UIApplicationWillChangeStatusBarFrameNotification;       // userInfo contains NSValue with new frame
 UIKIT_EXTERN NSString *const UIApplicationDidChangeStatusBarFrameNotification;        // userInfo contains NSValue with old frame
 UIKIT_EXTERN NSString *const UIApplicationStatusBarFrameUserInfoKey;                  // userInfo dictionary key for status bar frame
 UIKIT_EXTERN NSString *const UIApplicationLaunchOptionsURLKey                NS_AVAILABLE_IOS(3_0); // userInfo contains NSURL with launch URL
 UIKIT_EXTERN NSString *const UIApplicationLaunchOptionsSourceApplicationKey  NS_AVAILABLE_IOS(3_0); // userInfo contains NSString with launch app bundle ID
 UIKIT_EXTERN NSString *const UIApplicationLaunchOptionsRemoteNotificationKey NS_AVAILABLE_IOS(3_0); // userInfo contains NSDictionary with payload
 UIKIT_EXTERN NSString *const UIApplicationLaunchOptionsLocalNotificationKey  NS_AVAILABLE_IOS(4_0); // userInfo contains a UILocalNotification
 UIKIT_EXTERN NSString *const UIApplicationLaunchOptionsAnnotationKey         NS_AVAILABLE_IOS(3_2); // userInfo contains object with annotation property list
 UIKIT_EXTERN NSString *const UIApplicationProtectedDataWillBecomeUnavailable NS_AVAILABLE_IOS(4_0);
 UIKIT_EXTERN NSString *const UIApplicationProtectedDataDidBecomeAvailable    NS_AVAILABLE_IOS(4_0);
 UIKIT_EXTERN NSString *const UIApplicationLaunchOptionsLocationKey           NS_AVAILABLE_IOS(4_0); // app was launched in response to a CoreLocation event.
 UIKIT_EXTERN NSString *const UIApplicationLaunchOptionsNewsstandDownloadsKey NS_AVAILABLE_IOS(5_0); // userInfo contains an NSArray of NKAssetDownload identifiers
 *********************************************************************************************/










#pragma mark -
#pragma mark UIViewController catch back click on NavigationBar _______________________________
/*********************************************************************************************/
//                                  UIViewController+
/*********************************************************************************************/
@interface UIViewController (DLAdditionsDidPop)

@property (nonatomic, readonly) BOOL orientationMaskAllPortrait;

@end












typedef void (^dispatchBlock)(void);
#pragma mark -
#pragma mark UIResponder dispatchWithBlock ____________________________________________________
/*********************************************************************************************/
//                                  UIResponder+
/*********************************************************************************************/
@interface NSObject (DLDispatch)
// use dispatch_async to get data or execute functions
- (void)dispatchWithBlock:(dispatchBlock)dispatch completion:(dispatchBlock)completion;

/***************************************************************************************
- (void)example
{
    __block NSData *__data = nil;
    
    [self dispatchWithBlock:^{
        __data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"_______________"]];
    } completion:^{
        if (__data) {
            
        }
    }];
}
***************************************************************************************/

@end





