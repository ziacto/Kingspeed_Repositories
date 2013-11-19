/***********************************************************************
 *	File name:	ObjectsPagesView.h
 *	Project:	Photo Albums
 *	Description:
 *  Author:		Dat Nguyen Mau
 *  Created:    on 3/1/12.
 *	Device:		Iphone vs IPad
 *  Company:	__MyCompanyName__
 *  Copyright:	2012 . All rights reserved.
 ***********************************************************************/

#import <UIKit/UIKit.h>
#import "OneObjectView.h"
#import "ObjectsScrollView.h"
#import "ObjectsPageControl.h"

@class OneObjectView;

@class ObjectsPagesView;
@protocol ObjectsPagesViewDelegate <NSObject>
-(void)launcherViewItemSelected:(OneObjectView*)item;
-(void)launcherViewDidBeginEditing:(ObjectsPagesView*)sender;
-(void)launcherViewDidEndEditing:(ObjectsPagesView*)sender;
@end

@interface ObjectsPagesView : UIView <UIScrollViewDelegate, OneObjectViewDelegate> {	
    UIDeviceOrientation currentOrientation;
	BOOL itemsAdded;
	BOOL editing;
	BOOL dragging;
    BOOL editingAllowed;
	NSInteger numberOfImmovableItems;
    
	int columnCount;
	int rowCount;
	CGFloat itemWidth;
	CGFloat itemHeight;
    CGFloat minX;
    CGFloat minY;
    CGFloat paddingX;
    CGFloat paddingY;
}

@property (nonatomic) BOOL editingAllowed;
@property (nonatomic) NSInteger numberOfImmovableItems;
@property (nonatomic, retain) id <ObjectsPagesViewDelegate> delegate;
@property (nonatomic, retain) ObjectsScrollView *pagesScrollView;
@property (nonatomic, retain) ObjectsPageControl *pageControl;
@property (nonatomic, retain) NSMutableArray *pages;

// Default for animation below is YES

-(void)setPages:(NSMutableArray *)pages animated:(BOOL)animated;
-(void)setPages:(NSMutableArray *)pages numberOfImmovableItems:(NSInteger)items;
-(void)setPages:(NSMutableArray *)pages numberOfImmovableItems:(NSInteger)items animated:(BOOL)animated;

-(void)viewDidAppear:(BOOL)animated;
-(void)setCurrentOrientation:(UIInterfaceOrientation)newOrientation;
-(void)layoutLauncher;
-(void)layoutLauncherAnimated:(BOOL)animated;
-(int)maxItemsPerPage;
-(int)maxPages;

@end
