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

#import "AVCamCaptureView.h"
#import "CameraFocusView.h"

static void *AVCamFocusModeObserverContext = &AVCamFocusModeObserverContext;

@interface AVCamCaptureView () <AVCamCaptureManagerDelegate>
{
    AVCamCaptureManager *_captureManager;
    AVCaptureVideoPreviewLayer *_captureVideoPreviewLayer;
    
    CameraFocusView *_cameraFocusView;
    
    // For Zoom
    CGFloat _beginGestureScale;
    CGFloat _effectiveScale;
}
@end

@interface AVCamCaptureView (InternalMethods)
- (CGPoint)convertToPointOfInterestFromViewCoordinates:(CGPoint)viewCoordinates;
@end

@implementation AVCamCaptureView

@synthesize focusMode = _focusMode;
@synthesize allowZooming = _allowZooming;
@synthesize flashScreenWhenCapture = _flashScreenWhenCapture;
//@synthesize devicePosition = _devicePosition;
#pragma mark-
#pragma mark Init _______________________________________________________________
/********************************************************************************/
//              Init
/********************************************************************************/

- (void) _XBAVCamCaptureViewInit
{
    if (!_captureManager) {
		_captureManager = [[AVCamCaptureManager alloc] init];
		[_captureManager setDelegate:self];
        
		if ([_captureManager setupSession]) {
            // Create video preview layer and add it to the UI
			_captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:[_captureManager session]];
			CALayer *viewLayer = [self layer];
			[viewLayer setMasksToBounds:YES];
			
			CGRect bounds = [self bounds];
			[_captureVideoPreviewLayer setFrame:bounds];
			
			if ([[_captureManager videoCaptureConnection] isVideoOrientationSupported]) {
				[[_captureManager videoCaptureConnection] setVideoOrientation:AVCaptureVideoOrientationPortrait];
			}
			
			[_captureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
			
			[viewLayer insertSublayer:_captureVideoPreviewLayer below:[[viewLayer sublayers] objectAtIndex:0]];
			
            // Start the session. This is done asychronously since -startRunning doesn't return until the session is running.
//			dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//				[[_captureManager session] startRunning];
//			});

            [[_captureManager session] startRunning];
			
            // Create the focus mode UI overlay
			AVCaptureFocusMode initialFocusMode = [[[_captureManager videoInput] device] focusMode];
            _focusMode = initialFocusMode;
			[self addObserver:self forKeyPath:@"captureManager.videoInput.device.focusMode" options:NSKeyValueObservingOptionNew context:AVCamFocusModeObserverContext];
            
            _cameraFocusView = [[CameraFocusView alloc] initWithFrame:CGRectMake(0, 0, FOCUS_VIEW_SIZE, FOCUS_VIEW_SIZE)];
            [self addSubview:_cameraFocusView];
            [_cameraFocusView hideAnimated:NO];
            
            _flashScreenWhenCapture = NO;
            _allowZooming = NO;
            _beginGestureScale = 1.0;
            _effectiveScale = 1.0;
		}
	}
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _XBAVCamCaptureViewInit];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self _XBAVCamCaptureViewInit];
}


#pragma mark-
#pragma mark Properties _________________________________________________________
/********************************************************************************/
//              Properties
/********************************************************************************/
- (AVCaptureDevicePosition)devicePosition
{
    return [[[_captureManager videoInput] device] position];
}

- (NSString *)stringForFocusMode:(AVCaptureFocusMode)focusMode
{
	NSString *focusString = @"";
	
	switch (focusMode) {
		case AVCaptureFocusModeLocked:
			focusString = @"Locked";
			break;
		case AVCaptureFocusModeAutoFocus:
			focusString = @"Auto";
			break;
		case AVCaptureFocusModeContinuousAutoFocus:
			focusString = @"Continuous";
			break;
	}
	
	return focusString;
}


/*********************************************************************************/
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == AVCamFocusModeObserverContext) {
        // Update the focus UI overlay string when the focus mode changes
        _focusMode = (AVCaptureFocusMode)[[change objectForKey:NSKeyValueChangeNewKey] integerValue];
	} else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

