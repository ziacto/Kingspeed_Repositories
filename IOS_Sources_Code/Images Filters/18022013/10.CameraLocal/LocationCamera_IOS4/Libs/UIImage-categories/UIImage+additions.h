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

/*****************************************************************************************/
/*****************************************************************************************/
#pragma mark -
#pragma mark UIImage (additions) Methods ___________________________________________________________________

@interface UIImage (additions)

+ (UIImage*)processImageFromCamera:(UIImage*)imageFromCamera;
+ (UIImage*)processImage:(UIImage*)imageProcess withOrientation:(UIImageOrientation)imageOrientation;
- (UIImage*) getSubImageWithRect: (CGRect) rect;
+ (UIImage*)imageByCropping:(UIImage *)imageToCrop toRect:(CGRect)aperture withOrientation:(UIImageOrientation)orientation;
- (UIImage*)scaleToSize:(CGSize)size;
-(UIImage*)flip:(BOOL)horizontal;
@end


/*****************************************************************************************/
/*****************************************************************************************/
#pragma mark -
#pragma mark UIImage (Resize) Methods ___________________________________________________________________

@interface UIImage (Resize)
- (UIImage *)croppedImage:(CGRect)bounds;
- (UIImage *)thumbnailImage:(NSInteger)thumbnailSize
          transparentBorder:(NSUInteger)borderSize
               cornerRadius:(NSUInteger)cornerRadius
       interpolationQuality:(CGInterpolationQuality)quality;
- (UIImage *)resizedImage:(CGSize)newSize
     interpolationQuality:(CGInterpolationQuality)quality;
- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode
                                  bounds:(CGSize)bounds
                    interpolationQuality:(CGInterpolationQuality)quality;

- (UIImage *)resizedImage:(CGSize)newSize
                transform:(CGAffineTransform)transform
           drawTransposed:(BOOL)transpose
     interpolationQuality:(CGInterpolationQuality)quality;
- (CGAffineTransform)transformForOrientation:(CGSize)newSize;
@end


/*****************************************************************************************/
/*****************************************************************************************/
#pragma mark -
#pragma mark UIImage (Alpha) Methods ___________________________________________________________________

@interface UIImage (Alpha)
- (BOOL)hasAlpha;
- (UIImage *)imageWithAlpha;
- (UIImage *)transparentBorderImage:(NSUInteger)borderSize;

- (CGImageRef)newBorderMask:(NSUInteger)borderSize size:(CGSize)size;
@end


/*****************************************************************************************/
/*****************************************************************************************/
#pragma mark -
#pragma mark UIImage (RoundedCorner) Methods ___________________________________________________________________

@interface UIImage (RoundedCorner)
- (UIImage *)roundedCornerImage:(NSInteger)cornerSize borderSize:(NSInteger)borderSize;
- (void)addRoundedRectToPath:(CGRect)rect context:(CGContextRef)context ovalWidth:(CGFloat)ovalWidth ovalHeight:(CGFloat)ovalHeight;
@end


/*****************************************************************************************/
/*****************************************************************************************/
#pragma mark -
#pragma mark UIImage (Color) Methods ___________________________________________________________________
@interface UIImage (Color)

- (UIImage*)changeColor:(UIColor*)color;
- (UIImage *) changeImageBrightness: (UIImage *) anImage amount: (CGFloat) amount;
- (UIImage*)abcd;

@end
