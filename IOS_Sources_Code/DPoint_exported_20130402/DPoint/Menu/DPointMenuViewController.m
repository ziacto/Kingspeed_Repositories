//
//  DPointMenuViewController.m
//
//  Copyright (c) 2013 Whogot Inc. All rights reserved.
//

#import "DPointMenuViewController.h"
#import "DPointCardView.h"

@interface DPointMenuViewController ()

@property (nonatomic) NSMutableArray*	items;

@end

@implementation DPointMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		// Custom initialization
	}
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	
	NSLog(@"%s", __PRETTY_FUNCTION__);
	
	// create menu.
	self.radialMenu = [[ALRadialMenu alloc] init];
	self.radialMenu.delegate = self;
	
	// cards.
	[self setUpCards];
	
	// title.
	[self setTitle:@"代官山ポイント"];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark - methods

- (IBAction)buttonPressed:(id)sender
{
	NSLog(@"%s", __PRETTY_FUNCTION__);
	
	// open!
	[self.radialMenu buttonsWillAnimateFromButton:sender inView:self.view];
}

- (IBAction)segChanged:(id)sender
{
	NSLog(@"%s", __PRETTY_FUNCTION__);
	
	UISegmentedControl*	segType	= (UISegmentedControl*)sender;
	switch( segType.selectedSegmentIndex ){
		case 0:
			self.carousel.type	= iCarouselTypeDPointMenuA;
			break;
		case 1:
			self.carousel.type	= iCarouselTypeDPointMenuB;
			break;
		case 2:
			self.carousel.type	= iCarouselTypeDPointMenuC;
			break;
		case 3:
			self.carousel.type	= iCarouselTypeDPointMenuD;
			break;
		default:
			break;
	}
}

#pragma mark - ALRadialMenuDelegate protocol.


/**
 * when called with this message delegate's should return the number of items that will be displayed
 * @return number of items to display
 * @param radialMenu the radial menu object making the request
 */
- (NSInteger) numberOfItemsInRadialMenu:(ALRadialMenu *)radialMenu
{
	return 4;
}

/**
 * when called with this message delegate's should return the start of the arc.
 * @return start of the arc
 * @param radialMenu the radial menu object making the request
 */
- (NSInteger) arcStartForRadialMenu:(ALRadialMenu *)radialMenu
{
	return 180;
}

/**
 * when called with this message delegate's should return the size of the arc (how far the objects are spread) the items will be draw in
 * @return size of the arc
 * @param radialMenu the radial menu object making the request
 */
- (NSInteger) arcSizeForRadialMenu:(ALRadialMenu *)radialMenu
{
	return 90;
}

/**
 * when called with this message delegate's should return the arc radius (distance between the button and objects final resting spot)
 * @return radius for the arc
 * @param radialMenu the radial menu object making the request
 */
- (NSInteger) arcRadiusForRadialMenu:(ALRadialMenu *)radialMenu
{
	return 120;
}


/**
 * delegate's should return the image to be displayed at the the given index
 * @return image to be displayed
 * @param radialMenu the radial menu object making the request
 * @param index the item to be displayed
 */
- (UIImage *) radialMenu:(ALRadialMenu *)radialMenu
					 imageForIndex:(NSInteger)index
{
	if (index == 1) {
		return [UIImage imageNamed:@"tab_global_home_off"];
	} else if (index == 2) {
		return [UIImage imageNamed:@"tab_global_point_off"];
	} else if (index == 3) {
		return [UIImage imageNamed:@"tab_global_coupon_off"];
	} else if (index == 4) {
		return [UIImage imageNamed:@"tab_global_map_off"];
	}
	return nil;
}

/**
 * this method will notify the delegates any time a button from the radial menu is pressed
 * @param radialMenu the radial menu object that the button appeared from
 * @param index the index of the button that was touched
 */
- (void) radialMenu:(ALRadialMenu *)radialMenu
didSelectItemAtIndex:(NSInteger)index
{
	NSLog(@"%s -- [%d]", __PRETTY_FUNCTION__, index);
	
	[self.radialMenu itemsWillDisapearIntoButton:self.button];
}

/**
 * when called with this message delegate's should return the size of the button.
 * @return size of the button
 * @param radialMenu the radial menu object making the request
 */
- (float) buttonSizeForRadialMenu:(ALRadialMenu *)radialMenu
										buttonAtIndex:(int)index
{
	if (index == 1) {
		return 51.0f;
	}
	else{
		return 41.0f;
	}
}

#pragma mark - methods.

- (void)setUpCards
{
	//set up data
	self.items = [NSMutableArray array];
	for (int i = 0; i < 30; i++){
		[self.items addObject:[NSNumber numberWithInt:i]];
	}
	
	// setup carousel.
	self.carousel.type			= iCarouselTypeDPointMenuA;
	self.carousel.vertical	= YES;
	[self.carousel reloadData];
}

#pragma mark - iCarousel.


- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
	return [self.items count];
}

- (UIView*)carousel:(iCarousel *)carousel
 viewForItemAtIndex:(NSUInteger)index
				reusingView:(UIView *)view
{
//	UILabel *label = nil;
	
	DPointCardView*	cardView	= (DPointCardView*)view;
	
	//create new view always.
	cardView	= [[DPointCardView alloc] initWithImageNamed:@"sample_card_big.png"];
	/*
	if( (index%2)==0 ){
		cardView	= [[DPointCardView alloc] initWithImageNamed:@"sample_card_big.png"];
	}
	else{
		cardView	= [[DPointCardView alloc] initWithImageNamed:@"sample_cardB_big.png"];
	}
	 */
	
	[cardView setLabelString:[[self.items objectAtIndex:index] stringValue]];
	
	return cardView;
}

- (CGFloat)carousel:(iCarousel *)_carousel
		 valueForOption:(iCarouselOption)option
				withDefault:(CGFloat)value
{
	switch (option){
		case iCarouselOptionWrap:
		{
			return YES;
		}
		case iCarouselOptionFadeMax:
		{
			if (self.carousel.type == iCarouselTypeCustom){
				return 0.0f;
			}
			return value;
		}
		case iCarouselOptionArc:
		{
			return 2.0f*M_PI * (0.15f);
		}
		case iCarouselOptionRadius:
		{
			return value * (0.8f);
		}
		case iCarouselOptionTilt:
		{
			return (0.9f);
		}
		case iCarouselOptionSpacing:
		{
			return value * (2.5f);
		}
		default:
		{
			return value;
		}
	}
}

// スクロール開始.
- (void)carouselWillBeginDragging:(iCarousel *)carousel
{
	[self clearCurrentCards];
}


// スクロール停止.
- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel
{
	[self clearCurrentCards];
	[self updateCurrentCard];
}

- (void)carouselDidScroll:(iCarousel *)carousel
{
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
	if( index == carousel.currentItemIndex ){
		// 中央にあるカードがタッチされたとき.
		[self setTitle:[NSString stringWithFormat:@"カード:%d", index]];
	}
	else{
		// 横にあるカードがタッチされたとき.
	}
}

#pragma mark - methods.

- (void) clearCurrentCards
{
	NSArray*	visibleCards	= self.carousel.visibleItemViews;
	if( visibleCards ){
		// クリア.
		NSEnumerator*	enumCard	= [visibleCards objectEnumerator];
		DPointCardView*	card;
		while( card = [enumCard nextObject] ){
			[card clearCurrent];
		}
	}
}

- (void) updateCurrentCard
{
	// 設定.
	DPointCardView*	currentCard	= (DPointCardView*)self.carousel.currentItemView;
	if( currentCard ){
		[currentCard setupForCurrent];
	}
}


@end
