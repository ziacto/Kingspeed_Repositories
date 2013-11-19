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

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface UIView (additions)
@property (nonatomic, readonly) UIImage *image;

- (UIImage*)renderingImageWithScale:(CGFloat)scale;

@end
