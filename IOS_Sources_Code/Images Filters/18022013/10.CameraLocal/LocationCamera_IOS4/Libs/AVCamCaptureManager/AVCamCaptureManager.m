/*
     File: AVCamCaptureManager.m
 Abstract: Uses the AVCapture classes to capture video and still images.
  Version: 1.2
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2011 Apple Inc. All Rights Reserved.
 
 */

#import "AVCamCaptureManager.h"
#import "AVCamRecorder.h"
#import "AVCamUtilities.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <ImageIO/CGImageProperties.h>

#import "UIImage+additions.h"


@interface AVCamCaptureManager ()
- (NSString *)captureSessionPresetFromCaptureQuality:(SessionPresetQuality)captureQuality;
- (BOOL) setWhiteBalanceMode:(AVCaptureWhiteBalanceMode)whiteBalanceMode;
@end


@interface AVCamCaptureManager (RecorderDelegate) <AVCamRecorderDelegate>
@end


#pragma mark -
@interface AVCamCaptureManager (InternalUtilityMethods)
- (AVCaptureDevice *) cameraWithPosition:(AVCaptureDevicePosition)position;
- (AVCaptureDevice *) frontFacingCamera;
- (AVCaptureDevice *) backFacingCamera;
- (AVCaptureDevice *) audioDevice;
- (NSURL *) tempFileURL;
- (void) removeFile:(NSURL *)outputFileURL;
- (void) copyFileToDocuments:(NSURL *)fileURL;

@end


#pragma mark -
@implementation AVCamCaptureManager

@synthesize session;
@synthesize orientation;
@synthesize videoInput;
@synthesize audioInput;
@synthesize stillImageOutput;
@synthesize recorder;
@synthesize deviceConnectedObserver;
@synthesize deviceDisconnectedObserver;
@synthesize backgroundRecordingID;
@synthesize delegate;
@synthesize photoOrientation;

@synthesize flashMode = _flashMode;
@synthesize torchMode = _torchMode;
@synthesize autoWhiteBalance = _autoWhiteBalance;

