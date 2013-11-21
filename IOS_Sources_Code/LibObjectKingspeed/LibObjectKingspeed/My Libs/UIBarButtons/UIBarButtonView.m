/***********************************************************************
 *	File name:	UIBarButtonView.m
 *	Project:
 *	Description:
 *  Author:		Dat Nguyen Mau
 *  Created:    on 23/10/2012.
 *	Device:		Iphone vs IPad
 *  Company:	__MyCompanyName__
 *  Copyright:	2012 . All rights reserved.
 ***********************************************************************/

#import "UIBarButtonView.h"

@interface UIBarButtonView ()

@end

@implementation UIBarButtonView

- (id)init
{
    if ((self = [super init])) {
        NSArray * nib = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([UIBarButtonView class]) owner:self options: nil];
        
        self = [nib objectAtIndex:0];
    }
    return self;
}

- (id) initWithBackgroundImage:(UIImage*)imgBgr iconImage:(UIImage*)iconImage title:(NSString*)title font:(UIFont*)titleFont
              target:(id)target action:(SEL)action forButtonControlEvent:(UIControlEvents)controlEvent
{
    UIBarButtonView *_bButtonView = [[UIBarButtonView alloc] init];
    if (_bButtonView) {
        [_bButtonView setBackgroundImage:imgBgr iconImage:iconImage title:title];
        [_bButtonView addTarget:target action:action forButtonControlEvent:controlEvent];
        _bButtonView.labelTitle.font = titleFont;
    }
    return _bButtonView;
}

- (id) initWithIconImage:(UIImage*)iconImage title:(NSString*)title font:(UIFont*)titleFont
                  target:(id)target action:(SEL)action forButtonControlEvent:(UIControlEvents)controlEvent
{
    return [[UIBarButtonView alloc] initWithBackgroundImage:nil iconImage:iconImage
                                                      title:title font:titleFont target:target action:action forButtonControlEvent:controlEvent];
}


- (void) setBackgroundImage:(UIImage*)imgBgr iconImage:(UIImage*)iconImage title:(NSString*)title
{
    _imageBackgroundV.image = imgBgr;
    _imageIconView.image = iconImage;
    _labelTitle.text = title;
}

- (void)addTarget:(id)target action:(SEL)action forButtonControlEvent:(UIControlEvents)controlEvent
{
    [_button addTarget:target action:action forControlEvents:controlEvent];
}

@end




@implementation UIToolbar (FlexSpace)

- (void) setBarButtonViewItems:(NSArray *)barButtonViewItems
{
    if (!barButtonViewItems) {
        [self setItems:barButtonViewItems]; return;
    }
    
    NSMutableArray *arrBarButtonItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *flexSpaceItem = nil;
    if (barButtonViewItems.count > 1) flexSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    for (int i = 0; i < barButtonViewItems.count; i++) {
        UIView *view = [barButtonViewItems objectAtIndex:i];
        
        if ([view isKindOfClass:[UIBarButtonItem class]]) {
            [arrBarButtonItems addObject:view];
        }
        else {
            UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:view];
            [arrBarButtonItems addObject:item];
        }
        if (i != (barButtonViewItems.count - 1) && flexSpaceItem) {
            [arrBarButtonItems addObject:flexSpaceItem];
        }
    }
    
    [self setItems:arrBarButtonItems];
}

@end















