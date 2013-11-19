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
{
    
}

@property (nonatomic, strong) NSMutableArray *filterPathArray;
@property (nonatomic, strong) NSMutableArray *filterNameArray;
@property (nonatomic, assign) NSUInteger filterIndex;

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

@synthesize filterPathArray = _filterPathArray;
@synthesize filterNameArray = _filterNameArray;
@synthesize filterIndex = _filterIndex;

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
    
    _cameraCaptureView.updateSecondsPerFrame = NO;
    
    [self setupFilterPaths];
    self.filterIndex = 0;
    
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_isLoad) {
        [_cameraCaptureView startCapturing];
        
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
#pragma mark - Properties

- (void)setFilterIndex:(NSUInteger)filterIndex
{
    _filterIndex = filterIndex;
    
    //    self.filterLabel.text = [self.filterNameArray objectAtIndex:self.filterIndex];
    
    NSDictionary *paths = [self.filterPathArray objectAtIndex:self.filterIndex];
    NSArray *fsPaths = [paths objectForKey:kFSPathsKey];
    NSArray *vsPaths = [paths objectForKey:kVSPathsKey];
    NSError *error = nil;
    if (vsPaths != nil) {
        [_cameraCaptureView setFilterFragmentShaderPaths:fsPaths vertexShaderPaths:vsPaths error:&error];
    }
    else {
        [_cameraCaptureView setFilterFragmentShaderPaths:fsPaths error:&error];
    }
    
    if (error != nil) {
        NSLog(@"Error setting shader: %@", [error localizedDescription]);
    }
    
    // Perform a few filter-specific initialization steps, like setting additional textures and uniforms
    NSString *filterName = [self.filterNameArray objectAtIndex:self.filterIndex];
    if ([filterName isEqualToString:@"Overlay"]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"LucasCorrea" ofType:@"png"];
        XBGLTexture *texture = [[XBGLTexture alloc] initWithContentsOfFile:path options:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], GLKTextureLoaderOriginBottomLeft, nil] error:NULL];
        XBGLProgram *program = [_cameraCaptureView.programs objectAtIndex:0];
        [program bindSamplerNamed:@"s_overlay" toXBTexture:texture unit:1];
        [program setValue:(void *)&GLKMatrix2Identity forUniformNamed:@"u_rawTexCoordTransform"];
    }
    else if ([filterName isEqualToString:@"Sharpen"]) {
        GLKMatrix2 rawTexCoordTransform = (GLKMatrix2){_cameraCaptureView.cameraPosition == XBCameraPositionBack? 1: -1, 0, 0, -0.976};
        XBGLProgram *program = [_cameraCaptureView.programs objectAtIndex:1];
        [program bindSamplerNamed:@"s_mainTexture" toTexture:_cameraCaptureView.mainTexture unit:1];
        [program setValue:(void *)&rawTexCoordTransform forUniformNamed:@"u_rawTexCoordTransform"];
    }
}

#pragma mark - Methods

