/***********************************************************************
 *	File name:	ImageColorDNM.m
 *	Project:	Yamagoya_karaoke_iPad
 *	Description:
 *  Author:		Dat Nguyen Mau
 *	Device:		Iphone vs IPad
 *  Company:	Vinicorp
 *  Copyright:	8/16/11 - 2011. All right reserved.
 ***********************************************************************/

#import "ImageColorDNM.h"

static unsigned long seed;

void initRandomSeed(long firstSeed)
{ 
    seed = firstSeed;
}

float nextRandomFloat(void)
{
    return (((seed = 1664525 * seed + 1013904223) >> 16) / (float)0x10000);
}


@implementation ImageColorDNM

+ (BOOL) compareColors:(UIColor*)color1 withColor:(UIColor*)color2
{
	return CGColorEqualToColor([color1 CGColor], [color2 CGColor]);
}
+ (BOOL) compareUIColors:(UIColor*)color1 withColor:(UIColor*)color2
{
    NSString *strColor1 = [NSString stringWithFormat:@"%@",color1];
    NSString *strColor2 = [NSString stringWithFormat:@"%@",color2];
    //NSLog(@"%@",strColor1); NSLog(@"%@",strColor2);
    if ([strColor1 compare:strColor2] == NSOrderedSame) {
        return YES;
    }
    else return NO;
}

+ (UIColor*) getPixelColorAtLocation:(CGPoint)point forImage:(UIImage*)image
{   
    if (point.x < 0 || point.y < 0) return [UIColor colorWithRed:0. green:0. blue:0. alpha:0.];
    
	UIColor* color = nil;
	CGImageRef inImage = image.CGImage;
	// Create off screen bitmap context to draw the image into. Format ARGB is 4 bytes for each pixel: Alpa, Red, Green, Blue
	CGContextRef cgctx = [self createARGBBitmapContextFromImage:inImage];
	if (cgctx == NULL) { CGContextRelease(cgctx); return nil; /* error */ }
	
    size_t w = CGImageGetWidth(inImage);
	size_t h = CGImageGetHeight(inImage);
	CGRect rect = {{0,0},{w,h}}; 
	
	// Draw the image to the bitmap context. Once we draw, the memory 
	// allocated for the context for rendering will then contain the 
	// raw image data in the specified color space.
	CGContextDrawImage(cgctx, rect, inImage); 
	
	// Now we can get a pointer to the image data associated with the bitmap
	// context.
	unsigned char* data = CGBitmapContextGetData (cgctx);
	if (data != NULL) {
		//offset locates the pixel in the data from x,y. 
		//4 for 4 bytes of data per pixel, w is width of one row of data.
		int pixelInfo = 4 * ((w * round(point.y)) + round(point.x));
        
		int alpha = data[pixelInfo    ];
		int red   = data[pixelInfo + 1]; 
		int green = data[pixelInfo + 2]; 
		int blue  = data[pixelInfo + 3];
        
		//NSLog(@"offset: %i colors: RGB A %i %i %i  %i",offset,red,green,blue,alpha);
		color = [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:(blue/255.0f) alpha:(alpha/255.0f)];
	}

    // When finished, release the context
	CGContextRelease(cgctx); cgctx = nil;
    // Free image data memory for the context
	if (data) { free(data); }
	
	return color;
}

+ (UIColor*) getPixelColorAtLocationWithoutCGContext:(CGPoint)point forImage:(UIImage*)image
{
    if (point.x < 0 || point.y < 0) return [UIColor colorWithRed:0. green:0. blue:0. alpha:0.];
    
    UIColor* color = nil;
    // Now we can get a pointer to the image data associated with the bitmap
    // context.
    CFDataRef pixelData = CGDataProviderCopyData(CGImageGetDataProvider(image.CGImage));
    const UInt8* data = CFDataGetBytePtr(pixelData);
    
    if (data != NULL)
    {
        // **** You have a pointer to the image data ****
        
        int pixelInfo = ((image.size.width  * point.y) + point.x ) * 4; // The image is png
        
        UInt8 red   = data[pixelInfo    ];      // If you need this info, enable it
        UInt8 green = data[pixelInfo + 1];      // If you need this info, enable it
        UInt8 blue  = data[pixelInfo + 2];      // If you need this info, enable it
        UInt8 alpha = data[pixelInfo + 3];      // If need only this info for my maze game
        
        CFRelease(pixelData);
        
        color = [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:(blue/255.0f) alpha:(alpha/255.0f)];
    }
    
    // Free image data memory for the context
    if (data)
    {
        data = nil;
    }
    return color;
}


+ (CGContextRef) createARGBBitmapContextFromImage:(CGImageRef) inImage
{	
	CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace;
    void *          bitmapData;
    int             bitmapByteCount;
    int             bitmapBytesPerRow;
    
    // Get image width, height. We'll use the entire image.
    size_t pixelsWide = CGImageGetWidth(inImage);
    size_t pixelsHigh = CGImageGetHeight(inImage);
    
    // Declare the number of bytes per row. Each pixel in the bitmap in this
    // example is represented by 4 bytes; 8 bits each of red, green, blue, and
    // alpha.
    bitmapBytesPerRow   = (pixelsWide * 4);
    bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
    
    // Use the generic RGB color space.
//    colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
    colorSpace = CGColorSpaceCreateDeviceRGB();
    
    if (colorSpace == NULL)
    {
        fprintf(stderr, "Error allocating color space\n");
        return NULL;
    }
    
    // Allocate memory for image data. This is the destination in memory
    // where any drawing to the bitmap context will be rendered.
    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL) 
    {
        fprintf (stderr, "Memory not allocated!");
        CGColorSpaceRelease( colorSpace );
        return NULL;
    }
    
    // Create the bitmap context. We want pre-multiplied ARGB, 8-bits 
    // per component. Regardless of what the source image format is 
    // (CMYK, Grayscale, and so on) it will be converted over to the format
    // specified here by CGBitmapContextCreate.
    context = CGBitmapContextCreate (bitmapData,
                                     pixelsWide,
                                     pixelsHigh,
                                     8,      // bits per component
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     kCGImageAlphaPremultipliedFirst);
    if (context == NULL)
    {
        free (bitmapData);
        fprintf (stderr, "Context not created!");
    }
    
    // Make sure and release colorspace before returning
    CGColorSpaceRelease( colorSpace );
    
    return context;
}


@end
