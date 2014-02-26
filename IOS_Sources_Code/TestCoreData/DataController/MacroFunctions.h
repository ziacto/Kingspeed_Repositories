/***********************************************************************
 *	File name:	MacroFunctions.h
 *	Project:	Universal
 *	Description:
 *  Author:		Dat Nguyen Mau
 *  Created:    on 10/8/12.
 *	Device:		Iphone vs IPad
 *  Company:	__MyCompanyName__
 *  Copyright:	2012 . All rights reserved.
 ***********************************************************************/

#import <Foundation/Foundation.h>

#define     APP_DELEGATE    [[UIApplication sharedApplication] delegate]

#define trimSpaceNSString( object ) [object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];


#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]