/*
     File: AVCamCaptureManager.h
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

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class AVCamRecorder;
@protocol AVCamCaptureManagerDelegate;

typedef enum {
    XBPhotoOrientationAuto = 0, // Determines photo orientation from [UIDevice currentDevice]'s orientation
    XBPhotoOrientationPortrait = 1,
    XBPhotoOrientationPortraitUpsideDown = 2,
    XBPhotoOrientationLandscapeLeft = 3,
    XBPhotoOrientationLandscapeRight = 4,
} XBPhotoOrientation;

typedef enum {
    XBFlashModeOff = 0,
    XBFlashModeOn = 1,
    XBFlashModeAuto = 2,
    XBFlashModeNotSupport = 3
} XBFlashMode;

typedef enum {
    XBTorchModeOff = 0,
    XBTorchModeOn = 1,
    XBTorchModeAuto = 2,
    XBTorchModeNotSupport = 3
} XBTorchMode;

typedef enum {
    XBCaptureQualityPhoto = 0,
    XBCaptureQualityHigh = 1,
    XBCaptureQualityMedium = 2,
    XBCaptureQualityLow = 3,
    XBCaptureQuality1280x720 = 4,
    XBCaptureQualityiFrame1280x720 = 5,
    XBCaptureQualityiFrame960x540 = 6,
    XBCaptureQuality640x480 = 7,
    XBCaptureQuality352x288 = 8
}SessionPresetQuality;


typedef void(^takeAPhotoWithCompletionHandler)(UIImage *imageCompletion, XBPhotoOrientation processWithOrient);

@interface AVCamCaptureManager : NSObject {
}

@property (nonatomic,retain) AVCaptureSession *session;
@property (nonatomic,assign) AVCaptureVideoOrientation orientation;
@property (nonatomic,retain) AVCaptureDeviceInput *videoInput;
@property (nonatomic,retain) AVCaptureDeviceInput *audioInput;
@property (nonatomic,retain) AVCaptureStillImageOutput *stillImageOutput;
@property (nonatomic,retain) AVCamRecorder *recorder;
@property (nonatomic,assign) id deviceConnectedObserver;
@property (nonatomic,assign) id deviceDisconnectedObserver;
@property (nonatomic,assign) UIBackgroundTaskIdentifier backgroundRecordingID;
@property (nonatomic,assign) id <AVCamCaptureManagerDelegate> delegate;

@property (nonatomic, assign) XBPhotoOrientation photoOrientation;
@property (nonatomic, readonly) BOOL focusPointSupported;
@property (nonatomic, readonly) BOOL exposurePointSupported;
@property (assign, nonatomic) XBFlashMode flashMode;
@property (assign, nonatomic) XBTorchMode torchMode;
@property (assign, nonatomic) BOOL autoWhiteBalance;

@property (assign, nonatomic) SessionPresetQuality imageCaptureQuality;

//- (void) autoFocusAtPoint:(CGPoint)point;
- (void) setFocusAtPoint:(CGPoint)point;
- (void) setExposureAtPoint:(CGPoint)exposurePoint;

- (AVCaptureConnection*)videoCaptureConnection;
- (BOOL) setupSession;
- (void) startRecording;
- (void) stopRecording;
- (void) captureStillImageWithCompletion:(takeAPhotoWithCompletionHandler)completion;
- (BOOL) toggleCamera;
- (NSUInteger) cameraCount;
- (NSUInteger) micCount;

@end

// These delegate methods can be called on any arbitrary thread. If the delegate does something with the UI when called, make sure to send it to the main thread.
@protocol AVCamCaptureManagerDelegate <NSObject>
@optional
- (void) captureManager:(AVCamCaptureManager *)captureManager didFailWithError:(NSError *)error;

- (void) captureManagerRecordingBegan:(AVCamCaptureManager *)captureManager;
- (void) captureManagerRecordingFinished:(AVCamCaptureManager *)captureManager;
- (void) captureManagerDeviceConfigurationChanged:(AVCamCaptureManager *)captureManager;

// for focus
- (void)avCamCaptureManagerDidBeginAdjustingFocus:(AVCamCaptureManager *)avCamCaptureManager;
- (void)avCamCaptureManagerDidFinishAdjustingFocus:(AVCamCaptureManager *)avCamCaptureManager;
- (void)avCamCaptureManagerDidBeginAdjustingExposure:(AVCamCaptureManager *)avCamCaptureManager;
- (void)avCamCaptureManagerDidFinishAdjustingExposure:(AVCamCaptureManager *)avCamCaptureManager;
- (void)avCamCaptureManagerDidBeginAdjustingWhiteBalance:(AVCamCaptureManager *)avCamCaptureManager;
- (void)avCamCaptureManagerDidFinishAdjustingWhiteBalance:(AVCamCaptureManager *)avCamCaptureManager;

@end
