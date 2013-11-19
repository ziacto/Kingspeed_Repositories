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

@interface DLDevice: UIDevice

@property (nonatomic, readonly) NSString *machine;

+ (NSString*)machine;
+ (float)iosVersion;
+ (BOOL)isIphone5OrLater;                       // YES if device is iPhone5 or later
+ (BOOL)isIpadDevice;                           // YES if device is iPad
+ (BOOL)statusBarOrientationMaskAllPortrait;    // YES if device orientation is portrait or portraitupsidedown
+ (BOOL)recallDeviceOrientationWithOrientation:(UIInterfaceOrientation)interfaceOrientation;
+ (BOOL)recallDeviceOrientationWithOrientation:(UIInterfaceOrientation)interfaceOrientation afterDelay:(NSTimeInterval)duration;

//UIScreen Size
// return mainScreen height;
+ (float)mainScreenHeight;
// return mainScreen width;
+ (float)mainScreenWidth;

@end




