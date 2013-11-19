/***********************************************************************
 *	File name:	CustomBadge.h
 *	Project:	Photo Albums
 *	Description:
 *  Author:		Dat Nguyen Mau
 *  Created:    on 3/1/12.
 *	Device:		Iphone vs IPad
 *  Company:	__MyCompanyName__
 *  Copyright:	2012 . All rights reserved.
 ***********************************************************************/


#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface CustomBadge : UIView {
	
	NSString *badgeText;
	UIColor *badgeTextColor;
	UIColor *badgeInsetColor;
	UIColor *badgeFrameColor;
	BOOL badgeFrame;
	BOOL badgeShining;
	CGFloat badgeCornerRoundness;
	CGFloat badgeScaleFactor;
}

@property(nonatomic, retain) NSString *badgeText;
@property(nonatomic, retain) UIColor *badgeTextColor;
@property(nonatomic, retain) UIColor *badgeInsetColor;
@property(nonatomic, retain) UIColor *badgeFrameColor;

@property(nonatomic, readwrite) BOOL badgeFrame;
@property(nonatomic, readwrite) BOOL badgeShining;

@property(nonatomic, readwrite) CGFloat badgeCornerRoundness;
@property(nonatomic, readwrite) CGFloat badgeScaleFactor;

+ (CustomBadge*) customBadgeWithString:(NSString *)badgeString;
+ (CustomBadge*) customBadgeWithString:(NSString *)badgeString withStringColor:(UIColor*)stringColor withInsetColor:(UIColor*)insetColor withBadgeFrame:(BOOL)badgeFrameYesNo withBadgeFrameColor:(UIColor*)frameColor withScale:(CGFloat)scale withShining:(BOOL)shining;
- (void) autoBadgeSizeWithString:(NSString *)badgeString;

@end
