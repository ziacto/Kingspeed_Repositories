//  UIImage+Scale.h

#import "UIImage+Scale.h"

@implementation UIImage (scale)

-(UIImage*)scaleToSize:(CGSize)size
{
    // Create a bitmap graphics context
    // This will also set it as the current context
    UIGraphicsBeginImageContext(size);
    
    // Draw the scaled image in the current context
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    // Create a new image from current context
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // Pop the current context from the stack
    UIGraphicsEndImageContext();
    
    // Return our new scaled image
    return scaledImage;
}

- (void)writeImageAsMovie:(UIImage *)image toPath:(NSString*)path width:(NSInteger)width height:(NSInteger)height{
    NSError *error = nil;
    AVAssetWriter *videoWriter = [[AVAssetWriter alloc] initWithURL: [NSURL fileURLWithPath:path] fileType:AVFileTypeMPEG4 error:&error];
    NSParameterAssert(videoWriter);
    
    NSDictionary *videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                   AVVideoCodecH264, AVVideoCodecKey,
                                   [NSNumber numberWithInt:width], AVVideoWidthKey,
                                   [NSNumber numberWithInt:height], AVVideoHeightKey,
                                   nil];
    AVAssetWriterInput* writerInput = [[AVAssetWriterInput
                                        assetWriterInputWithMediaType:AVMediaTypeVideo
                                        outputSettings:videoSettings] retain];
    
    AVAssetWriterInputPixelBufferAdaptor *adaptor = [AVAssetWriterInputPixelBufferAdaptor assetWriterInputPixelBufferAdaptorWithAssetWriterInput:writerInput sourcePixelBufferAttributes:nil];
    
    NSParameterAssert(writerInput);
    NSParameterAssert([videoWriter canAddInput:writerInput]);
    [videoWriter addInput:writerInput];
    
    //Start a session:
    [videoWriter startWriting];
    [videoWriter startSessionAtSourceTime:kCMTimeZero];
    
    CVPixelBufferRef buffer = NULL;
    buffer = [self pixelBufferFromCGImage:[image CGImage] width:width height:height];
    [adaptor appendPixelBuffer:buffer withPresentationTime:kCMTimeZero];
    CMTime presentTime = CMTimeMakeWithSeconds((videoDuration/2)+1, 1);
    [adaptor appendPixelBuffer:buffer withPresentationTime:presentTime];
    //Finish the session:
    [writerInput markAsFinished];
    [videoWriter finishWriting];
    
    CVPixelBufferPoolRelease(adaptor.pixelBufferPool);
    CVPixelBufferRelease(buffer);
    [videoWriter release];
    [writerInput release];
}


@end