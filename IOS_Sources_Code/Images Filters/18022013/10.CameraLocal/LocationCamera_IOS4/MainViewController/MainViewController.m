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

#import "MainViewController.h"
#import "AppDelegate.h"

#import "UIImage+FiltrrCompositions.h"
#import "UIImage+Scale.h"
#import "UIImage+Filtering.h"

#define kVSPathsKey @"vsPaths"
#define kFSPathsKey @"fsPaths"

@interface MainViewController () <UIGestureRecognizerDelegate>
@end


@interface MainViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, LocationManagerDelegate>
{
    BOOL _isLoad;
    
    NSMutableArray *_arrDataOverlays;
    
    // For location
    LocationManager *_locationMgr;
    NSMutableArray *_currentAddress;
    NSDictionary *_dictWeather;
}

@end


@implementation MainViewController

#pragma mark-
#pragma mark View Life Cycle _____________________________________________________
/********************************************************************************/
//              View Life Cycle
/********************************************************************************/

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.wantsFullScreenLayout = YES;
    _isLoad = YES;
    
    _arrDataOverlays = [[NSMutableArray alloc] init];
    [_arrDataOverlays addObject:@"bar_open.png"];
    [_arrDataOverlays addObject:@"cheers_BG.png"];
    [_arrDataOverlays addObject:@"cheers_bg@2x.png"];
    [_arrDataOverlays addObject:@"delicious.png"];
    [_arrDataOverlays addObject:@"greetings_zaciemka.png"];
    [_arrDataOverlays addObject:@"greetings.png"];
    [_arrDataOverlays addObject:@"i_bomb.png"];
    [_arrDataOverlays addObject:@"i_love.png"];
    [_arrDataOverlays addObject:@"loveit.png"];
    [_arrDataOverlays addObject:@"loves_you.png"];
    [_arrDataOverlays addObject:@"wishyou_bg.png"];
    [_arrDataOverlays addObject:@"yummyyummy.png"];
    
    _overlayCams = [[PagingViewLandscape alloc] initWithFrame:_imgVCompleted.frame];
    _overlayCams.delegate = self;
    [_viewCameraPhotos addSubview:_overlayCams];
    [_overlayCams reloadData];
    
    _currentAddress = [[NSMutableArray alloc] init];
    _locationMgr = [LocationManager sharedInstance];
    _locationMgr.delegate = self;
    _pageControl.currentPage = 0;
    _pageControl.numberOfPages = _arrDataOverlays.count;
    
    if (ALLOW_ZOOMING) {
        _avCamCaptureView.allowZooming = YES;
    }
    
    // For Filters Image
    /*
    _arrEffects = [[NSMutableArray alloc] initWithObjects:
                  [NSDictionary dictionaryWithObjectsAndKeys:@"Original",@"title",@"",@"method", nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"E1",@"title",@"e1",@"method", nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"E2",@"title",@"e2",@"method", nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"E3",@"title",@"e3",@"method", nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"E4",@"title",@"e4",@"method", nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"E5",@"title",@"e5",@"method", nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"E6",@"title",@"e6",@"method", nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"E7",@"title",@"e7",@"method", nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"E8",@"title",@"e8",@"method", nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"E9",@"title",@"e9",@"method", nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"E10",@"title",@"e10",@"method", nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"E11",@"title",@"e11",@"method", nil],
                  nil];
    
    UIImage *selectedImage = [UIImage imageNamed:@"filter_bgr.png"];
    UIImage *thumbImage = [selectedImage scaleToSize:CGSizeMake(320, 320)];
    UIImage *minithumbImage = [thumbImage scaleToSize:CGSizeMake(48, 48)];
    
    for (int i = 0; i < _arrEffects.count; i++) {
        UIButton *_btnEffect = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _btnEffect.frame = CGRectMake(i * 48 + (i) * 4, 0, 48, 48);
        [_scrollFilters addSubview:_btnEffect];
     
        UIImage *imageBtn;
        
        if(((NSString *)[[_arrEffects objectAtIndex:i] valueForKey:@"method"]).length > 0) {
            SEL _selector = NSSelectorFromString([[_arrEffects objectAtIndex:i] valueForKey:@"method"]);
            imageBtn = [minithumbImage performSelector:_selector];
        } else
            imageBtn = minithumbImage;
        
        _btnEffect.tag = i;
        [_btnEffect setImage:imageBtn forState:(UIControlStateNormal)];
        [_btnEffect addTarget:self action:@selector(changeFilterImage:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    
    _scrollFilters.contentSize = CGSizeMake(_arrEffects.count * (48 + 4) - 4, 48);
     */
}
/*
- (void)changeFilterImage:(UIButton*)btnFlter
{
    if(((NSString *)[[_arrEffects objectAtIndex:btnFlter.tag] valueForKey:@"method"]).length > 0) {
        
#ifndef TRACKTIME
        
        _imgVCompleted.image = [_imgVCompleted.image grayscale];
        
//        SEL _selector = NSSelectorFromString([[_arrEffects objectAtIndex:btnFlter.tag] valueForKey:@"method"]);
//        [_imgVCompleted setImage:[_imgVCompleted.image performSelector:_selector]];
        
#else
        
        SEL _track = NSSelectorFromString(@"trackTime:");
        [_imgVCompleted setImage:[_imgVCompleted.image performSelector:_track withObject:[[arrEffects objectAtIndex:btnFlter.tag] valueForKey:@"method"]]];
        
#endif
        
    } else {
//        [_imgVCompleted setImage:thumbImage];
    }
}
*/
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_isLoad) {
//        [self performSelector:@selector(locateClick:) withObject:nil afterDelay:0.3];
    }
    
    _isLoad = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