@synthesize imageCaptureQuality = _imageCaptureQuality;
#pragma mark-
#pragma mark Init _______________________________________________________________
/********************************************************************************/
//              Init
/********************************************************************************/
- (id) init
{
    self = [super init];
    if (self != nil) {
		__block id weakSelf = self;
        void (^deviceConnectedBlock)(NSNotification *) = ^(NSNotification *notification) {
			AVCaptureDevice *device = [notification object];
			
			BOOL sessionHasDeviceWithMatchingMediaType = NO;
			NSString *deviceMediaType = nil;
			if ([device hasMediaType:AVMediaTypeAudio])
                deviceMediaType = AVMediaTypeAudio;
			else if ([device hasMediaType:AVMediaTypeVideo])
                deviceMediaType = AVMediaTypeVideo;
			
			if (deviceMediaType != nil) {
				for (AVCaptureDeviceInput *input in [session inputs])
				{
					if ([[input device] hasMediaType:deviceMediaType]) {
						sessionHasDeviceWithMatchingMediaType = YES;
						break;
					}
				}
				
				if (!sessionHasDeviceWithMatchingMediaType) {
					NSError	*error;
					AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
					if ([session canAddInput:input])
						[session addInput:input];
				}				
			}
            
			if ([delegate respondsToSelector:@selector(captureManagerDeviceConfigurationChanged:)]) {
				[delegate captureManagerDeviceConfigurationChanged:self];
			}			
        };
        void (^deviceDisconnectedBlock)(NSNotification *) = ^(NSNotification *notification) {
			AVCaptureDevice *device = [notification object];
			
			if ([device hasMediaType:AVMediaTypeAudio]) {
				[session removeInput:[weakSelf audioInput]];
				[weakSelf setAudioInput:nil];
			}
			else if ([device hasMediaType:AVMediaTypeVideo]) {
				[session removeInput:[weakSelf videoInput]];
				[weakSelf setVideoInput:nil];
			}
			
			if ([delegate respondsToSelector:@selector(captureManagerDeviceConfigurationChanged:)]) {
				[delegate captureManagerDeviceConfigurationChanged:self];
			}			
        };
        
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        [self setDeviceConnectedObserver:[notificationCenter addObserverForName:AVCaptureDeviceWasConnectedNotification object:nil queue:nil usingBlock:deviceConnectedBlock]];
        [self setDeviceDisconnectedObserver:[notificationCenter addObserverForName:AVCaptureDeviceWasDisconnectedNotification object:nil queue:nil usingBlock:deviceDisconnectedBlock]];
		[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
		[notificationCenter addObserver:self selector:@selector(deviceOrientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
		orientation = AVCaptureVideoOrientationPortrait;
        
        _autoWhiteBalance = NO;
        self.photoOrientation = XBPhotoOrientationAuto;
        
        _imageCaptureQuality = XBCaptureQualityPhoto;
    }
    
    return self;
}

#pragma mark-
#pragma mark setupSession ________________________________________________________
/********************************************************************************/
//              setupSession
/********************************************************************************/
- (BOOL) setupSession
{
    BOOL success = NO;
    
	// Set torch and flash mode to auto
	if ([[self backFacingCamera] hasFlash]) {
		if ([[self backFacingCamera] lockForConfiguration:nil]) {
			if ([[self backFacingCamera] isFlashModeSupported:AVCaptureFlashModeAuto]) {
				[[self backFacingCamera] setFlashMode:AVCaptureFlashModeAuto];
			}
			[[self backFacingCamera] unlockForConfiguration];
		}
	}
	if ([[self backFacingCamera] hasTorch]) {
		if ([[self backFacingCamera] lockForConfiguration:nil]) {
			if ([[self backFacingCamera] isTorchModeSupported:AVCaptureTorchModeAuto]) {
				[[self backFacingCamera] setTorchMode:AVCaptureTorchModeAuto];
			}
			[[self backFacingCamera] unlockForConfiguration];
		}
	}
	
    // Init the device inputs
    AVCaptureDeviceInput *newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self backFacingCamera] error:nil];
    AVCaptureDeviceInput *newAudioInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self audioDevice] error:nil];
    
	
    // Setup the still image file output
    AVCaptureStillImageOutput *newStillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    AVVideoCodecJPEG, AVVideoCodecKey,
                                    nil];
    [newStillImageOutput setOutputSettings:outputSettings];
    
    // Create session (use default AVCaptureSessionPresetHigh)
    AVCaptureSession *newCaptureSession = [[AVCaptureSession alloc] init];
    
    
    // Add inputs and output to the capture session
    if ([newCaptureSession canAddInput:newVideoInput]) {
        [newCaptureSession addInput:newVideoInput];
    }
    if ([newCaptureSession canAddInput:newAudioInput]) {
        [newCaptureSession addInput:newAudioInput];
    }
    if ([newCaptureSession canAddOutput:newStillImageOutput]) {
        [newCaptureSession addOutput:newStillImageOutput];
    }
    
    [self setStillImageOutput:newStillImageOutput];
    [self setVideoInput:newVideoInput];
    [self setAudioInput:newAudioInput];
    [self setSession:newCaptureSession];
    
	// Set up the movie file output
    NSURL *outputFileURL = [self tempFileURL];
    AVCamRecorder *newRecorder = [[AVCamRecorder alloc] initWithSession:[self session] outputFileURL:outputFileURL];
    [newRecorder setDelegate:self];
	
	// Send an error to the delegate if video recording is unavailable
	if (![newRecorder recordsVideo] && [newRecorder recordsAudio]) {
		NSString *localizedDescription = NSLocalizedString(@"Video recording unavailable", @"Video recording unavailable description");
		NSString *localizedFailureReason = NSLocalizedString(@"Movies recorded on this device will only contain audio. They will be accessible through iTunes file sharing.", @"Video recording unavailable failure reason");
		NSDictionary *errorDict = [NSDictionary dictionaryWithObjectsAndKeys:
								   localizedDescription, NSLocalizedDescriptionKey, 
								   localizedFailureReason, NSLocalizedFailureReasonErrorKey, 
								   nil];
		NSError *noVideoError = [NSError errorWithDomain:@"AVCam" code:0 userInfo:errorDict];
		if ([[self delegate] respondsToSelector:@selector(captureManager:didFailWithError:)]) {
			[[self delegate] captureManager:self didFailWithError:noVideoError];
		}
	}
	
	[self setRecorder:newRecorder];
    
    //================================================
    [[videoInput device] addObserver:self forKeyPath:@"adjustingFocus" options:0 context:NULL];
    [[videoInput device] addObserver:self forKeyPath:@"adjustingExposure" options:0 context:NULL];
    [[videoInput device] addObserver:self forKeyPath:@"adjustingWhiteBalance" options:0 context:NULL];
    //================================================
    self.session.sessionPreset = [self captureSessionPresetFromCaptureQuality:self.imageCaptureQuality];
    
    [self autoFocusAtPoint:CGPointMake(0.5, 0.5)];
    [self setWhiteBalanceMode:AVCaptureWhiteBalanceModeAutoWhiteBalance];
    
    success = YES;
    
    return success;
}

