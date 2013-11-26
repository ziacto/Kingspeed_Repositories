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
+ (BOOL)isRetinaScreen;
+ (BOOL)isIOS7OrLater;
+ (float)iosVersion;
+ (BOOL)is3_5Inch;
+ (BOOL)isRetina4Inch;                          // YES if device is 4-inch Retina screen
+ (BOOL)isIpadDevice;                           // YES if device is iPad
+ (BOOL)statusBarOrientationIsPortrait;         // YES if device orientation is portrait or portraitupsidedown
+ (BOOL)recallDeviceOrientationWithOrientation:(UIInterfaceOrientation)interfaceOrientation;
+ (BOOL)recallDeviceOrientationWithOrientation:(UIInterfaceOrientation)interfaceOrientation afterDelay:(NSTimeInterval)duration;

//UIScreen Size
+ (CGRect)mainScreenBounds;
// return mainScreen height;
+ (float)mainScreenHeight;
// return mainScreen width;
+ (float)mainScreenWidth;

@end




