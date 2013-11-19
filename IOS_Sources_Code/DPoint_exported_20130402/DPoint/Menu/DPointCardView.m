//
//  DPointCardView.m
//
//  Copyright (c) 2013 Whogot Inc. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "DPointCardView.h"
#import "JSBadgeView.h"

@interface DPointCardView ()

@property	UILabel*	label;
@property JSBadgeView*	badge;

@end


@implementation DPointCardView

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		// Initialization code
	}
	return self;
}

// 表示するカードの大きさ（この矩形に収まるように表示します）.
#define CARD_SIZE_W	(230.0f)
#define CARD_SIZE_H	(144.0f)

- (id) initWithImageNamed:(NSString*)imageName
{
	self = [super initWithFrame:CGRectMake(0, 0, CARD_SIZE_W, CARD_SIZE_H)];
	if (self) {
		// Initialization code
		self.image	= [UIImage imageNamed:imageName];
		self.contentMode = UIViewContentModeScaleAspectFit;
		
		// カードの大きさに合わせる（高さ基準）.
		CGRect	newFrame	= self.frame;
		CGFloat	imageW	= self.image.size.width;
		CGFloat	imageH	= self.image.size.height;
		newFrame.size.width	= CARD_SIZE_H/imageH * imageW;
		[self setFrame:newFrame];
		
		self.backgroundColor = [UIColor clearColor];
		
		self.label	= [[UILabel alloc] initWithFrame:self.bounds];
		self.label.backgroundColor = [UIColor clearColor];
		self.label.textAlignment = UITextAlignmentCenter;
		self.label.font = [self.label.font fontWithSize:50];
		[self addSubview:self.label];
		
		// badge.
		self.badge = [[JSBadgeView alloc] initWithParentView:self
																					alignment:JSBadgeViewAlignmentTopLeft];
		self.badge.badgeText = @"XXX";
		
		// for shadow.
		self.layer.masksToBounds = NO;
//		self.layer.cornerRadius = 8; // if you like rounded corners
		self.layer.shadowOffset = CGSizeZero;
		self.layer.shadowRadius = 5;
		self.layer.shadowOpacity = 0.5;
	}
	return self;
}


- (void) setLabelString:(NSString*)labelString
{
	[self.label setText:labelString];
	self.badge.badgeText = [NSString stringWithFormat:@"B%@", labelString];
}

/*
- (void)drawRect:(CGRect)rect
{
	CGContextRef currentContext = UIGraphicsGetCurrentContext();
	CGContextSaveGState(currentContext);
	CGContextSetShadow(currentContext, CGSizeMake(-15, 20), 5);
	
	[super drawRect: rect];
	
	CGContextRestoreGState(currentContext);
}
*/



/**
 *	選択カードとしての処理.
 */
- (void) setupForCurrent
{
	[self.badge setAlpha:1.0f];
}

/**
 *	選択カードとしての処理.
 */
- (void) clearCurrent
{
	[self.badge setAlpha:0.0f];
}


@end
