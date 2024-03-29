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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#import <DLBaseClassAdditions/DLBaseViewController.h>
#import <DLBaseClassAdditions/DLButtonToolbar.h>
#import <DLBaseClassAdditions/DLDevice.h>
#import <DLBaseClassAdditions/UINavigation+DLAdditions.h>
#import <DLBaseClassAdditions/NSString+ DLAdditions.h>
#import <DLBaseClassAdditions/DLAppicationState.h>
#import <DLBaseClassAdditions/NSDate-Utilities.h>
#import <DLBaseClassAdditions/TimeFormatters.h>
#import <DLBaseClassAdditions/UIView+DLAdditions.h>
#import <DLBaseClassAdditions/DLLabel.h>
#import <DLBaseClassAdditions/DLAppLanguage+Font.h>


#define IS_DL_IPHONE5 ([DLDevice isIphone5OrLater])

#define DLPrintfPretty(debugLog,fmt, ...) DLPrintf(debugLog, (@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#define DLLogsPretty(debugLog,fmt, ...) DLLog(debugLog, (@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


// Deprecated, you can't use NSLog, you must be use DLLogs or DLPrintf instead,
//FOUNDATION_EXPORT void NSLog(NSString *format, ...) NS_FORMAT_FUNCTION(1,2);

FOUNDATION_EXPORT void DLPrintf(BOOL debugLog, NSString* format,...)NS_FORMAT_FUNCTION(2,3);          // if log == NO, not show logs
FOUNDATION_EXPORT void DLLog(BOOL debugLog, NSString* format,...)NS_FORMAT_FUNCTION(2,3);             // if log == NO, not show logs

/*          Require: QuartzCore.framework           */
/*          Require: -ObjC in "Other Linker Flags" to using for Category Functions */
/*          This framework made by Dat Nguyen Mau   */
/*
 This is for basic functions for your project
 */

// use for Navigation category functions with has no -ObjC in setting project.
@interface DLNavigationController : UINavigationController

@end


// use for NSDate category funcstion with has no -ObjC in setting project.
@interface DLDate : NSDate

@end





//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
//#pragma clang diagnostic pop







