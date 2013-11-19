//
//  DPointMenuViewController.h
//
//  Copyright (c) 2013 Whogot Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALRadialMenu.h"
#import "iCarousel.h"

@interface DPointMenuViewController : UIViewController
	<ALRadialMenuDelegate,
	iCarouselDataSource, iCarouselDelegate>
{
	
}

@property (nonatomic) IBOutlet	iCarousel*	carousel;
@property (nonatomic)	IBOutlet	UISegmentedControl*	segType;

- (IBAction)buttonPressed:(id)sender;
- (IBAction)segChanged:(id)sender;

@property (nonatomic) IBOutlet UIButton *button;

@property (nonatomic) ALRadialMenu *radialMenu;

@property (nonatomic) NSArray *popups;


@end
