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

@interface UIDevice (additions)
+ (float)iosVersion;
- (void) recallDeviceOrientationWithOrientation:(UIInterfaceOrientation)interfaceOrientation;
+ (BOOL)isIphone5OrLater;
@end