// Convert from view coordinates to camera coordinates, where {0,0} represents the top left of the picture area, and {1,1} represents
// the bottom right in landscape mode with the home button on the right.
- (CGPoint)convertToPointOfInterestFromViewCoordinates:(CGPoint)viewCoordinates
{
    CGPoint pointOfInterest = CGPointMake(.5f, .5f);
    CGSize frameSize = [self frame].size;
    
    if ([[_captureManager videoCaptureConnection] isVideoMirrored]) {
        viewCoordinates.x = frameSize.width - viewCoordinates.x;
    }
    
    if ( [[_captureVideoPreviewLayer videoGravity] isEqualToString:AVLayerVideoGravityResize] ) {
		// Scale, switch x and y, and reverse x
        pointOfInterest = CGPointMake(viewCoordinates.y / frameSize.height, 1.f - (viewCoordinates.x / frameSize.width));
    } else {
        CGRect cleanAperture;
        for (AVCaptureInputPort *port in [[_captureManager videoInput] ports]) {
            if ([port mediaType] == AVMediaTypeVideo) {
                cleanAperture = CMVideoFormatDescriptionGetCleanAperture([port formatDescription], YES);
                CGSize apertureSize = cleanAperture.size;
                CGPoint point = viewCoordinates;
                
                CGFloat apertureRatio = apertureSize.height / apertureSize.width;
                CGFloat viewRatio = frameSize.width / frameSize.height;
                CGFloat xc = .5f;
                CGFloat yc = .5f;
                
                if ( [[_captureVideoPreviewLayer videoGravity] isEqualToString:AVLayerVideoGravityResizeAspect] ) {
                    if (viewRatio > apertureRatio) {
                        CGFloat y2 = frameSize.height;
                        CGFloat x2 = frameSize.height * apertureRatio;
                        CGFloat x1 = frameSize.width;
                        CGFloat blackBar = (x1 - x2) / 2;
						// If point is inside letterboxed area, do coordinate conversion; otherwise, don't change the default value returned (.5,.5)
                        if (point.x >= blackBar && point.x <= blackBar + x2) {
							// Scale (accounting for the letterboxing on the left and right of the video preview), switch x and y, and reverse x
                            xc = point.y / y2;
                            yc = 1.f - ((point.x - blackBar) / x2);
                        }
                    } else {
                        CGFloat y2 = frameSize.width / apertureRatio;
                        CGFloat y1 = frameSize.height;
                        CGFloat x2 = frameSize.width;
                        CGFloat blackBar = (y1 - y2) / 2;
						// If point is inside letterboxed area, do coordinate conversion. Otherwise, don't change the default value returned (.5,.5)
                        if (point.y >= blackBar && point.y <= blackBar + y2) {
							// Scale (accounting for the letterboxing on the top and bottom of the video preview), switch x and y, and reverse x
                            xc = ((point.y - blackBar) / y2);
                            yc = 1.f - (point.x / x2);
                        }
                    }
                } else if ([[_captureVideoPreviewLayer videoGravity] isEqualToString:AVLayerVideoGravityResizeAspectFill]) {
					// Scale, switch x and y, and reverse x
                    if (viewRatio > apertureRatio) {
                        CGFloat y2 = apertureSize.width * (frameSize.width / apertureSize.height);
                        xc = (point.y + ((y2 - frameSize.height) / 2.f)) / y2; // Account for cropped height
                        yc = (frameSize.width - point.x) / frameSize.width;
                    } else {
                        CGFloat x2 = apertureSize.height * (frameSize.height / apertureSize.width);
                        yc = 1.f - ((point.x + ((x2 - frameSize.width) / 2)) / x2); // Account for cropped width
                        xc = point.y / frameSize.height;
                    }
                }
                
                pointOfInterest = CGPointMake(xc, yc);
                break;
            }
        }
    }
    
    return pointOfInterest;
}

