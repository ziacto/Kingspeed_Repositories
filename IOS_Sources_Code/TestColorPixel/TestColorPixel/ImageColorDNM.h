/***********************************************************************
 *	File name:	ImageColorDNM.h
 *	Project:	Yamagoya_karaoke_iPad
 *	Description:
 *  Author:		Dat Nguyen Mau
 *	Device:		Iphone vs IPad
 *  Company:	Vinicorp
 *  Copyright:	8/16/11 - 2011. All right reserved.
 ***********************************************************************/

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreFoundation/CoreFoundation.h>

void initRandomSeed(long firstSeed);
float nextRandomFloat(void);


@interface ImageColorDNM : NSObject {

}
+ (BOOL) compareColors:(UIColor*)color1 withColor:(UIColor*)color2;
+ (BOOL) compareUIColors:(UIColor*)color1 withColor:(UIColor*)color2;
+ (UIColor*) getPixelColorAtLocation:(CGPoint)point forImage:(UIImage*)image;
+ (UIColor*) getPixelColorAtLocationWithoutCGContext:(CGPoint)point forImage:(UIImage*)image;
+ (CGContextRef) createARGBBitmapContextFromImage:(CGImageRef) inImage;

@end
