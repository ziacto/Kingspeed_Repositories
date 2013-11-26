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
#import <DLBaseClassAdditions/DLButtonToolbar.h>
#import <DLBaseClassAdditions/DLLabel.h>


#define DEVICE_WILL_ROTATE_NOTIFICATION       @"UIDevice Will Rotate Orientation Notification"
#define DEVICE_DID_ROTATE_NOTIFICATION       @"UIDevice Did Rotate Orientation Notification"

// for Objects Of Notification from:
//- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
// And
//- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
#define KEY_TO_ORIENTATION      @"To Orientation"               // = toInterfaceOrientation
#define KEY_FROM_ORIENTATION    @"From Orientation"             //  = fromInterfaceOrientation
#define KEY_DURATION_DEVICE_WILL_ROTATE     @"Duration To Orientation"          // = duration


#pragma mark -
#pragma mark Push With UIViewAnimationTransition ______________________________________________
/*********************************************************************************************/

@interface UINavigationController (DLNavigationPushTransition)

- (void) pushViewController:(UIViewController *)viewController animated:(BOOL)animated animationTransition:(UIViewAnimationTransition)transition;
- (void) pushViewControllerFromBottomWithCATransition:(UIViewController*)viewController duration:(CFTimeInterval)duration;
- (void) popViewControllerFromTopWithCATransitionDuration:(CFTimeInterval)duration;

- (UIViewController *)popViewControllerAnimated:(BOOL)animated animationTransition:(UIViewAnimationTransition)transition;
- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated animationTransition:(UIViewAnimationTransition)transition;
- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated animationTransition:(UIViewAnimationTransition)transition;

@end

#pragma mark -
#pragma mark Push As PresentModal _____________________________________________________________

#define DURATION_PUSH_AS_PRESENT_MODAL  0.25f

/*********************************************************************************************/
@interface UINavigationController (DLPushAsPresentModal)

- (void)pushViewControllerAsPresentModal:(UIViewController*)toViewcontroller;
- (UIViewController *)popViewControllerAsDismissModal;
- (UIViewController *)popToViewControllerAsDismissModal:(UIViewController*)toViewController;
- (UIViewController *)popToRootViewControllerAsDismissModal;

- (void)pushViewControllerAsPresentModal:(UIViewController*)toViewcontroller duration:(NSTimeInterval)duration;
- (UIViewController *)popViewControllerAsDismissModalWithDuration:(NSTimeInterval)duration;
- (UIViewController *)popToViewControllerAsDismissModal:(UIViewController*)toViewController duration:(NSTimeInterval)duration;
- (UIViewController *)popToRootViewControllerAsDismissModalWithDuration:(NSTimeInterval)duration;

- (void)pushViewController:(UIViewController *)toViewController
                  duration:(NSTimeInterval)duration
                   options:(UIViewAnimationOptions)options
                prelayouts:(void (^)(UIView *fromView, UIView *toView))preparation
                animations:(void (^)(UIView *fromView, UIView *toView))animations
                completion:(void (^)(UIView *fromView, UIView *toView))completion;

- (UIViewController *)popViewControllerWithDuration:(NSTimeInterval)duration
                                            options:(UIViewAnimationOptions)options
                                         prelayouts:(void (^)(UIView *fromView, UIView *toView))preparation
                                         animations:(void (^)(UIView *fromView, UIView *toView))animations
                                         completion:(void (^)(UIView *fromView, UIView *toView))completion;

- (UIViewController *)popToViewController:(UIViewController *)toViewController
                                 duration:(NSTimeInterval)duration
                                  options:(UIViewAnimationOptions)options
                               prelayouts:(void (^)(UIView *fromView, UIView *toView))preparation
                               animations:(void (^)(UIView *fromView, UIView *toView))animations
                               completion:(void (^)(UIView *fromView, UIView *toView))completion;


- (UIViewController *)popToRootViewControllerWithDuration:(NSTimeInterval)duration
                                                  options:(UIViewAnimationOptions)options
                                               prelayouts:(void (^)(UIView *fromView, UIView *toView))preparation
                                               animations:(void (^)(UIView *fromView, UIView *toView))animations
                                               completion:(void (^)(UIView *fromView, UIView *toView))completion;

@end


#pragma mark -
#pragma mark UINavigationController Control Rotate ____________________________________________
/*********************************************************************************************/

typedef enum {
    OrientationMaskPortrait = 0,
    OrientationMaskLanscapeLeft,
    OrientationMaskLanscapeRight,
    OrientationMaskPortraitUpSideDown,
    OrientationMaskAllLanscape,
    OrientationMaskAllPortrait,
    OrientationMaskAll,
}OrientationRotateViewSupport;

// This class control rotate for application with all IOS versions (for application has rootviewcontroller is an UINavigationControllerRotate)
// Default NavigationBar will be DLNavigationBar subclass, and Toolbar will be DLToolbar subclass,
@interface DLNavigationControllerRotate : UINavigationController

@property (nonatomic, assign) OrientationRotateViewSupport orientationSupport;      // default is OrientationMaskPortrait;
@property (nonatomic, assign) BOOL lockOrientation;                                 // default is NO. (if set to YES, Your app will be only support current orientation of self)
// if YES, a notification will be sent to NSNofificationCenter when device rotate will key DEVICE_WILL_ROTATE_NOTIFICATION
// and DEVICE_DID_ROTATE_NOTIFICATION
@property (nonatomic, assign) BOOL sendNotificationWhenChangeRotate;        // default is NO;


- (id)initWithRootViewController:(UIViewController *)rootViewController supportOrientation:(OrientationRotateViewSupport)supportOrientation__;

@end



#pragma mark -
#pragma mark UITabBarController Control Rotate ________________________________________________
/*********************************************************************************************/
@interface DLTabBarControllerRotate : UITabBarController

@property (nonatomic, assign) OrientationRotateViewSupport orientationSupport;      // default is OrientationMaskPortrait;
@property (nonatomic, assign) BOOL lockOrientation;                                 // default is NO. (if set to YES, Your app will be only support current orientation)

@end




@interface UIViewController (DLMaskOrientation)

@property (nonatomic, readonly) OrientationRotateViewSupport maskOrientationForSelf;

@end












#pragma mark -
#pragma mark Custom Navigation Bar ____________________________________________________________
@interface DLNavigationBar : UINavigationBar

@property (nonatomic, retain) UIImage *dlBackgroundImage;
@property (nonatomic, retain) DLLabel *dlTitleView;     // an DLLabel added to DLNavigationBar with full size of DLNavigationBar
@property (nonatomic, retain) NSString *title;
// for image event on navigation
@property (nonatomic, retain) UIImage *dlImageEvent;          // for image event on navigation bar, this is above titleView
@property (nonatomic, assign) UIViewContentMode dlImageEventContentMode;

- (void)setDlBackgroundImage:(UIImage *)dlBackgroundImage__ withBarStyle:(UIBarStyle)barStyle__;

@end

@interface UINavigationController (DLNavigationBar_DLToolBar_Subclass)

@property (nonatomic, readonly) DLNavigationBar *dlNavigationBar;
@property (nonatomic, readonly) DLToolbar *dlToolbar;

- (void)setNavigationBarWithDLNavigationBarSubclass;
- (void)setToolbarWithDLToolbarSubclass;

@end