/*****************************************************************************************/
/*****************************************************************************************/
#pragma mark-
#pragma mark Paging View Delegate Methods ________________________________________
/********************************************************************************/
//              Paging View Delegate Methods
/********************************************************************************/

- (NSInteger)numberOfPagesLandscapeInPagingView:(PagingViewLandscape *)pagingView
{
    return _arrDataOverlays.count;
}

- (UIView *)viewForPageLandscapeInPagingView:(PagingViewLandscape *)pagingView atIndex:(NSInteger)index
{
    UIPageView *pageView = (UIPageView*)[pagingView dequeueReusablePage];
    UIImage *image = [UIImage imageNamed:[_arrDataOverlays objectAtIndex:index]];
    
    if (!pageView || ![pageView isKindOfClass:[UIPageView class]]) {
        pageView = [[UIPageView alloc] initWithFrame:pagingView.frame image:image];
        
        // Add a single tap gesture to focus on the point tapped, then lock focus
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapToAutoFocus:)];
        [singleTap setNumberOfTapsRequired:1];
        [pageView addGestureRecognizer:singleTap];
        
        if (ALLOW_ZOOMING) {
            UIPinchGestureRecognizer *_pinchZoom = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchZoomCamera:)];
            [_pinchZoom setDelegate:self];
            [pageView addGestureRecognizer:_pinchZoom];
        }
    }
    else {
        pageView.imagePage = image;
    }
    
    if (_currentAddress.count > 1){
        int index = (arc4random() % (_currentAddress.count - 2)) + 1;
        
        pageView.locationText = [_currentAddress objectAtIndex:index];
    }
    
    if (_dictWeather) {
        NSString *week = [[[_dictWeather objectForKey:@"yweather:forecast"] objectAtIndex:0] objectForKey:@"_day"];
        NSString *date = [[[_dictWeather objectForKey:@"yweather:forecast"] objectAtIndex:0] objectForKey:@"_date"];
        NSString *low = [[[_dictWeather objectForKey:@"yweather:forecast"] objectAtIndex:0] objectForKey:@"_low"];
        NSString *high = [[[_dictWeather objectForKey:@"yweather:forecast"] objectAtIndex:0] objectForKey:@"_high"];
        NSString *text = [[[_dictWeather objectForKey:@"yweather:forecast"] objectAtIndex:0] objectForKey:@"_text"];
        
        NSString *weatherInfo = [week stringByAppendingFormat:@", %@: %@°C - %@°C\nMore info: %@",date,low,high,text];
        pageView.weatherInfo = weatherInfo;
    }
    
    return pageView;
}
- (void)currentPageLandscapeDidChangeInPagingView:(PagingViewLandscape *)pagingView nextPage:(BOOL)isNext
{
    _pageControl.currentPage = pagingView.currentPageIndex;
}
- (void)pagesLandscapeDidChangeInPagingView:(PagingViewLandscape *)pagingView
{
    _pageControl.currentPage = pagingView.currentPageIndex;
}