- (void)setupFilterPaths
{
    NSString *defaultVSPath = [[NSBundle mainBundle] pathForResource:@"DefaultVertexShader" ofType:@"glsl"];
    NSString *defaultFSPath = [[NSBundle mainBundle] pathForResource:@"DefaultFragmentShader" ofType:@"glsl"];
    NSString *overlayFSPath = [[NSBundle mainBundle] pathForResource:@"OverlayFragmentShader" ofType:@"glsl"];
    NSString *overlayVSPath = [[NSBundle mainBundle] pathForResource:@"OverlayVertexShader" ofType:@"glsl"];
    NSString *luminancePath = [[NSBundle mainBundle] pathForResource:@"LuminanceFragmentShader" ofType:@"glsl"];
    NSString *blurFSPath = [[NSBundle mainBundle] pathForResource:@"BlurFragmentShader" ofType:@"glsl"];
    NSString *sharpFSPath = [[NSBundle mainBundle] pathForResource:@"UnsharpMaskFragmentShader" ofType:@"glsl"];
    NSString *hBlurVSPath = [[NSBundle mainBundle] pathForResource:@"HBlurVertexShader" ofType:@"glsl"];
    NSString *vBlurVSPath = [[NSBundle mainBundle] pathForResource:@"VBlurVertexShader" ofType:@"glsl"];
    NSString *discretizePath = [[NSBundle mainBundle] pathForResource:@"DiscretizeShader" ofType:@"glsl"];
    NSString *pixelatePath = [[NSBundle mainBundle] pathForResource:@"PixelateShader" ofType:@"glsl"];
    NSString *suckPath = [[NSBundle mainBundle] pathForResource:@"SuckShader" ofType:@"glsl"];
    
    // Setup a combination of these filters
    self.filterPathArray = [[NSMutableArray alloc] initWithObjects:
                            [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObject:defaultFSPath], kFSPathsKey, nil], // No Filter
                            [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObject:overlayFSPath], kFSPathsKey, [NSArray arrayWithObject:overlayVSPath], kVSPathsKey, nil], // Overlay
                            [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObject:suckPath], kFSPathsKey, nil], // Spread
                            [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObject:pixelatePath], kFSPathsKey, nil], // Pixelate
                            [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObject:discretizePath], kFSPathsKey, nil], // Discretize
                            [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObject:luminancePath], kFSPathsKey, nil], // Luminance
                            [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObject:blurFSPath], kFSPathsKey, [NSArray arrayWithObject:hBlurVSPath], kVSPathsKey,nil], // Horizontal Blur
                            [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObject:blurFSPath], kFSPathsKey, [NSArray arrayWithObject:vBlurVSPath], kVSPathsKey,nil], // Vertical Blur
                            [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObjects:blurFSPath, blurFSPath, nil], kFSPathsKey, [NSArray arrayWithObjects:vBlurVSPath, hBlurVSPath, nil], kVSPathsKey, nil], // Blur
                            [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObjects:luminancePath, blurFSPath, blurFSPath, nil], kFSPathsKey, [NSArray arrayWithObjects:defaultVSPath, vBlurVSPath, hBlurVSPath, nil], kVSPathsKey, nil], // Blur B&W
                            [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObjects:blurFSPath, sharpFSPath, nil], kFSPathsKey, [NSArray arrayWithObjects:vBlurVSPath, hBlurVSPath, nil], kVSPathsKey, nil], // Sharpen
                            [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObjects:blurFSPath, blurFSPath, discretizePath, nil], kFSPathsKey, [NSArray arrayWithObjects:vBlurVSPath, hBlurVSPath, defaultVSPath, nil], kVSPathsKey, nil], nil]; // Discrete Blur
    
    self.filterNameArray = [[NSMutableArray alloc] initWithObjects:@"No Filter", @"Overlay", @"Spread", @"Pixelate", @"Discretize", @"Luminance", @"Horizontal Blur", @"Vertical Blur", @"Blur", @"Blur B&W", @"Sharpen", @"Discrete Blur", nil];
}
/*****************************************************************************************/

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
    if (gesture.state == UIGestureRecognizerStateRecognized) {
        
        CGPoint location = [gesture locationInView:_cameraCaptureView];
        
        [_cameraCaptureView focusAtPoint:location];
    }
}

/*****************************************************************************************/
#pragma mark - XBFilteredCameraViewDelegate
- (void)filteredView:(XBFilteredView *)filteredView didChangeMainTexture:(GLuint)mainTexture
{
    // The Sharpen filter uses the mainTexture (raw camera image) which might change names (because of the CVOpenGLESTextureCache), then we
    // need to update it whenever it changes.
    if ([[self.filterNameArray objectAtIndex:self.filterIndex] isEqualToString:@"Sharpen"]) {
        XBGLProgram *program = [_cameraCaptureView.programs objectAtIndex:1];
        [program bindSamplerNamed:@"s_mainTexture" toTexture:_cameraCaptureView.mainTexture unit:1];
    }
}

