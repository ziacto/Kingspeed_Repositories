/***********************************************************************
 *	File name:	UIBarButtonView.h
 *	Project:	
 *	Description:
 *  Author:		Dat Nguyen Mau
 *  Created:    on 23/10/2012.
 *	Device:		Iphone vs IPad
 *  Company:	__MyCompanyName__
 *  Copyright:	2012 . All rights reserved.
 ***********************************************************************/

#import <UIKit/UIKit.h>

@interface UIBarButtonView : UIView
{
    IBOutlet UILabel *_labelTitle;
    IBOutlet UIImageView *_imageBackgroundV;
    IBOutlet UIImageView *_imageIconView;
    IBOutlet UIButton *_button;
}

@property (nonatomic, strong) UILabel *labelTitle;
@property (nonatomic, strong) UIImageView *imageBackgroundV;
@property (nonatomic, strong) UIImageView *imageIconView;
@property (nonatomic, strong) UIButton *button;

- (id) initWithBackgroundImage:(UIImage*)imgBgr iconImage:(UIImage*)iconImage title:(NSString*)title font:(UIFont*)titleFont
              target:(id)target action:(SEL)action forButtonControlEvent:(UIControlEvents)controlEvent;

- (id) initWithIconImage:(UIImage*)iconImage title:(NSString*)title font:(UIFont*)titleFont
                        target:(id)target action:(SEL)action forButtonControlEvent:(UIControlEvents)controlEvent;

- (void) setBackgroundImage:(UIImage*)imgBgr iconImage:(UIImage*)iconImage title:(NSString*)title;
- (void)addTarget:(id)target action:(SEL)action forButtonControlEvent:(UIControlEvents)controlEvent;

@end



@interface UIToolbar (FlexSpace)

- (void) setBarButtonViewItems:(NSArray *)barButtonViewItems;

@end