#pragma mark-
#pragma mark Properties ________________________________________________________
/********************************************************************************/
//              Properties
/********************************************************************************/
- (AVCaptureConnection*)videoCaptureConnection
{
    return [AVCamUtilities connectionWithMediaType:AVMediaTypeVideo fromConnections:[[self stillImageOutput] connections]];
}

- (XBPhotoOrientation)photoOrientationForDeviceOrientation
{
    XBPhotoOrientation orientationPhoto = XBPhotoOrientationPortrait;
    
    switch ([[UIDevice currentDevice] orientation]) {
        case UIDeviceOrientationLandscapeLeft:
            orientationPhoto = XBPhotoOrientationLandscapeLeft;
            break;
            
        case UIDeviceOrientationLandscapeRight:
            orientationPhoto = XBPhotoOrientationLandscapeRight;
            break;
            
        case UIDeviceOrientationPortrait:
            orientationPhoto = XBPhotoOrientationPortrait;
            break;
            
        case UIDeviceOrientationPortraitUpsideDown:
            orientationPhoto = XBPhotoOrientationPortraitUpsideDown;
            break;
            
        case UIDeviceOrientationFaceDown:
        case UIDeviceOrientationFaceUp:
        case UIDeviceOrientationUnknown:
            orientationPhoto = XBPhotoOrientationPortrait;
            break;
    }
    
    return orientationPhoto;
}

- (BOOL)focusPointSupported
{
    return [[self videoInput] device].focusPointOfInterestSupported;
}
- (BOOL)exposurePointSupported
{
    return [[self videoInput] device].exposurePointOfInterestSupported;
}

- (void)setFlashMode:(XBFlashMode)flashMode
{
    NSError *error = nil;
    if (![[[self videoInput] device] lockForConfiguration:&error]) {
        NSLog(@"XBFilteredCameraView: Failed to set flash mode: %@", [error localizedDescription]);
        return;
    }
    
    _flashMode = flashMode;
    
    switch (_flashMode) {
        case XBFlashModeOff: {
            if ([[self videoInput].device isFlashModeSupported:AVCaptureFlashModeOff])
                [self videoInput].device.flashMode = AVCaptureFlashModeOff;
            else
                _flashMode = XBFlashModeNotSupport;
            break;
        }
            
        case XBFlashModeOn: {
            if ([[self videoInput].device isFlashModeSupported:AVCaptureFlashModeOn])
                [self videoInput].device.flashMode = AVCaptureFlashModeOn;
            else
                _flashMode = XBFlashModeNotSupport;
            break;
        }
            
        case XBFlashModeAuto: {
            if ([[self videoInput].device isFlashModeSupported:AVCaptureFlashModeAuto])
                [self videoInput].device.flashMode = AVCaptureFlashModeAuto;
            else
                _flashMode = XBFlashModeNotSupport;
            break;
        }
            
        default: {
            _flashMode = XBFlashModeNotSupport;
            break;
        }
    }
    
    [[self videoInput].device unlockForConfiguration];
}