// Auto focus at a particular point. The focus mode will change to locked once the auto focus happens.
- (void)tapToAutoFocus:(UIGestureRecognizer *)gestureRecognizer
{
    if ([[[_captureManager videoInput] device] isFocusPointOfInterestSupported]) {
        CGPoint tapPoint = [gestureRecognizer locationInView:self];
        CGPoint convertedFocusPoint = [self convertToPointOfInterestFromViewCoordinates:tapPoint];
        [_captureManager setFocusAtPoint:convertedFocusPoint];
        
        if (gestureRecognizer.state == UIGestureRecognizerStateRecognized) {
            CGPoint location = [gestureRecognizer locationInView:self];
            
            if (_captureManager.exposurePointSupported || _captureManager.focusPointSupported) {
                _cameraFocusView.center = location;
                [_cameraFocusView showAnimated:YES];
            }
        }
    }
    
    [_captureManager setAutoWhiteBalance:YES];
}

- (void)setExposureAtPoint:(CGPoint)exposurePoint
{
    [_captureManager setExposureAtPoint:CGPointMake(exposurePoint.y/self.bounds.size.height, 1 - exposurePoint.x/self.bounds.size.width)];
}


- (void)handleBeginZoomingCamera
{
    if (!_allowZooming) return;
    
    _beginGestureScale = _effectiveScale;
}

- (void)handleZoomingCamera:(UIPinchGestureRecognizer *)recognizer
{
    if (!_allowZooming) return;
    
	BOOL allTouchesAreOnThePreviewLayer = YES;
	NSUInteger numTouches = [recognizer numberOfTouches], i;
	for ( i = 0; i < numTouches; ++i ) {
		CGPoint location = [recognizer locationOfTouch:i inView:self];
		CGPoint convertedLocation = [_captureVideoPreviewLayer convertPoint:location fromLayer:_captureVideoPreviewLayer.superlayer];
		if ( ! [_captureVideoPreviewLayer containsPoint:convertedLocation] ) {
			allTouchesAreOnThePreviewLayer = NO;
			break;
		}
	}
	
	if ( allTouchesAreOnThePreviewLayer ) {
		_effectiveScale = _beginGestureScale * recognizer.scale;
		if (_effectiveScale < 1.0)
			_effectiveScale = 1.0;
		CGFloat maxScaleAndCropFactor = [[_captureManager.stillImageOutput connectionWithMediaType:AVMediaTypeVideo] videoMaxScaleAndCropFactor];
		if (_effectiveScale > maxScaleAndCropFactor)
			_effectiveScale = maxScaleAndCropFactor;
		[CATransaction begin];
		[CATransaction setAnimationDuration:.025];
		[_captureVideoPreviewLayer setAffineTransform:CGAffineTransformMakeScale(_effectiveScale, _effectiveScale)];
		[CATransaction commit];
	}
}

- (XBFlashMode)flashMode
{
    return _captureManager.flashMode;
}
- (void)setFlashMode:(XBFlashMode)flashMode__
{
    _captureManager.flashMode = flashMode__;
}
- (XBTorchMode)torchMode
{
    return _captureManager.torchMode;
}
- (void)setTorchMode:(XBTorchMode)torchMode__
{
    _captureManager.torchMode = torchMode__;
}

- (BOOL) toggleCamera
{
    if (_effectiveScale != 1.) {
        _beginGestureScale = 1.;
        _effectiveScale = 1.;
        [CATransaction begin];
        [CATransaction setAnimationDuration:.025];
        [_captureVideoPreviewLayer setAffineTransform:CGAffineTransformMakeScale(_effectiveScale, _effectiveScale)];
        [CATransaction commit];
    }
    
    return [_captureManager toggleCamera];
}

