/***********************************************************************
 *	File name:	UINavigationController+Additions.m
 *	Project:	TheWeatherNews
 *	Description:
 *  Author:		Dat Nguyen Mau
 *  Created:    on 6/9/2012.
 *	Device:		Iphone vs IPad
 *  Company:	__MyCompanyName__
 *  Copyright:	2012 . All rights reserved.
 ***********************************************************************/

#import "UINavigation+Additions.h"

@implementation UINavigationController (Additions)

- (void) pushViewController:(UIViewController *)viewController animated:(BOOL)animated animationTransition:(UIViewAnimationTransition)transition
{
    // for TransitionFlipFromRight with Navigation
    if (transition != UIViewAnimationTransitionNone) {
        [UIView  beginAnimations:nil context:NULL];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.75];
    }
    
    [self pushViewController:viewController animated:YES];
    
    if (transition != UIViewAnimationTransitionNone) {
        [UIView setAnimationTransition:transition forView:self.view cache:NO];
        [UIView commitAnimations];
    }
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated animationTransition:(UIViewAnimationTransition)transition
{
    if (transition != UIViewAnimationTransitionNone) {
        [UIView  beginAnimations:nil context:NULL];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.75];
    }
    
    UIViewController *controller = [self popViewControllerAnimated:animated];
    
    if (transition != UIViewAnimationTransitionNone) {
        [UIView setAnimationTransition:transition forView:self.view cache:NO];
        [UIView commitAnimations];
    }
    
    return controller;
}
- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated animationTransition:(UIViewAnimationTransition)transition
{
    if (transition != UIViewAnimationTransitionNone) {
        [UIView  beginAnimations:nil context:NULL];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.75];
    }
    
    NSArray *arr = [self popToViewController:viewController animated:animated];
    
    if (transition != UIViewAnimationTransitionNone) {
        [UIView setAnimationTransition:transition forView:self.view cache:NO];
        [UIView commitAnimations];
    }
    
    return arr;
}
- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated animationTransition:(UIViewAnimationTransition)transition
{
    if (transition != UIViewAnimationTransitionNone) {
        [UIView  beginAnimations:nil context:NULL];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.75];
    }
    
    NSArray *arr = [self popToRootViewControllerAnimated:animated];
    
    if (transition != UIViewAnimationTransitionNone) {
        [UIView setAnimationTransition:transition forView:self.view cache:NO];
        [UIView commitAnimations];
    }
    
    return arr;
}

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









@implementation NSString (Externded)

- (BOOL) isEmty
{
    NSString *str = trimString(self);
    return [str isEqualToString:@""];
}


@end










