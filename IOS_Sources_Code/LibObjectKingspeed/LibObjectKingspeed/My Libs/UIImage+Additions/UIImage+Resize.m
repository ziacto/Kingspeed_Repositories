// UIImage+Resize.m
// Created by Trevor Harmon on 8/5/09.
// Free for personal or commercial use, with or without modification.
// No warranty is expressed or implied.

#import "UIImage+Resize.h"
#import "UIImage+RoundedCorner.h"
#import "UIImage+Alpha.h"

@implementation UIImage (Resize)

// Returns a copy of this image that is cropped to the given bounds.
// The bounds will be adjusted using CGRectIntegral.
// This method ignores the image's imageOrientation setting.
- (UIImage *)croppedImage:(CGRect)bounds {
	CGRect newBounds = CGRectIntegral(CGRectMake(bounds.origin.x * self.scale, bounds.origin.y * self.scale, bounds.size.width * self.scale, bounds.size.height * self.scale));
	CGImageRef croppedImageRef = CGImageCreateWithImageInRect([self CGImage], newBounds);
	UIImage *croppedImage = [UIImage imageWithCGImage:croppedImageRef scale:0.0 orientation:self.imageOrientation];
	CFRelease(croppedImageRef);
	return croppedImage;
}

// Returns a copy of this image that is squared to the thumbnail size.
// If transparentBorder is non-zero, a transparent border of the given size will be added around the edges of the thumbnail. (Adding a transparent border of at least one pixel in size has the side-effect of antialiasing the edges of the image when rotating it using Core Animation.)
- (UIImage *)thumbnailImage:(NSInteger)thumbnailSize
          transparentBorder:(NSUInteger)borderSize
               cornerRadius:(NSUInteger)cornerRadius
       interpolationQuality:(CGInterpolationQuality)quality {
	UIImage *resizedImage = [self resizedImageWithContentMode:UIViewContentModeScaleAspectFill
																										 bounds:CGSizeMake(thumbnailSize, thumbnailSize)
																			 interpolationQuality:quality];
	
	// Crop out any part of the image that's larger than the thumbnail size
	// The cropped rect must be centered on the resized image
	// Round the origin points so that the size isn't altered when CGRectIntegral is later invoked
	CGRect cropRect = CGRectMake(round((resizedImage.size.width - thumbnailSize) / 2),
															 round((resizedImage.size.height - thumbnailSize) / 2),
															 thumbnailSize,
															 thumbnailSize);
	UIImage *croppedImage = [resizedImage croppedImage:cropRect];
	
	UIImage *transparentBorderImage = borderSize ? [croppedImage transparentBorderImage:borderSize] : croppedImage;
	
	return [transparentBorderImage roundedCornerImage:cornerRadius borderSize:borderSize];
}

// Returns a rescaled copy of the image, taking into account its orientation
// The image will be scaled disproportionately if necessary to fit the bounds specified by the parameter
- (UIImage *)resizedImage:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality {
	CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width * self.scale, newSize.height * self.scale));
	
	UIImage *newImage;
	UIGraphicsBeginImageContextWithOptions(newRect.size, NO, 0.0);
	newImage = [UIImage imageWithCGImage:[self CGImage] scale:0.0 orientation:self.imageOrientation];
	[newImage drawInRect:newRect];
	newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return newImage;
}

// Resizes the image according to the given content mode, taking into account the image's orientation
- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode
                                  bounds:(CGSize)bounds
                    interpolationQuality:(CGInterpolationQuality)quality {
	CGFloat horizontalRatio = bounds.width / self.size.width;
	CGFloat verticalRatio = bounds.height / self.size.height;
	CGFloat ratio;
	
	switch (contentMode) {
		case UIViewContentModeScaleAspectFill:
			ratio = MAX(horizontalRatio, verticalRatio);
			break;
			
		case UIViewContentModeScaleAspectFit:
			ratio = MIN(horizontalRatio, verticalRatio);
			break;
			
		default:
			[NSException raise:NSInvalidArgumentException format:@"Unsupported content mode: %d", contentMode];
	}
	
	CGSize newSize = CGSizeMake(self.size.width * ratio, self.size.height * ratio);
	
	return [self resizedImage:newSize interpolationQuality:quality];
}

@end
