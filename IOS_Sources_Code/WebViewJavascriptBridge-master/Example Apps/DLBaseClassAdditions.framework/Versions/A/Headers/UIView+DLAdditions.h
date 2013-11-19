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

#pragma mark -
#pragma mark UIView Properties ________________________________________________________________
/*********************************************************************************************/
//                                  UIView+
/*********************************************************************************************/
@interface UIView (DLFrame)

@property (nonatomic, assign) CGFloat frameX;                   // get and set frame.origin.x;
@property (nonatomic, assign) CGFloat frameY;                   // get and set frame.origin.y;
@property (nonatomic, assign) CGFloat centerX;                  // get and set center.x;
@property (nonatomic, assign) CGFloat centerY;                  // get and set center.y;
@property (nonatomic, assign) CGFloat frameWidth;               // get and set frame.size.width;
@property (nonatomic, assign) CGFloat frameHeight;              // get and set frame.size.height;

@end



@interface UIView (DLRemoveAllSubviews)
- (void)removeAllSubviews;
@end




@interface UIView (DLFromNib)

+ (UIView *)initWithNibNamed:(NSString *)nibName;

@end


@interface UIView (DLScreenshoot)

@property (nonatomic, readonly) UIImage *screenShoot;
@property (nonatomic, readonly) UIImage *image2x;

- (UIImage*)getScreenShootWithScale:(CGFloat)scale;

@end


@interface UIView (DLAutoresizingMask)
// get UIViewAutoresizing for view with mask points
// correct UIViewAutoresizing value for Views when add autoresizingMask
// YES = mask, NO = not mask
+ (UIViewAutoresizing)dlAutoresizingMaskWithLeft:(BOOL)maskLeft width:(BOOL)maskWidth right:(BOOL)maskRight
                                             top:(BOOL)maskTop height:(BOOL)maskHeight bottom:(BOOL)maskBottom;

@end



@interface UIColor (DL_RGB_HEX)

+ (UIColor*)colorWithRGBHex:(UInt32)rgbHexValue;

@end






