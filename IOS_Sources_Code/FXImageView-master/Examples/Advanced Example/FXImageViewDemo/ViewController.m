//
//  ViewController.m
//  ImageFXViewDemo
//
//  Created by Nick Lockwood on 31/10/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@property (nonatomic, strong) NSArray *imagePaths;

@end


@implementation ViewController

@synthesize carousel = _carousel;
@synthesize imagePaths = _imagePaths;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
    {
        //get image paths
        self.imagePaths = [[NSBundle mainBundle] pathsForResourcesOfType:@"jpg" inDirectory:@"Lake"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //configure carousel
    _carousel.type = iCarouselTypeWheel;
}

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [_imagePaths count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    //create new view if no view is available for recycling
    if (view == nil)
    {
        FXImageView *imageView = [[[FXImageView alloc] initWithFrame:CGRectMake(0, 0, 200.0f, 200.0f)] autorelease];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.asynchronous = YES;
        imageView.reflectionScale = 0.5f;
        imageView.reflectionAlpha = 0.25f;
        imageView.reflectionGap = 10.0f;
        imageView.shadowOffset = CGSizeMake(0.0f, 2.0f);
        imageView.shadowBlur = 5.0f;
        imageView.cornerRadius = 10.0f;
        
        view = imageView;
    }
    
    //load image
    [(FXImageView *)view setImageWithContentsOfFile:[_imagePaths objectAtIndex:index]];
    
    return view;
}

//- (CATransform3D)carousel:(iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform atIndex:(NSInteger)itemIndex
//{
////    if (itemIndex != carousel.currentItemIndex) {
////        CATransform3D transform__ = CATransform3DMakeScale(0.6, 0.6, 1.);
////        return transform__;
////    }
//    return transform;
//}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)dealloc
{
    [_carousel release];
    [_imagePaths release];
    [super dealloc];
}

@end
