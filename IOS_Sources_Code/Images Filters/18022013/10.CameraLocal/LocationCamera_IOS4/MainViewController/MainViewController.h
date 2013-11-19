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
#import <QuartzCore/QuartzCore.h>

#import "UIView+additions.h"
#import "UIDevice+additions.h"

#import "UIImage+additions.h"
#import "MBProgressHUD.h"
#import "DNProgressHub.h"

#import "PagingViewLandscape.h"
#import "LocationManager.h"

#import "WeatherAPIData.h"

#import "AVCamCaptureView.h"

#define DEBUG_MODE  1
#define ALLOW_ZOOMING   0

@interface MainViewController : UIViewController<PagingViewLandscapeDelegate>
{
    IBOutlet UIButton *_btnSwitchCamera;
    IBOutlet UIButton *_btnFlash;
    IBOutlet UIButton *_btnCapture;
    IBOutlet UIButton *_btnGalery1;
    IBOutlet UIButton *_btnMore1;
    
    IBOutlet UIView *_viewCaptures;
    
    IBOutlet UIButton *_btnLocate;
    IBOutlet UIButton *_btnNewPhoto;
    IBOutlet UIButton *_btnRefresh;
    IBOutlet UIButton *_btnShare;
    IBOutlet UIButton *_btnGalery2;
    IBOutlet UIButton *_btnMore2;
    
    IBOutlet UIImageView *_imgVCompleted;
    IBOutlet UIView *_viewCameraPhotos;
    
    PagingViewLandscape *_overlayCams;
    IBOutlet UIPageControl *_pageControl;
    
    IBOutlet AVCamCaptureView *_avCamCaptureView;
    
    // For Image Filters
    IBOutlet UIScrollView *_scrollFilters;
    NSMutableArray *_arrEffects;
}

- (IBAction)flashClick:(UIButton*)sender;
- (IBAction)torchModeClick:(UIButton*)sender;

- (IBAction)clickTakeAPicture:(UIButton*)sender;
- (IBAction)clickNewPhoto:(UIButton*)sender;
- (IBAction)shareClick:(UIButton*)sender;
- (IBAction)switchCameraClick:(UIButton*)sender;
- (IBAction)galeryClick:(UIButton*)sender;
- (IBAction)locateClick:(UIButton*)sender;

// change filters
- (IBAction)changeFilterButtonTouchUpInside:(id)sender;
// change camera
//- (IBAction)cameraButtonTouchUpInside:(id)sender;

@end