- (void)filteredCameraView:(XBFilteredCameraView *)filteredCameraView didUpdateSecondsPerFrame:(NSTimeInterval)secondsPerFrame
{
    //self.secondsPerFrameLabel.text = [NSString stringWithFormat:@"spf: %.4f", secondsPerFrame];
}
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
        [_cameraCaptureView setFlashMode:(XBFlashModeOn)];
    }
    else {
        [_cameraCaptureView setFlashMode:(XBFlashModeOff)];
    }
    
    if (_cameraCaptureView.flashMode == XBFlashModeNotSupport) {
        sender.tag = 0;
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
    
    // Perform filter specific setup before taking the photo
    NSString *filterName = [self.filterNameArray objectAtIndex:self.filterIndex];
    if ([filterName isEqualToString:@"Overlay"]) {
        GLKMatrix2 rawTexCoordTransform = _cameraCaptureView.rawTexCoordTransform;
        XBGLProgram *program = [_cameraCaptureView.programs objectAtIndex:0];
        [program setValue:(void *)&rawTexCoordTransform forUniformNamed:@"u_rawTexCoordTransform"];
    }
    else if ([filterName isEqualToString:@"Sharpen"]) {
        GLKMatrix2 rawTexCoordTransform = GLKMatrix2Multiply(_cameraCaptureView.rawTexCoordTransform, (GLKMatrix2){_cameraCaptureView.cameraPosition == XBCameraPositionBack? 1: -1, 0, 0, -1});
        XBGLProgram *program = [_cameraCaptureView.programs objectAtIndex:1];
        [program setValue:(void *)&rawTexCoordTransform forUniformNamed:@"u_rawTexCoordTransform"];
    }
    
    [_cameraCaptureView takeAPhotoWithCompletion:^(UIImage *imageCompletion, XBPhotoOrientation processWithOrient) {
        
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
        
        // Restore filter-specific state
        NSString *filterName = [self.filterNameArray objectAtIndex:self.filterIndex];
        if ([filterName isEqualToString:@"Overlay"]) {
            XBGLProgram *program = [_cameraCaptureView.programs objectAtIndex:0];
            [program setValue:(void *)&GLKMatrix2Identity forUniformNamed:@"u_rawTexCoordTransform"];
        }
        else if ([filterName isEqualToString:@"Sharpen"]) {
            GLKMatrix2 rawTexCoordTransform = (GLKMatrix2){_cameraCaptureView.cameraPosition == XBCameraPositionBack? 1: -1, 0, 0, -0.976};
            XBGLProgram *program = [_cameraCaptureView.programs objectAtIndex:1];
            [program setValue:(void *)&rawTexCoordTransform forUniformNamed:@"u_rawTexCoordTransform"];
        }
        
        imageCompletion = nil;
        
        _viewCaptures.userInteractionEnabled = YES;
        [self hiddenCaptureView:YES animated:YES];
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
    _cameraCaptureView.cameraPosition = _cameraCaptureView.cameraPosition == XBCameraPositionBack? XBCameraPositionFront: XBCameraPositionBack;
    
    // The Sharpen filter needs to update its rawTexCoordTransform because it displays the mainTexture itself (raw camera texture) which flips
    // when we swap between the front/back camera.
    if ([[self.filterNameArray objectAtIndex:self.filterIndex] isEqualToString:@"Sharpen"]) {
        GLKMatrix2 rawTexCoordTransform = (GLKMatrix2){_cameraCaptureView.cameraPosition == XBCameraPositionBack? 1: -1, 0, 0, -0.976};
        XBGLProgram *program = [_cameraCaptureView.programs objectAtIndex:1];
        [program setValue:(void *)&rawTexCoordTransform forUniformNamed:@"u_rawTexCoordTransform"];
    }
    
    [_cameraCaptureView setFlashMode:XBFlashModeOff];
    [_cameraCaptureView setTorchMode:XBTorchModeOff];
    _btnFlash.tag = 0;
    [_btnFlash setImage:[UIImage imageNamed:@"flash_dis_icon.png"] forState:(UIControlStateNormal)];
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
    self.filterIndex = (self.filterIndex + 1) % self.filterPathArray.count;
}
/*****************************************************************************************/
/*****************************************************************************************/
- (void)hiddenCaptureView:(BOOL)hide animated:(BOOL)animated
{
    if (hide) {
        [_cameraCaptureView stopCapturing];
        _imgVCompleted.hidden = NO;
    }
    else {
        [_cameraCaptureView startCapturing];
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