- (void)singleTapToAutoFocus:(UIGestureRecognizer*)gesture
{
    [_avCamCaptureView tapToAutoFocus:gesture];
}

/*****************************************************************************************/
/*****************************************************************************************/
#pragma mark-
#pragma mark Button Actions _____________________________________________________
/********************************************************************************/
//              Button Actions
/********************************************************************************/
- (IBAction)flashClick:(UIButton*)sender
{
    sender.tag = !sender.tag;
    
    if (sender.tag) {
        _avCamCaptureView.flashMode = XBFlashModeOn;
        if (_avCamCaptureView.flashMode == XBFlashModeNotSupport) {
            sender.tag = 0;
        }
    }
    else {
        _avCamCaptureView.flashMode = XBFlashModeOff;
        if (_avCamCaptureView.flashMode == XBFlashModeNotSupport) {
            sender.tag = 0;
        }
    }
    
    if (sender.tag) {
        [sender setImage:[UIImage imageNamed:@"flash_icon.png"] forState:(UIControlStateNormal)];
    }
    else {
        [sender setImage:[UIImage imageNamed:@"flash_dis_icon.png"] forState:(UIControlStateNormal)];
    }
}

- (IBAction)torchModeClick:(UIButton*)sender
{

}

- (IBAction)clickTakeAPicture:(UIButton *)sender
{
    _viewCaptures.userInteractionEnabled = NO;
    [DNProgressHub showHubToWindow];
    
    [_avCamCaptureView takeAPhotoWithCompletion:^(UIImage *imageCompletion, XBPhotoOrientation processWithOrient) {
        NSLog(@"_______________________ ImageCompletion: %f / %f", imageCompletion.size.width, imageCompletion.size.height);
        CGFloat rate = imageCompletion.size.width > imageCompletion.size.height ?
        imageCompletion.size.height / (_imgVCompleted.frame.size.height) : imageCompletion.size.width / (_imgVCompleted.frame.size.width);

        CGFloat xCrop = (imageCompletion.size.width - rate * _imgVCompleted.frame.size.width)/2.;
        CGFloat yCrop = (imageCompletion.size.height - rate * _imgVCompleted.frame.size.height)/2.;
        CGFloat widthCrop = rate * _imgVCompleted.frame.size.width;
        CGFloat heightCrop = rate * _imgVCompleted.frame.size.height;
        
        UIImage *cropImage = [[imageCompletion getSubImageWithRect:CGRectMake(xCrop, yCrop, widthCrop, heightCrop)] scaleToSize:CGSizeMake(_imgVCompleted.frame.size.width * 2., _imgVCompleted.frame.size.height * 2.)];
        
        _imgVCompleted.image = cropImage;
        cropImage = nil;
        
        if (!DEBUG_MODE) {
            UIImageWriteToSavedPhotosAlbum(imageCompletion, nil, nil, NULL);
        }
        
        imageCompletion = nil;
        
        if (_avCamCaptureView.devicePosition == AVCaptureDevicePositionBack) {
            [self hiddenCaptureView];
        }
        else {
            [self performSelector:@selector(hiddenCaptureView) withObject:nil afterDelay:0.2];
        }
        
        [DNProgressHub hideAllHubDNForWindow];
    }];
}

- (void)hiddenCaptureView
{
    _viewCaptures.userInteractionEnabled = YES;
    [self hiddenCaptureView:YES animated:YES];
}

- (IBAction)clickNewPhoto:(UIButton*)sender
{
    [self hiddenCaptureView:NO animated:YES];
    //=================================
}

/*****************************************************************************************/
/*****************************************************************************************/
- (IBAction)shareClick:(UIButton*)sender
{
    UIImage *imageShare = [self addOverlayToBaseImage:_imgVCompleted.image];
    
    if (!DEBUG_MODE) {
        UIImageWriteToSavedPhotosAlbum(imageShare, nil, nil, NULL);
    }
    
    FacebookView *_facebookView = [FacebookView shareInstanceWithXib];
    _facebookView.imagesPathForPost = [NSMutableArray arrayWithObjects:imageShare, nil];
    [self presentModalViewController:_facebookView animated:YES];
}
- (IBAction)switchCameraClick:(UIButton*)sender
{
    [_avCamCaptureView toggleCamera];
    
    [_avCamCaptureView setFlashMode:XBFlashModeOff];
    [_avCamCaptureView setTorchMode:XBTorchModeOff];
    _btnFlash.selected = NO;
}

