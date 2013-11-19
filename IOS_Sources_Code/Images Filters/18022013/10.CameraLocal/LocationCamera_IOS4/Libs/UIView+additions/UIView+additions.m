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

#import "UIView+additions.h"

@implementation UIView (additions)

- (UIImage*)image
{
    return [self renderingImageWithScale:2.];
}

- (UIImage*)renderingImageWithScale:(CGFloat)scale
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, scale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

@end