- (void)setTorchMode:(XBTorchMode)torchMode
{
    NSError *error = nil;
    if (![[self videoInput].device lockForConfiguration:&error]) {
        NSLog(@"XBFilteredCameraView: Failed to set torch mode: %@", [error localizedDescription]);
        return;
    }
    
    _torchMode = torchMode;
    
    switch (_torchMode) {
        case XBTorchModeOff:
            if ([[self videoInput].device isTorchModeSupported:AVCaptureTorchModeOff])
                [self videoInput].device.torchMode = AVCaptureTorchModeOff;
            else
                _torchMode = XBTorchModeNotSupport;
            
            break;
            
        case XBTorchModeOn:
            if ([[self videoInput].device isTorchModeSupported:AVCaptureTorchModeOn])
                [self videoInput].device.torchMode = AVCaptureTorchModeOn;
            else
                _torchMode = XBTorchModeNotSupport;
            
            break;
            
        case XBTorchModeAuto:
            if ([[self videoInput].device isTorchModeSupported:AVCaptureTorchModeAuto])
                [self videoInput].device.torchMode = AVCaptureTorchModeAuto;
            else
                _torchMode = XBTorchModeNotSupport;
            
            break;
            
        default:
            break;
    }
    
    [[self videoInput].device unlockForConfiguration];
}

- (BOOL)hasTorch
{
    return [[self videoInput].device hasTorch];
}

