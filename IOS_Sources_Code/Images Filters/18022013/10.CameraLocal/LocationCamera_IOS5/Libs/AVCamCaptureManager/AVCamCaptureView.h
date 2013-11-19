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
#import "AVCamCaptureManager.h"

#define FOCUS_VIEW_SIZE     65

@interface AVCamCaptureView : UIView

@property (nonatomic, readonly) AVCaptureFocusMode focusMode;
@property (nonatomic, assign) BOOL allowZooming;
@property (nonatomic, assign) BOOL flashScreenWhenCapture;

@property (assign, nonatomic) XBFlashMode flashMode;
@property (assign, nonatomic) XBTorchMode torchMode;

@property (nonatomic, readonly) AVCaptureDevicePosition devicePosition;

- (void)tapToAutoFocus:(UIGestureRecognizer *)gestureRecognizer;
- (void)setExposureAtPoint:(CGPoint)exposurePoint;
- (void)handleBeginZoomingCamera;
- (void)handleZoomingCamera:(UIPinchGestureRecognizer *)recognizer;

- (BOOL) toggleCamera;
- (void) startRunningAVCam;
- (void) stopRunningAVCam;

- (void)takeAPhotoWithCompletion:(void (^)(UIImage *imageCompletion, XBPhotoOrientation processWithOrient))completion;

@end