/*****************************************************************************************/
/*****************************************************************************************/
- (IBAction)galeryClick:(UIButton*)sender
{
    _btnGalery1.tag = 0; _btnGalery2.tag = 0;
    sender.tag = 1;
    
    UIImagePickerController *_imagePicker = [[UIImagePickerController alloc] init];
    _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    _imagePicker.delegate = self;
    _imagePicker.allowsEditing = YES;
    [self presentModalViewController:_imagePicker animated:YES];
    
    if (sender == _btnGalery1) {
        [self hiddenCaptureView:YES animated:YES];
    }
}

/*****************************************************************************************/
/*****************************************************************************************/
/*****************************************************************************************/
- (IBAction)locateClick:(UIButton*)sender
{
    [DNProgressHub showHubToWindow];
    [_locationMgr startUpdateLocation];
}
- (IBAction)changeFilterButtonTouchUpInside:(id)sender
{
    
}
/*****************************************************************************************/
/*****************************************************************************************/
- (void)hiddenCaptureView:(BOOL)hide animated:(BOOL)animated
{
    if (hide) {
        [_avCamCaptureView stopRunningAVCam];
        _imgVCompleted.hidden = NO;
    }
    else {
        [_avCamCaptureView startRunningAVCam];
        _imgVCompleted.hidden = YES;
        _imgVCompleted.image = nil;
    }
    
    if (animated) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
    }
    if (hide) {
        if ([[UIScreen mainScreen] bounds].size.height >= 568) {
            _viewCaptures.center = CGPointMake(160, 200);
        }
        else {
            _viewCaptures.center = CGPointMake(160, 150);
        }
    }
    else {
        if ([[UIScreen mainScreen] bounds].size.height >= 568) {
            _viewCaptures.center = CGPointMake(160, 104);
        }
        else {
            _viewCaptures.center = CGPointMake(160, 78);
        }
    }
    if (animated) {
        [UIView commitAnimations];
    }
}