// Perform an auto focus at the specified point. The focus mode will automatically change to locked once the auto focus is complete.
- (void) autoFocusAtPoint:(CGPoint)point
{
    AVCaptureDevice *device = [[self videoInput] device];
    if ([device isFocusPointOfInterestSupported] && [device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        NSError *error;
        if ([device lockForConfiguration:&error]) {
            [device setFocusPointOfInterest:point];
            [device setFocusMode:AVCaptureFocusModeAutoFocus];
            [device unlockForConfiguration];
        } else {
            if ([[self delegate] respondsToSelector:@selector(captureManager:didFailWithError:)]) {
                [[self delegate] captureManager:self didFailWithError:error];
            }
        }
    }
}

// Switch to continuous auto focus mode at the specified point
- (void) setFocusAtPoint:(CGPoint)point
{
    AVCaptureDevice *device = [[self videoInput] device];
	
    if ([device isFocusPointOfInterestSupported] && [device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
		NSError *error;
		if ([device lockForConfiguration:&error]) {
			[device setFocusPointOfInterest:point];
            [device setFocusMode:AVCaptureFocusModeAutoFocus];
			[device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
			[device unlockForConfiguration];
		} else {
			if ([[self delegate] respondsToSelector:@selector(captureManager:didFailWithError:)]) {
                [[self delegate] captureManager:self didFailWithError:error];
			}
		}
	}
}

- (void)setExposureAtPoint:(CGPoint)exposurePoint
{
    if (!self.exposurePointSupported) {
        return;
    }
    AVCaptureDevice *device = [[self videoInput] device];
    if ([device isExposurePointOfInterestSupported] && [device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
		NSError *error;
		if ([device lockForConfiguration:&error]) {
            [device setExposureMode:AVCaptureExposureModeLocked];
			[device setExposurePointOfInterest:exposurePoint];
			[device setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
			[device unlockForConfiguration];
		} else {
			if ([[self delegate] respondsToSelector:@selector(captureManager:didFailWithError:)]) {
                [[self delegate] captureManager:self didFailWithError:error];
			}
		}
	}
}

- (BOOL) setWhiteBalanceMode:(AVCaptureWhiteBalanceMode)whiteBalanceMode
{
    AVCaptureDevice *device = [[self videoInput] device];
    if ([device isWhiteBalanceModeSupported:whiteBalanceMode] && [device whiteBalanceMode] != whiteBalanceMode) {
        NSError *error;
        if ([device lockForConfiguration:&error]) {
            [device setWhiteBalanceMode:whiteBalanceMode];
            [device unlockForConfiguration];
            
            return YES;
        } else {
            if ([[self delegate] respondsToSelector:@selector(captureManager:didFailWithError:)]) {
                [[self delegate] captureManager:self didFailWithError:error];
			}
            
            return NO;
        }
    }
    
    return NO;
}
- (BOOL)autoWhiteBalance
{
    return _autoWhiteBalance;
}
- (void)setAutoWhiteBalance:(BOOL)autoWhiteBalance__
{
    if (autoWhiteBalance__) {
        BOOL success = [self setWhiteBalanceMode:(AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance)];
        _autoWhiteBalance = success;
    }
    else {
        [self setWhiteBalanceMode:(AVCaptureWhiteBalanceModeLocked)];
        _autoWhiteBalance = NO;
    }
}

- (NSString *)captureSessionPresetFromCaptureQuality:(SessionPresetQuality)captureQuality
{
    if (captureQuality == XBCaptureQualityPhoto) {
        return AVCaptureSessionPresetPhoto;
    }
    else if (captureQuality == XBCaptureQualityHigh) {
        return AVCaptureSessionPresetHigh;
    }
    else if (captureQuality == XBCaptureQualityMedium) {
        return AVCaptureSessionPresetMedium;
    }
    else if (captureQuality == XBCaptureQualityLow) {
        return AVCaptureSessionPresetLow;
    }
    else if (captureQuality == XBCaptureQuality1280x720) {
        return AVCaptureSessionPreset1280x720;
    }
    else if (captureQuality == XBCaptureQualityiFrame1280x720) {
        return AVCaptureSessionPresetiFrame1280x720;
    }
    else if (captureQuality == XBCaptureQualityiFrame960x540) {
        return AVCaptureSessionPresetiFrame960x540;
    }
    else if (captureQuality == XBCaptureQuality640x480) {
        return AVCaptureSessionPreset640x480;
    }
    else if (captureQuality == XBCaptureQuality352x288) {
        return AVCaptureSessionPreset352x288;
    }
    else {
        return nil;
    }
}

#pragma mark-
#pragma mark Actions ____________________________________________________________
/********************************************************************************/
//              Actions
/********************************************************************************/
- (void) startRecording
{
    if ([[UIDevice currentDevice] isMultitaskingSupported]) {
        // Setup background task. This is needed because the captureOutput:didFinishRecordingToOutputFileAtURL: callback is not received until AVCam returns
		// to the foreground unless you request background execution time. This also ensures that there will be time to write the file to the assets library
		// when AVCam is backgrounded. To conclude this background execution, -endBackgroundTask is called in -recorder:recordingDidFinishToOutputFileURL:error:
		// after the recorded file has been saved.
        [self setBackgroundRecordingID:[[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{}]];
    }
    
    [self removeFile:[[self recorder] outputFileURL]];
    [[self recorder] startRecordingWithOrientation:orientation];
}

- (void) stopRecording
{
    [[self recorder] stopRecording];
}

- (void) captureStillImageWithCompletion:(takeAPhotoWithCompletionHandler)completion
{
    self.session.sessionPreset = [self captureSessionPresetFromCaptureQuality:self.imageCaptureQuality];
    
    AVCaptureConnection *stillImageConnection = [AVCamUtilities connectionWithMediaType:AVMediaTypeVideo fromConnections:[[self stillImageOutput] connections]];
    if ([stillImageConnection isVideoOrientationSupported])
        [stillImageConnection setVideoOrientation:orientation];
    
    [[self stillImageOutput] captureStillImageAsynchronouslyFromConnection:stillImageConnection
                                                         completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error)
     {
         self.session.sessionPreset = [self captureSessionPresetFromCaptureQuality:self.imageCaptureQuality];
         
         if (imageDataSampleBuffer != NULL) {
             NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
             UIImage *imageCapture = [[UIImage alloc] initWithData:imageData];
             
             XBPhotoOrientation orientationPhoto = self.photoOrientation != XBPhotoOrientationAuto? :[self photoOrientationForDeviceOrientation];
             
             if ([[videoInput device] position] == AVCaptureDevicePositionFront) {
                 
                 UIImageOrientation imageOrientation = imageCapture.imageOrientation;
                 
                 if (imageOrientation == UIImageOrientationUp) {
                     if (orientationPhoto != XBPhotoOrientationLandscapeRight) {
                         imageCapture = [UIImage imageWithCGImage:imageCapture.CGImage
                                                            scale:1.0 orientation: UIImageOrientationRightMirrored];
                     }
                     else {
                         imageCapture = [UIImage imageWithCGImage:imageCapture.CGImage
                                                            scale:1.0 orientation: UIImageOrientationUpMirrored];
                     }
                 }
                 else if (imageOrientation == UIImageOrientationDown) {
                     if (orientationPhoto != XBPhotoOrientationLandscapeLeft) {
                         imageCapture = [UIImage imageWithCGImage:imageCapture.CGImage
                                                            scale:1.0 orientation: UIImageOrientationLeftMirrored];
                     }
                     else {
                         imageCapture = [UIImage imageWithCGImage:imageCapture.CGImage
                                                            scale:1.0 orientation: UIImageOrientationDownMirrored];
                     }
                 }
                 else if (imageOrientation == UIImageOrientationLeft) {
                     imageCapture = [UIImage imageWithCGImage:imageCapture.CGImage
                                                        scale:1.0 orientation: UIImageOrientationRightMirrored];
                 }
                 else if (imageOrientation == UIImageOrientationRight) {
                     imageCapture = [UIImage imageWithCGImage:imageCapture.CGImage
                                                        scale:1.0 orientation: UIImageOrientationLeftMirrored];
                 }
             }
             
             completion(imageCapture,orientationPhoto);
         }
         else
             completion(nil, XBPhotoOrientationAuto);
     }];
}

// Toggle between the front and back camera, if both are present.
- (BOOL) toggleCamera
{
    BOOL success = NO;
    
    //================================================
    [[videoInput device] removeObserver:self forKeyPath:@"adjustingFocus"];
    [[videoInput device] removeObserver:self forKeyPath:@"adjustingExposure"];
    [[videoInput device] removeObserver:self forKeyPath:@"adjustingWhiteBalance"];
    //================================================
    
    if ([self cameraCount] > 1) {
        NSError *error;
        AVCaptureDeviceInput *newVideoInput;
        AVCaptureDevicePosition position = [[videoInput device] position];
        
        
        
        if (position == AVCaptureDevicePositionBack)
            newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self frontFacingCamera] error:&error];
        else if (position == AVCaptureDevicePositionFront)
            newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self backFacingCamera] error:&error];
        else
            goto bail;
        
        if (newVideoInput != nil) {
            [[self session] beginConfiguration];
            [[self session] removeInput:[self videoInput]];
            if ([[self session] canAddInput:newVideoInput]) {
                [[self session] addInput:newVideoInput];
                [self setVideoInput:newVideoInput];
            } else {
                [[self session] addInput:[self videoInput]];
            }
            [[self session] commitConfiguration];
            success = YES;
            
        } else if (error) {
            if ([[self delegate] respondsToSelector:@selector(captureManager:didFailWithError:)]) {
                [[self delegate] captureManager:self didFailWithError:error];
            }
        }
    }
    
bail:
    //================================================
    [[videoInput device] addObserver:self forKeyPath:@"adjustingFocus" options:0 context:NULL];
    [[videoInput device] addObserver:self forKeyPath:@"adjustingExposure" options:0 context:NULL];
    [[videoInput device] addObserver:self forKeyPath:@"adjustingWhiteBalance" options:0 context:NULL];
    //================================================
    return success;
}

#pragma mark - Key-Value Observing

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == [videoInput device]) {
        if ([keyPath isEqualToString:@"adjustingFocus"]) {
            if ([videoInput device].adjustingFocus && [self.delegate respondsToSelector:@selector(avCamCaptureManagerDidBeginAdjustingFocus:)]) {
                [self.delegate avCamCaptureManagerDidBeginAdjustingFocus:self];
            }
            else if (![videoInput device].adjustingFocus && [self.delegate respondsToSelector:@selector(avCamCaptureManagerDidFinishAdjustingFocus:)]) {
                [self.delegate avCamCaptureManagerDidFinishAdjustingFocus:self];
            }
        }
        else if ([keyPath isEqualToString:@"adjustingExposure"]) {
            if ([videoInput device].adjustingExposure && [self.delegate respondsToSelector:@selector(avCamCaptureManagerDidBeginAdjustingExposure:)]) {
                [self.delegate avCamCaptureManagerDidBeginAdjustingExposure:self];
            }
            else if (![videoInput device].adjustingExposure && [self.delegate respondsToSelector:@selector(avCamCaptureManagerDidFinishAdjustingExposure:)]) {
                [self.delegate avCamCaptureManagerDidFinishAdjustingExposure:self];
            }
        }
        else if ([keyPath isEqualToString:@"adjustingWhiteBalance"]) {
            if ([videoInput device].adjustingWhiteBalance && [self.delegate respondsToSelector:@selector(avCamCaptureManagerDidBeginAdjustingWhiteBalance:)]) {
                [self.delegate avCamCaptureManagerDidBeginAdjustingWhiteBalance:self];
            }
            else if (![videoInput device].adjustingWhiteBalance && [self.delegate respondsToSelector:@selector(avCamCaptureManagerDidFinishAdjustingWhiteBalance:)]) {
                [self.delegate avCamCaptureManagerDidFinishAdjustingWhiteBalance:self];
            }
        }
        else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}



