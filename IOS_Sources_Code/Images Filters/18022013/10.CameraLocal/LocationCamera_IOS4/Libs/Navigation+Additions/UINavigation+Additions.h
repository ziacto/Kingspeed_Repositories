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

@interface UINavigationController (Additions)

- (void) pushViewController:(UIViewController *)viewController animated:(BOOL)animated animationTransition:(UIViewAnimationTransition)transition;
- (UIViewController *)popViewControllerAnimated:(BOOL)animated animationTransition:(UIViewAnimationTransition)transition;
- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated animationTransition:(UIViewAnimationTransition)transition;
- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated animationTransition:(UIViewAnimationTransition)transition;


@end


typedef enum {
    OrientationMaskPortrait = 0,
    OrientationMaskLanscapeLeft,
    OrientationMaskLanscapeRight,
    OrientationMaskPortraitUpSideDown,
    OrientationMaskAllLanscape,
    OrientationMaskAllPortrait,
    OrientationMaskAll,
}OrientationRotateViewSupport;

@interface UINavigationControllerRotate : UINavigationController
{
    OrientationRotateViewSupport _orientationSupport;
    BOOL _lockOrientation;
}

@property (nonatomic, assign) OrientationRotateViewSupport orientationSupport;
@property (nonatomic, assign) BOOL lockOrientation;

@end



@interface UIViewController (Additions)

- (void) didClickBackButtonOnNavigation;

@end











