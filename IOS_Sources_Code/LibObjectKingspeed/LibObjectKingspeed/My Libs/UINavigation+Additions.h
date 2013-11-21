/***********************************************************************
 *	File name:	UINavigationController+Additions.h
 *	Project:	TheWeatherNews
 *	Description:
 *  Author:		Dat Nguyen Mau
 *  Created:    on 6/9/2012.
 *	Device:		Iphone vs IPad
 *  Company:	__MyCompanyName__
 *  Copyright:	2012 . All rights reserved.
 ***********************************************************************/

#import <UIKit/UIKit.h>

#define trimString( object ) [object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

@interface UINavigationController (Additions)

- (void) pushViewController:(UIViewController *)viewController animated:(BOOL)animated animationTransition:(UIViewAnimationTransition)transition;
- (UIViewController *)popViewControllerAnimated:(BOOL)animated animationTransition:(UIViewAnimationTransition)transition;
- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated animationTransition:(UIViewAnimationTransition)transition;
- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated animationTransition:(UIViewAnimationTransition)transition;


@end



@interface UIViewController (Additions)

- (void) didClickBackButtonOnNavigation;

@end









@interface NSString (Externded)

- (BOOL) isEmty;

@end












