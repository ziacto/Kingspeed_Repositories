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
/*********************************************************************************************/
//                                  DLButtonToolbar+
/*********************************************************************************************/
@class DLButtonToolbar;
@protocol DLButtonToolbarDelegate <NSObject>
@optional
- (void)dlButtonToolbarDidBeganClick:(DLButtonToolbar*)btnToolbar;              // action for touchDown on button
- (void)dlButtonToolbarDidEndOutSideButton:(DLButtonToolbar*)btnToolbar;        // end at outside of button
- (void)dlButtonToolbarDidEndClickButton:(DLButtonToolbar*)btnToolbar;          // action for touchUpInside on button

@end

/*
 custom button for 1 icon at top, 1 title at bottom (for UIToolbar)
 */
typedef enum {
    DLButtonDisable = 0,    // set Enable = NO for all subviews
    DLButtonEnable,         // set Enable = YES,
    DLButtonDisableIcon,    // set Enable = NO for all subviews without lable
}DLButtonEnableType;

@interface DLButtonToolbar : UIView

@property (nonatomic, assign) IBOutlet id<DLButtonToolbarDelegate> delegate;

@property (nonatomic, retain) DLLabel *labelTitle;
@property (nonatomic, retain) UIImageView *iconImageView;

@property (nonatomic, assign) BOOL showsTouchWhenHighlighted; // default is YES,

// enable button
@property (nonatomic, assign) DLButtonEnableType enable;      // set enable all subviews like as [UIButton enable]
// init - return object autorelease
+ (DLButtonToolbar*)buttonWithTitle:(NSString*)title_ frame:(CGRect)frame_ normalImage:(NSString*)normalImage highlightImage:(NSString*)highlightImage delegate:(id)delegate__;
+ (DLButtonToolbar*)buttonWithTitle:(NSString*)title_ frame:(CGRect)frame_ normalImage:(NSString*)normalImage highlightImage:(NSString*)highlightImage
                             target:(id)target action:(SEL)action forButtonControlEvent:(UIControlEvents)controlEvent;
- (void)addTarget:(id)target action:(SEL)action forButtonControlEvent:(UIControlEvents)controlEvent;

@end


/*********************************************************************************************/
//                                  DLToolbar+
/*********************************************************************************************/
@interface UIToolbar (DLButtonToolbar)

- (void)setDLButtonToolbarItems:(NSArray*)buttonViews animated:(BOOL)animated;
- (void)setItemsAnimated:(BOOL)animated withCustomViews:(id) first, ... NS_REQUIRES_NIL_TERMINATION;

@end



// DLToolbar will be modify setBackgroundColor of UIToolbar if backgroundColor is Clear Color.
@interface DLToolbar: UIToolbar

@property (nonatomic, retain) UIImage *dlBackgroundImage;

@end


/*********************************************************************************************/
//                                  DLBarButtonsAndToolbar+
/*********************************************************************************************/
@interface NSObject (DLBarButtonsAndToolbar)

- (NSMutableArray*)barButtonItemsForArrayCustomViews:(NSArray*)buttonViews;
- (NSMutableArray*)barButtonItemsForCustomViews:(id) first, ... NS_REQUIRES_NIL_TERMINATION;

@end




@interface UIButton (DLUIButton)

+ (id)buttonWithType:(UIButtonType)buttonType imageNormal:(UIImage*)img frame:(CGRect)frame withTarget:(id)target
              action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

@end