- (void)startRunningAVCam
{
    [_captureManager.session startRunning];
}
- (void) stopRunningAVCam
{
    if (_effectiveScale != 1.) {
        _beginGestureScale = 1.;
        _effectiveScale = 1.;
        [CATransaction begin];
        [CATransaction setAnimationDuration:.025];
        [_captureVideoPreviewLayer setAffineTransform:CGAffineTransformMakeScale(_effectiveScale, _effectiveScale)];
        [CATransaction commit];
    }
    
    [_captureManager.session stopRunning];
}
/*********************************************************************************/
#pragma mark-
#pragma mark Take Picture ________________________________________________________
/********************************************************************************/
//              Take Picture
/********************************************************************************/
- (void)takeAPhotoWithCompletion:(void (^)(UIImage *, XBPhotoOrientation))completion
{
    [_captureManager captureStillImageWithCompletion:^(UIImage *imageCompletion, XBPhotoOrientation processWithOrient) {
        CFRunLoopPerformBlock(CFRunLoopGetMain(), kCFRunLoopCommonModes, ^(void) {
            completion (imageCompletion, processWithOrient);
        });
    }];
    
    //============================================================================
    if (_flashScreenWhenCapture) {
        // Flash the screen white and fade it out to give UI feedback that a still image was taken
        UIView *flashView = [[UIView alloc] initWithFrame:[self frame]];
        [flashView setBackgroundColor:[UIColor whiteColor]];
        [[[[UIApplication sharedApplication] delegate] window] addSubview:flashView];
        
        [UIView animateWithDuration:.4f
                         animations:^{
                             [flashView setAlpha:0.f];
                         }
                         completion:^(BOOL finished){
                             [flashView removeFromSuperview];
                         }
         ];
    }
    //============================================================================
}

#pragma mark-
#pragma mark captureManagerDelegate Methods ______________________________________
/********************************************************************************/
//              captureManagerDelegate Methods
/********************************************************************************/
- (void)captureManager:(AVCamCaptureManager *)captureManager didFailWithError:(NSError *)error
{
    CFRunLoopPerformBlock(CFRunLoopGetMain(), kCFRunLoopCommonModes, ^(void) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error localizedDescription]
                                                            message:[error localizedFailureReason]
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"OK", @"OK button title")
                                                  otherButtonTitles:nil];
        [alertView show];
    });
}

- (void)captureManagerRecordingBegan:(AVCamCaptureManager *)captureManager
{
    CFRunLoopPerformBlock(CFRunLoopGetMain(), kCFRunLoopCommonModes, ^(void) {
        //        [[self recordButton] setTitle:NSLocalizedString(@"Stop", @"Toggle recording button stop title")];
        //        [[self recordButton] setEnabled:YES];
    });
}

- (void)captureManagerRecordingFinished:(AVCamCaptureManager *)captureManager
{
    CFRunLoopPerformBlock(CFRunLoopGetMain(), kCFRunLoopCommonModes, ^(void) {
        //        [[self recordButton] setTitle:NSLocalizedString(@"Record", @"Toggle recording button record title")];
        //        [[self recordButton] setEnabled:YES];
    });
}

- (void)captureManagerDeviceConfigurationChanged:(AVCamCaptureManager *)captureManager
{
    //	[self updateButtonStates];
}

// for focus
- (void)avCamCaptureManagerDidBeginAdjustingFocus:(AVCamCaptureManager *)avCamCaptureManager
{
    
}
- (void)avCamCaptureManagerDidFinishAdjustingFocus:(AVCamCaptureManager *)avCamCaptureManager
{
    [_cameraFocusView hideAnimated:YES];
}
- (void)avCamCaptureManagerDidBeginAdjustingExposure:(AVCamCaptureManager *)avCamCaptureManager
{
    
}
- (void)avCamCaptureManagerDidFinishAdjustingExposure:(AVCamCaptureManager *)avCamCaptureManager
{
    [_cameraFocusView hideAnimated:YES];
}
- (void)avCamCaptureManagerDidBeginAdjustingWhiteBalance:(AVCamCaptureManager *)avCamCaptureManager
{
    
}
- (void)avCamCaptureManagerDidFinishAdjustingWhiteBalance:(AVCamCaptureManager *)avCamCaptureManager
{
    
}
/*********************************************************************************/

@end