/*****************************************************************************************/
/*****************************************************************************************/
//                          Merge Image From Camera With Overlay Images
/*****************************************************************************************/
- (UIImage*)addOverlayToBaseImage:(UIImage*)baseImage
{
    UIImage *imageOvelay = [[_overlayCams currentPageView] image];
    
    CGSize imageInViewSize = imageOvelay.size;
    
    CGSize newSize = CGSizeMake(baseImage.size.width, baseImage.size.height);
    UIGraphicsBeginImageContext( newSize );
    
    // Use existing opacity as is
    [baseImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Apply supplied opacity
    
    CGFloat _scaleW = newSize.width / imageInViewSize.width;
    CGFloat _scaleH = newSize.height / imageInViewSize.height;
    
    CGFloat scale = _scaleW < _scaleH ? _scaleW : _scaleH;
    
    CGFloat yOverlay = (newSize.height - imageInViewSize.height * scale);
    
    [imageOvelay drawInRect:CGRectMake(0,yOverlay,imageInViewSize.width * scale ,imageInViewSize.height * scale) blendMode:kCGBlendModeNormal alpha:1.];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}
/*****************************************************************************************/
#define OFFSET_Y                        40
#define OFFSET_Y_568                    128

#define RATIO_IMAGE_FROM_SCREEN         2.
/*****************************************************************************************/
- (UIImage*)addImageToOverlay:(UIImage*)baseImage
{
    UIImage *imageOvelay = [[_overlayCams currentPageView] image];
    CGFloat _rateW1 = baseImage.size.width / ([UIScreen mainScreen].bounds.size.width * RATIO_IMAGE_FROM_SCREEN);
    CGFloat _rateH1 = baseImage.size.height / ([UIScreen mainScreen].bounds.size.height * RATIO_IMAGE_FROM_SCREEN);
    
    CGFloat _rate1 = _rateW1 < _rateH1 ? _rateW1 : _rateH1;
    
    CGSize image1InSize = CGSizeMake(baseImage.size.width / _rate1, baseImage.size.height / _rate1);
    
    UIGraphicsBeginImageContext( image1InSize );
    
    // Use existing opacity as is
    [baseImage drawInRect:CGRectMake(0,0,image1InSize.width,image1InSize.height)];
    // Apply supplied opacity
    
    CGFloat _scaleW = image1InSize.width / imageOvelay.size.width;
    CGFloat _scaleH = image1InSize.height / imageOvelay.size.height;
    
    CGFloat scale = _scaleW < _scaleH ? _scaleW : _scaleH;
    
    CGFloat yOverlay = (image1InSize.height - imageOvelay.size.height * scale);
    
    CGFloat _offsetY = 0.;
    
    if ([UIScreen mainScreen].bounds.size.height >= 568.) {
        _offsetY = OFFSET_Y_568/ _rate1;
    }
    else {
        _offsetY = OFFSET_Y/ _rate1;
    }
    
    yOverlay = yOverlay + _offsetY;
    
    [imageOvelay drawInRect:CGRectMake(0,yOverlay,imageOvelay.size.width * scale ,imageOvelay.size.height * scale) blendMode:kCGBlendModeNormal alpha:1.];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}
/*****************************************************************************************/
/*****************************************************************************************/
/*****************************************************************************************/
/*****************************************************************************************/
#pragma mark-
#pragma mark UIGestureRecognizer Delegate _______________________________________
/********************************************************************************/
//              UIGestureRecognizer Delegate
/********************************************************************************/
#if ALLOW_ZOOMING
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
	if ( [gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]] ) {
		[_avCamCaptureView handleBeginZoomingCamera];
	}
	return YES;
}
- (void)pinchZoomCamera:(UIGestureRecognizer *)gestureRecognizer
{
    [_avCamCaptureView handleZoomingCamera:(UIPinchGestureRecognizer*)gestureRecognizer];
}
#endif
/*****************************************************************************************/
#pragma mark-
#pragma mark UIImagePickerController Delegate ____________________________________
/********************************************************************************/
//              UIImagePickerController Delegate
/********************************************************************************/
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *imagePicked = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    _imgVCompleted.image = imagePicked;
    [picker dismissModalViewControllerAnimated:YES];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
    
    if (_btnGalery1.tag == 1) {
        [self hiddenCaptureView:NO animated:YES];
    }
}

#pragma mark-
#pragma mark Location Manager Delegate __________________________________________
/********************************************************************************/
//              Location Manager Delegate
/********************************************************************************/
- (void)locationReversedGoogleAPIWithAddressStreet:(NSMutableArray *)address jsonResult:(NSMutableArray *)jsonResult error:(NSError *)error
{
//    NSLog(@"_______________________________________ jsonResult\n%@", jsonResult);
//    NSLog(@"_______________________________________ AddressStreet\n%@", address);
    
    if (jsonResult) {
        [_currentAddress removeAllObjects];
        [_currentAddress addObjectsFromArray:[[[jsonResult objectAtIndex:0] objectForKey:@"formatted_address"] componentsSeparatedByString:@","]];
        
        [WeatherAPIData getWeatherYahooWithLatitude:_locationMgr.currentLocation.coordinate.latitude longitude:_locationMgr.currentLocation.coordinate.longitude completion:^(NSString *xmlWeather, NSDictionary *dictData) {
//            NSLog(@"____________________________________ XMLSTR:\n%@",xmlWeather);
            NSLog(@"____________________________________ XMLDic: %f / %f",_locationMgr.currentLocation.coordinate.latitude,_locationMgr.currentLocation.coordinate.longitude);
            
            if (dictData) {
                _dictWeather = dictData;
            }
            else {
                UIAlertView *_alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Get weather did fail." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [_alertView show];
            }
            
            [_overlayCams reloadData];
            [DNProgressHub hideAllHubDNForWindow];
        }];
    }
    else {
        [DNProgressHub hideAllHubDNForWindow];
        
        UIAlertView *_alertView = [[UIAlertView alloc] initWithTitle:@"Locate Failed" message:[NSString stringWithFormat:@"%@",error.domain] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [_alertView show];
    }
}
/*****************************************************************************************/
/*****************************************************************************************/

@end
