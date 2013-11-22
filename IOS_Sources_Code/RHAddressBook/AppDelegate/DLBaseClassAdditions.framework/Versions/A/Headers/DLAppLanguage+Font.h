/***********************************************************************
 *	File name:	___________
 *	Project:	___________
 *	Description:
 *  Author:		Dat Nguyen Mau
 *  Created:    on 9/4/2013.
 *	Device:		Iphone vs IPad
 *  Company:	__MyCompanyName__
 *  Copyright:	2012 . All rights reserved.
 ***********************************************************************/

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define     DL_APPLE_LANGUAGE_KEY  @"AppleLanguages"


typedef enum {
    DLAppLanguageTypeOther = 0,
    DLAppLanguageTypeJapanese,
    DLAppLanguageTypeEnglish,
    DLAppLanguageTypeChinese
} DLAppLanguageType;


@interface DLAppLanguage: NSObject

+ (DLAppLanguageType)deviceLanguageType;
+ (NSString*)getDeviceLanguage;             // get language from device setting with NSLocale

+ (NSArray*)getAppLanguage;
+ (DLAppLanguageType)appLanguageType;       // get language from app setting with NSUserDefaults

+ (void)setAppLanguage:(NSArray*)arrLanguage;
+ (void)setAppLanguageEnglish;
+ (void)setAppLanguageJapanese;
+ (void)setAppLanguageChinese;


@end

@interface UIFont (DLSystemFont)

//===================================================================
//===================================================================
+ (UIFont*)systemHiraKakuProN_W6:(CGFloat)fsize;                 // HiraKakuProN-W6 font
+ (UIFont*)systemHiraKakuProN_W3:(CGFloat)fsize;                 // HiraKakuProN-W3 font
+ (UIFont*)systemChineseFontMedium:(CGFloat)fsize;              // STHeitiSC-Medium font
+ (UIFont*)systemChineseFontLight:(CGFloat)fsize;               // STHeitiSC-Light font
+ (UIFont*)systemHelveticaBold:(CGFloat)fsize;                  // Helvetica-Bold font
+ (UIFont*)systemHelveticaLight:(CGFloat)fsize;                 // Helvetica-Light font
+ (UIFont*)systemHelveticaNeue:(CGFloat)fsize;                  // HelveticaNeue font
+ (UIFont*)systemHelveticaNeueMedium:(CGFloat)fsize;            // HelveticaNeue-Medium font
//===================================================================
//===================================================================

@end
