/***********************************************************************
 *	File name:	OneObjectView.h
 *	Project:	Photo Albums
 *	Description:
 *  Author:		Dat Nguyen Mau
 *  Created:    on 3/1/12.
 *	Device:		Iphone vs IPad
 *  Company:	__MyCompanyName__
 *  Copyright:	2012 . All rights reserved.
 ***********************************************************************/

#import <UIKit/UIKit.h>
#import "MacroObjectLauncher.h"
#import "CustomBadge.h"

@class CustomBadge;

@protocol OneObjectViewDelegate <NSObject>
-(void)didDeleteItem:(id)item;
@end

@interface OneObjectView : UIControl {	
	BOOL dragging;
	BOOL deletable;
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *image;
@property (nonatomic, retain) NSString *iPadImage;
@property (nonatomic, retain) NSString *controllerStr;
@property (nonatomic, retain) NSString *controllerTitle;
@property (nonatomic, retain) UIButton *closeButton;
@property (nonatomic, retain) CustomBadge *badge;

@property (nonatomic, retain) UIImageView *imagelabelPath;

-(id)initWithTitle:(NSString *)title image:(NSString *)image target:(NSString *)targetControllerStr deletable:(BOOL)_deletable;
-(id)initWithTitle:(NSString *)title iPhoneImage:(NSString *)image iPadImage:(NSString *)iPadImage backgrImage:(UIImage *)backgrImage target:(NSString *)targetControllerStr targetTitle:(NSString *)targetTitle deletable:(BOOL)_deletable;
-(void)layoutItem;
-(void)setDragging:(BOOL)flag;
-(BOOL)dragging;
-(BOOL)deletable;

-(NSString *)badgeText;
-(void)setBadgeText:(NSString *)text;
-(void)setCustomBadge:(CustomBadge *)customBadge;

- (void)startWiggling;
- (void)stopWiggling;

@end
