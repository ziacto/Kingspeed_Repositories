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

#import "DNProgressHub.h"
#import <QuartzCore/QuartzCore.h>

@interface DNProgressHub ()
{
    UIActivityIndicatorView *_activityIndicator;
}

- (id)initWithView:(UIView*)view;

@end

@implementation DNProgressHub

+(DNProgressHub*)showHubToWindow
{
    return [self showHubToView:[[UIApplication sharedApplication] delegate].window];
}

+(DNProgressHub*)showHubToView:(UIView*)view
{
    DNProgressHub *hub = [[DNProgressHub alloc] initWithView:view];
    [view addSubview:hub];
    
    return hub;
}

+ (void)hideAllHubDNForWindow
{
    [self hideAllHubDNForView:[[UIApplication sharedApplication] delegate].window];
}

+ (void)hideAllHubDNForView:(UIView*)view
{
    for (id sub in view.subviews) {
        if ([sub isKindOfClass:[DNProgressHub class]]) {
            [(DNProgressHub*)sub cleanAll];
        }
    }
}

- (id)initWithView:(UIView*)view
{
    self = [super initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        CGFloat ySub = 50;
        
        if ([[UIScreen mainScreen] bounds].size.height >= 568.) {
            ySub = 98;
        }
        
        UIView *_sub = [[UIView alloc] initWithFrame:CGRectMake(0, ySub, 320, 320)];
        _sub.backgroundColor = [UIColor blackColor];
        _sub.alpha = 0.25;
        [self addSubview:_sub];
        
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleWhiteLarge)];
        _activityIndicator.center = _sub.center;
        [self addSubview:_activityIndicator];
        
        [_activityIndicator startAnimating];
    }
    
    return self;
}

- (void)cleanAll
{
    [_activityIndicator stopAnimating];
    [_activityIndicator removeFromSuperview];
    _activityIndicator = nil;
    
    [self removeFromSuperview];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

@end