#pragma mark Device Counts
- (NSUInteger) cameraCount
{
    return [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
}

- (NSUInteger) micCount
{
    return [[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio] count];
}


@end


#pragma mark -
@implementation AVCamCaptureManager (InternalUtilityMethods)

// Keep track of current device orientation so it can be applied to movie recordings and still image captures
- (void)deviceOrientationDidChange
{	
	UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
    
	if (deviceOrientation == UIDeviceOrientationPortrait)
		orientation = AVCaptureVideoOrientationPortrait;
	else if (deviceOrientation == UIDeviceOrientationPortraitUpsideDown)
		orientation = AVCaptureVideoOrientationPortraitUpsideDown;
	
	// AVCapture and UIDevice have opposite meanings for landscape left and right (AVCapture orientation is the same as UIInterfaceOrientation)
	else if (deviceOrientation == UIDeviceOrientationLandscapeLeft)
		orientation = AVCaptureVideoOrientationLandscapeRight;
	else if (deviceOrientation == UIDeviceOrientationLandscapeRight)
		orientation = AVCaptureVideoOrientationLandscapeLeft;
	
	// Ignore device orientations for which there is no corresponding still image orientation (e.g. UIDeviceOrientationFaceUp)
}

// Find a camera with the specificed AVCaptureDevicePosition, returning nil if one is not found
- (AVCaptureDevice *) cameraWithPosition:(AVCaptureDevicePosition) position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == position) {
            return device;
        }
    }
    return nil;
}

