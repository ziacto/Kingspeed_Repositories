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

+ (id)shareInstanceWithNibNamed:(NSString *)nibName;

@end


@interface UIView (DLScreenshot)

@property (nonatomic, readonly) UIImage *screenShot;    // create screenshot with scale 0.0f
@property (nonatomic, readonly) UIImage *image2x;       // create screenshot with scale 2.0f

- (UIImage*)getScreenShotWithScale:(CGFloat)scale;      // create screenshot with scale x.0f

@end


@interface UIView (DLAutoresizingMask)
// get UIViewAutoresizing for view with mask points
// correct UIViewAutoresizing value for Views when add autoresizingMask
// YES = mask, NO = not mask
+ (UIViewAutoresizing)dlAutoresizingMaskWithLeft:(BOOL)maskLeft width:(BOOL)maskWidth right:(BOOL)maskRight
                                             top:(BOOL)maskTop height:(BOOL)maskHeight bottom:(BOOL)maskBottom;
+ (UIViewAutoresizing)dlAutoresizingMaskAll;                    //Mask => Left: YES, Width: YES, Right: YES, Top: YES, Height: YES, Bottom: YES
+ (UIViewAutoresizing)dlAutoresizingMaskTopFullWidth;           //Mask => Left: YES, Width: YES, Right: YES, Top: YES, Height: NO,  Bottom: NO
+ (UIViewAutoresizing)dlAutoresizingMaskBottomFullWidth;        //Mask => Left: YES, Width: YES, Right: YES, Top: NO,  Height: NO,  Bottom: YES
+ (UIViewAutoresizing)dlAutoresizingMaskLeftFullHeight;         //Mask => Left: YES, Width: NO,  Right: NO,  Top: YES, Height: YES, Bottom: YES
+ (UIViewAutoresizing)dlAutoresizingMaskRightFullHeight;        //Mask => Left: NO,  Width: NO,  Right: YES, Top: YES, Height: YES, Bottom: YES

@end



@interface UIColor (DL_RGB_HEX)

+ (UIColor*)colorWithRGBHex:(UInt32)rgbHexValue;

@end






