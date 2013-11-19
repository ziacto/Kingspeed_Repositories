//
//  Nostalgia.m
//  CameraPlus
//
//  Created by Karl von Randow on 18/09/10.
//  Copyright 2010 Taptaptap. All rights reserved.
//

#import "Nostalgia.h"


@implementation Nostalgia

- (void)_apply:(CGContextRef)bitmapContext {
	/* Clone the current image, blur it and then composite it back ontop of the original image with 33% soft light blend mode. */
	blurContext = BitmapContextCreateClone(bitmapContext);
	BitmapContextBlur(blurContext, 40);
	BitmapContextComposite(bitmapContext, blurContext, 0.33, kCGBlendModeSoftLight);
	BitmapContextRelease(blurContext);

	/* Draw a film grain tiling image over the image with 40% overlay blend mode. 
	 * Choose a smaller tile if the target image is a thumbnail, to improve performance.
	 */
	BitmapContextCompositeTiledImageNamed(bitmapContext,
		CGBitmapContextGetWidth(bitmapContext) <= 200 &&
		CGBitmapContextGetHeight(bitmapContext) <= 200 ?
		@"fx-film-filmgrain-thumb.jpg" : @"fx-film-filmgrain.jpg",
		0.4, kCGBlendModeOverlay);

	/* Draw a stone texture over the image, but masked so that it draws around the edges of the image.
	 * Create an overlay image the same size as the original and draw the tiled image in it.
	 */
	CGContextRef overlayContext = BitmapContextCreateWithTemplate(bitmapContext);
	BitmapContextCompositeTiledImageNamed(overlayContext, @"fx-film-nostalgia-stone.jpg", 1.0, kCGBlendModeNormal);
	/* Create the mask image, the same size as the original, draw the masking image into it. */
	CGContextRef maskContext = BitmapContextCreateWithTemplate(bitmapContext);
	BitmapContextCompositeImageNamed(maskContext, @"fx-film-mask.jpg", 1.0, kCGBlendModeNormal);
	/* Apply the mask to the overlay image and then composite the overlay with the original image using 45% overlay blend mode.
	 * This composite respects the alpha channel, whereas other compositing ignores it for performance.
	 */
	BitmapContextApplyMask(overlayContext, maskContext);
	BitmapContextAlphaComposite(bitmapContext, overlayContext, YES, 0.45, kCGBlendModeOverlay);

	/* Replace the previous overlay with the special-sauce nostalgia brown tiled image, then repeat the masking
	 * and compositing process above.
	 */
	BitmapContextCompositeTiledImageNamed(overlayContext, @"fx-film-nostalgia-brown.jpg", 1.0, kCGBlendModeNormal);
	BitmapContextApplyMask(overlayContext, maskContext);
	BitmapContextAlphaComposite(bitmapContext, overlayContext, YES, 1.0, kCGBlendModeSoftLight);
	BitmapContextRelease(overlayContext);
	BitmapContextRelease(maskContext);

	/* Draw a white vignette "centre spotlight" using 50% overlay blend mode */
	BitmapContextVignetteRGBBlend(bitmapContext, 0xffffff, 1.05, 0.5, kCGBlendModeOverlay);

	/* Draw a black vignette using 50% overlay blend mode */
	BitmapContextVignetteRGBBlend(bitmapContext, 0x000000, 1.5, 0.5, kCGBlendModeOverlay);

	/* Increase the saturation 30%, applied with 50% normal blend mode */
	BitmapContextSaturateBlend(bitmapContext, 1.3, 0.5, kCGBlendModeNormal);

	/* Curves for red, green and blue.
	 * R: 52, 84 / 192, 177 / 255, 222
	 * G: 60, 66 / 207, 180
	 * B: 27, 0 / 225, 255
	 */
	const double curveR[] = { -4.844560000, 7.485810000, -2.417520000, 0.776277000, -0.000000000 };
	const double curveG[] = { -1.415160000, 1.904100000, 0.511063000, -0.000000000 };
	const double curveB[] = { 0.776471000, 0.105882000 };
	BitmapContextPolynomialFunctionChannels(bitmapContext, 5, curveR, 4, curveG, 2, curveB);

	/* Fill with #f21bef using a 10% colour blend mode */
	BitmapContextColorComposite(bitmapContext, 0xf21bef, 0.10, kCGBlendModeColor);

	/* Levels for red, green and blue, using a 30% normal blend mode */
	BitmapContextLevelsChannelsBlend(bitmapContext, 0, 1.0, 255, 0, 255,
							0, 1.0, 235, 0, 255,
							0, 1.0, 242, 0, 255,
							0, 1.0, 253, 0, 200,
							0.3, kCGBlendModeNormal);
}

@end