// Find a front facing camera, returning nil if one is not found
- (AVCaptureDevice *) frontFacingCamera
{
    return [self cameraWithPosition:AVCaptureDevicePositionFront];
}

// Find a back facing camera, returning nil if one is not found
- (AVCaptureDevice *) backFacingCamera
{
    return [self cameraWithPosition:AVCaptureDevicePositionBack];
}

// Find and return an audio device, returning nil if one is not found
- (AVCaptureDevice *) audioDevice
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio];
    if ([devices count] > 0) {
        return [devices objectAtIndex:0];
    }
    return nil;
}

- (NSURL *) tempFileURL
{
    return [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), @"output.mov"]];
}

- (void) removeFile:(NSURL *)fileURL
{
    NSString *filePath = [fileURL path];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        NSError *error;
        if ([fileManager removeItemAtPath:filePath error:&error] == NO) {
            if ([[self delegate] respondsToSelector:@selector(captureManager:didFailWithError:)]) {
                [[self delegate] captureManager:self didFailWithError:error];
            }            
        }
    }
}

- (void) copyFileToDocuments:(NSURL *)fileURL
{
	NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd_HH-mm-ss"];
	NSString *destinationPath = [documentsDirectory stringByAppendingFormat:@"/output_%@.mov", [dateFormatter stringFromDate:[NSDate date]]];
	
    NSError	*error;
	if (![[NSFileManager defaultManager] copyItemAtURL:fileURL toURL:[NSURL fileURLWithPath:destinationPath] error:&error]) {
		if ([[self delegate] respondsToSelector:@selector(captureManager:didFailWithError:)]) {
			[[self delegate] captureManager:self didFailWithError:error];
		}
	}
}	

