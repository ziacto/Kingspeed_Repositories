//
//  FaceDetect.m
//  FaceDetectionExample
//
//  Created by iMac02 on 2012/7/19.
//  Copyright (c) 2012 JID Marketing. All rights reserved.
//

#import "FaceDetectView.h"

@interface FaceDetectView ()
{
    UIImageView *_tempImageView;
}
-(UIImage *) captureView:(UIView*) view compress:(BOOL)compress ratioResolution:(CGFloat)resolution;

@end

@implementation FaceDetectView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor blackColor];
//        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//        self.contentMode = UIViewContentModeScaleAspectFit;
    }
    return self;
}

- (void) awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor blackColor];
//    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    self.contentMode = UIViewContentModeScaleAspectFit;
}

-(void)markFaces:(UIImageView *)facePicture
{
    // draw a CI image with the previously loaded face detection picture
    CIImage* image = [CIImage imageWithCGImage:facePicture.image.CGImage];
    
    // create a face detector - since speed is not an issue we'll use a high accuracy
    // detector
    CIDetector* detector = [CIDetector detectorOfType:CIDetectorTypeFace 
                                              context:nil options:[NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh forKey:CIDetectorAccuracy]];
    
    // create an array containing all the detected faces from the detector    
    NSArray* features = [detector featuresInImage:image];
    
    // we'll iterate through every detected face.  CIFaceFeature provides us
    // with the width for the entire face, and the coordinates of each eye
    // and the mouth if detected.  Also provided are BOOL's for the eye's and
    // mouth so we can check if they already exist.
    for(CIFaceFeature* faceFeature in features)
    {
        // get the width of the face
        CGFloat faceWidth = faceFeature.bounds.size.width;
        
        // create a UIView using the bounds of the face
        UIView* faceView = [[UIView alloc] initWithFrame:faceFeature.bounds];
        
        // add a border around the newly created UIView
        faceView.layer.borderWidth = 1;
        faceView.layer.borderColor = [[UIColor redColor] CGColor];
        
        // add the new view to create a box around the face
        [_tempImageView addSubview:faceView];
        
        if(faceFeature.hasLeftEyePosition)
        {
            // create a UIView with a size based on the width of the face
            UIView* leftEyeView = [[UIView alloc] initWithFrame:CGRectMake(faceFeature.leftEyePosition.x-faceWidth*0.15, faceFeature.leftEyePosition.y-faceWidth*0.15, faceWidth*0.3, faceWidth*0.3)];
            // change the background color of the eye view
            [leftEyeView setBackgroundColor:[[UIColor blueColor] colorWithAlphaComponent:0.3]];
            // set the position of the leftEyeView based on the face
            [leftEyeView setCenter:faceFeature.leftEyePosition];
            // round the corners
            leftEyeView.layer.cornerRadius = faceWidth*0.15;
            // add the view to the window
            [_tempImageView addSubview:leftEyeView];
        }
        
        if(faceFeature.hasRightEyePosition)
        {
            // create a UIView with a size based on the width of the face
            UIView* leftEye = [[UIView alloc] initWithFrame:CGRectMake(faceFeature.rightEyePosition.x-faceWidth*0.15, faceFeature.rightEyePosition.y-faceWidth*0.15, faceWidth*0.3, faceWidth*0.3)];
            // change the background color of the eye view
            [leftEye setBackgroundColor:[[UIColor blueColor] colorWithAlphaComponent:0.3]];
            // set the position of the rightEyeView based on the face
            [leftEye setCenter:faceFeature.rightEyePosition];
            // round the corners
            leftEye.layer.cornerRadius = faceWidth*0.15;
            // add the new view to the window
            [_tempImageView addSubview:leftEye];
        }
        
        if(faceFeature.hasMouthPosition)
        {
            // create a UIView with a size based on the width of the face
            UIView* mouth = [[UIView alloc] initWithFrame:CGRectMake(faceFeature.mouthPosition.x-faceWidth*0.2, faceFeature.mouthPosition.y-faceWidth*0.2, faceWidth*0.4, faceWidth*0.4)];
            // change the background color for the mouth to green
            [mouth setBackgroundColor:[[UIColor greenColor] colorWithAlphaComponent:0.3]];
            // set the position of the mouthView based on the face
            [mouth setCenter:faceFeature.mouthPosition];
            // round the corners
            mouth.layer.cornerRadius = faceWidth*0.2;
            // add the new view to the window
            [_tempImageView addSubview:mouth];
        }
    }
    
    [self performSelectorInBackground:@selector(refreshImage:) withObject:facePicture];
}


- (void) faceDetector:(UIImage*) image
{
    for (id view in self.subviews) [view removeFromSuperview];
    
    // Load the picture for face detection
    UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
    _tempImageView = [[UIImageView alloc] initWithFrame:imageView.frame];
    [_tempImageView addSubview:imageView];
    
    // Execute the method used to markFaces in background
    [self performSelectorInBackground:@selector(markFaces:) withObject:imageView];
}

- (void) refreshImage:(UIImageView*) imgView
{
    [imgView setTransform:CGAffineTransformMakeScale(1, -1)];
    [_tempImageView setTransform:CGAffineTransformMakeScale(1, -1)];
    self.image = [self captureView:_tempImageView compress:YES ratioResolution:1.];
    [imgView removeFromSuperview]; [_tempImageView removeFromSuperview];
}

-(UIImage *) captureView:(UIView*) view compress:(BOOL)compress ratioResolution:(CGFloat)resolution
{
	UIGraphicsBeginImageContextWithOptions(view.bounds.size,compress,resolution);
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetInterpolationQuality(context,kCGInterpolationHigh);
	CGContextSetAlpha(context, 1.0);
	CGContextTranslateCTM (context,0,view.bounds.size.height);
	CGContextScaleCTM (context, 1.0, -1.0);
	CGContextFillPath(context);
	[view.layer renderInContext:context];
	UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
    // write to file in document
//    NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(viewImage)];
//	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//	NSString *documentsDirectory = [paths objectAtIndex:0];
//	NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"test.png"];
//	[imageData writeToFile:filePath atomically:YES];
    
	return viewImage;
}

-(void) shootingGraphToPhotosAlbum:(BOOL)compress ratioResolution:(CGFloat)resolution
{
	UIGraphicsBeginImageContextWithOptions(self.bounds.size,compress,resolution);
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetInterpolationQuality(context,kCGInterpolationHigh);
    
    float versionDevice = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (versionDevice < 5.0) {
        CGContextSetAlpha(context, 1.0);
        CGContextTranslateCTM (context,0,self.bounds.size.height);
        CGContextScaleCTM (context, 1.0, -1.0);
    }
    NSLog(@"IOS Device: %f", versionDevice);
	
	CGContextFillPath(context);
	[self.layer renderInContext:context];
	UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	UIImageWriteToSavedPhotosAlbum(viewImage,nil,nil,nil);
}

@end
