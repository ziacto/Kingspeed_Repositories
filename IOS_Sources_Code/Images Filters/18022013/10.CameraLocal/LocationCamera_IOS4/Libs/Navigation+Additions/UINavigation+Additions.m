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

#import "UINavigation+Additions.h"

@implementation UINavigationController (Additions)

- (void) pushViewController:(UIViewController *)viewController animated:(BOOL)animated animationTransition:(UIViewAnimationTransition)transition
{
        // for TransitionFlipFromRight with Navigation
    [UIView  beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.75];
    
    [self pushViewController:viewController animated:YES];
    
    [UIView setAnimationTransition:transition forView:self.view cache:NO];
    [UIView commitAnimations];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated animationTransition:(UIViewAnimationTransition)transition
{
    [UIView  beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.75];
    
    UIViewController *controller = [self popViewControllerAnimated:animated];
    
    [UIView setAnimationTransition:transition forView:self.view cache:NO];
    [UIView commitAnimations];
    
    return controller;
}
- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated animationTransition:(UIViewAnimationTransition)transition
{
    [UIView  beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.75];
    
    NSArray *arr = [self popToViewController:viewController animated:animated];
    
    [UIView setAnimationTransition:transition forView:self.view cache:NO];
    [UIView commitAnimations];
    
    return arr;
}
- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated animationTransition:(UIViewAnimationTransition)transition
{
    [UIView  beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.75];
    
    NSArray *arr = [self popToRootViewControllerAnimated:animated];
    
    [UIView setAnimationTransition:transition forView:self.view cache:NO];
    [UIView commitAnimations];
    
    return arr;
}

@end



@implementation UINavigationControllerRotate
@synthesize orientationSupport = _orientationSupport;
@synthesize lockOrientation = _lockOrientation;

- (id) initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        _orientationSupport = OrientationMaskAll;
        _lockOrientation = NO;
    }
    return self;
}

/***********************************************************************************************/
/******************************** This for Xcode SDK < 6.0 *************************************/
/***********************************************************************************************/
#if (__IPHONE_OS_VERSION_MAX_ALLOWED <= __IPHONE_5_1 || __IPHONE_OS_VERSION_MAX_ALLOWED <= __IPHONE_5_0 || __IPHONE_OS_VERSION_MAX_ALLOWED <= __IPHONE_4_3 || __IPHONE_OS_VERSION_MAX_ALLOWED <= __IPHONE_4_2 ||    __IPHONE_OS_VERSION_MAX_ALLOWED <= __IPHONE_4_1 || __IPHONE_OS_VERSION_MAX_ALLOWED <= __IPHONE_4_0)

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    // this function is only for IOS < 6.0
    switch (_orientationSupport) {
        case OrientationMaskPortrait: {
            return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
        }
            break;
            
        case OrientationMaskLanscapeLeft: {
            return (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft);
        }
            break;
            
        case OrientationMaskLanscapeRight: {
            return (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight);
        }
            break;
            
        case OrientationMaskPortraitUpSideDown: {
            return (toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
        }
            break;
            
        case OrientationMaskAllLanscape: {
            return (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight);
        }
            break;
            
        case OrientationMaskAllPortrait: {
            return (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
        }
            break;
            
            // support all orientation: OrientationMaskAll
        default:
            return YES;
            break;
    }
}
#else
/***********************************************************************************************/
/*********************************This For Xcode SDK >= 6.0 ************************************/
/***********************************************************************************************/
- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
//    NSLog(@"______________________________________________ shouldAutorotateToInterfaceOrientation");
    // this function is only for IOS < 6.0
    if (_lockOrientation) return NO;
    
    switch (_orientationSupport) {
        case OrientationMaskPortrait: {
            return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
        }
            break;
            
        case OrientationMaskLanscapeLeft: {
            return (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft);
        }
            break;
            
        case OrientationMaskLanscapeRight: {
            return (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight);
        }
            break;
            
        case OrientationMaskPortraitUpSideDown: {
            return (toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
        }
            break;
            
        case OrientationMaskAllLanscape: {
            return (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight);
        }
            break;
            
        case OrientationMaskAllPortrait: {
            return (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
        }
            break;
        
            // support all orientation: OrientationMaskAll
        default:
            return YES;
            break;
    }
}

// for IOS >= 6.0
- (BOOL) shouldAutorotate
{
    // return YES for support rotate NO for non rotate
    return !_lockOrientation;
}
- (NSUInteger)supportedInterfaceOrientations
{
    // this function is only for IOS >= 6.0
    switch (_orientationSupport) {
        case OrientationMaskPortrait: {
            return UIInterfaceOrientationMaskPortrait;
        }
            break;
            
        case OrientationMaskLanscapeLeft: {
            return UIInterfaceOrientationMaskLandscapeLeft;
        }
            break;
            
        case OrientationMaskLanscapeRight: {
            return UIInterfaceOrientationMaskLandscapeRight;
        }
            break;
            
        case OrientationMaskPortraitUpSideDown: {
            return UIInterfaceOrientationMaskPortraitUpsideDown;
        }
            break;
            
        case OrientationMaskAllLanscape: {
            return UIInterfaceOrientationMaskLandscape;
        }
            break;
            
        case OrientationMaskAllPortrait: {
            return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
        }
            break;
            
            // support all orientation: OrientationMaskAll
        default:
            return UIInterfaceOrientationMaskAll;
            break;
    }
}
#endif
/***********************************************************************************************/
/***********************************************************************************************/
/***********************************************************************************************/

@end





@implementation UIViewController (Additions)

- (void) detectNavigationBackButtonClick
{
    if (![self.navigationController.viewControllers containsObject:self]) {
        // back button was pressed.  We know this is true because self is no longer
        [self didClickBackButtonOnNavigation];
    }
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

- (void) viewWillDisappear:(BOOL)animated
{
    [self detectNavigationBackButtonClick];
}
#pragma clang diagnostic pop


- (void) didClickBackButtonOnNavigation
{
    
}

@end