@end


#pragma mark -
@implementation AVCamCaptureManager (RecorderDelegate)

-(void)recorderRecordingDidBegin:(AVCamRecorder *)recorder
{
    if ([[self delegate] respondsToSelector:@selector(captureManagerRecordingBegan:)]) {
        [[self delegate] captureManagerRecordingBegan:self];
    }
}

-(void)recorder:(AVCamRecorder *)recorder recordingDidFinishToOutputFileURL:(NSURL *)outputFileURL error:(NSError *)error
{
	if ([[self recorder] recordsAudio] && ![[self recorder] recordsVideo]) {
		// If the file was created on a device that doesn't support video recording, it can't be saved to the assets 
		// library. Instead, save it in the app's Documents directory, whence it can be copied from the device via
		// iTunes file sharing.
		[self copyFileToDocuments:outputFileURL];

		if ([[UIDevice currentDevice] isMultitaskingSupported]) {
			[[UIApplication sharedApplication] endBackgroundTask:[self backgroundRecordingID]];
		}		

		if ([[self delegate] respondsToSelector:@selector(captureManagerRecordingFinished:)]) {
			[[self delegate] captureManagerRecordingFinished:self];
		}
	}
	else {	
		ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
		[library writeVideoAtPathToSavedPhotosAlbum:outputFileURL
									completionBlock:^(NSURL *assetURL, NSError *error) {
										if (error) {
											if ([[self delegate] respondsToSelector:@selector(captureManager:didFailWithError:)]) {
												[[self delegate] captureManager:self didFailWithError:error];
											}											
										}
										
										if ([[UIDevice currentDevice] isMultitaskingSupported]) {
											[[UIApplication sharedApplication] endBackgroundTask:[self backgroundRecordingID]];
										}
										
										if ([[self delegate] respondsToSelector:@selector(captureManagerRecordingFinished:)]) {
											[[self delegate] captureManagerRecordingFinished:self];
										}
									}];
	}
}

@end
