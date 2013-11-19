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

#import <Foundation/Foundation.h>

@protocol PagingViewLandscapeDelegate;

// a wrapper around UIScrollView in paging mode, with an API similar to UITableView
@interface PagingViewLandscape : UIView {
    // subviews
    UIScrollView *_scrollView;

    // properties
    id<PagingViewLandscapeDelegate> _delegate;
    CGFloat _gapBetweenPages;
    NSInteger _pagesToPreload;

    // state
    NSInteger _pageCount;
    NSInteger _currentPageIndex;
    NSInteger _firstLoadedPageIndex;
    NSInteger _lastLoadedPageIndex;
    NSMutableSet *_recycledPages;
    NSMutableSet *_visiblePages;

    NSInteger _previousPageIndex;

    BOOL _rotationInProgress;
    BOOL _scrollViewIsMoving;
    BOOL _recyclingEnabled;
    BOOL _horizontal;
    
    //
//    UIImageView *_imgBackground;
    NSInteger _oldPageIndex;
    BOOL _isFinishChange;
}

@property(nonatomic, strong) IBOutlet id<PagingViewLandscapeDelegate> delegate;

@property(nonatomic, assign) CGFloat gapBetweenPages;  // default is 20

@property(nonatomic, assign) NSInteger pagesToPreload;  // number of invisible pages to keep loaded to each side of the visible pages, default is 1

@property(nonatomic, readonly) NSInteger pageCount;

@property(nonatomic, assign) NSInteger currentPageIndex;
@property(nonatomic, assign, readonly) NSInteger previousPageIndex; // only for reading inside currentPageDidChangeInPagingView

@property(nonatomic, assign, readonly) NSInteger firstVisiblePageIndex;
@property(nonatomic, assign, readonly) NSInteger lastVisiblePageIndex;

@property(nonatomic, assign, readonly) NSInteger firstLoadedPageIndex;
@property(nonatomic, assign, readonly) NSInteger lastLoadedPageIndex;

@property(nonatomic, assign, readonly) BOOL moving;
@property(nonatomic, assign) BOOL recyclingEnabled;
@property(nonatomic, assign) BOOL horizontal;   // default YES

- (void)reloadData;  // must be called at least once to display something

- (UIView *)viewForPageAtIndex:(NSUInteger)index;  // nil if not loaded
- (UIView *)currentPageView;  // nil if not loaded

- (UIView *)dequeueReusablePage;  // nil if none

- (void)willAnimateRotation;  // call this from willAnimateRotationToInterfaceOrientation:duration:

- (void)didRotate;  // call this from didRotateFromInterfaceOrientation:

@end


@protocol PagingViewLandscapeDelegate <NSObject>

@required

- (NSInteger)numberOfPagesLandscapeInPagingView:(PagingViewLandscape *)pagingView;

- (UIView *)viewForPageLandscapeInPagingView:(PagingViewLandscape *)pagingView atIndex:(NSInteger)index;

@optional

- (void)pagesLandscapeDidChangeInPagingView:(PagingViewLandscape *)pagingView;

// a good place to start and stop background processing
- (void)pagingViewLandscapeWillBeginMoving:(PagingViewLandscape *)pagingView;
- (void)pagingViewLandscapeDidEndMoving:(PagingViewLandscape *)pagingView;

- (void)currentPageLandscapeWillChangeInPagingView:(PagingViewLandscape *)pagingView nextPage:(BOOL)isNext;
- (void)currentPageLandscapeDidChangeInPagingView:(PagingViewLandscape *)pagingView nextPage:(BOOL)isNext;

// For Zoom
- (void)pagingViewLandscapeDidZoom:(PagingViewLandscape*)pagingView withScroll:(UIScrollView*)scroll;
- (UIView*)viewForZoomingInPagingView:(PagingViewLandscape*)pagingView withScroll:(UIScrollView*)scroll;
- (void)pagingViewLandscapeWillBeginZooming:(PagingViewLandscape*)pagingView withScroll:(UIScrollView*)scroll view:(UIView *)view;
- (void)pagingViewLandscapeDidEndZooming:(PagingViewLandscape*)pagingView withScroll:(UIScrollView*)scroll view:(UIView *)view atScale:(float)scale;


@end






@interface UIPageView : UIView

- (id)initWithFrame:(CGRect)frame image:(UIImage*)image;

@property (nonatomic, strong) UIImage *imagePage;
@property (nonatomic, copy) NSString *locationText;
@property (nonatomic, copy) NSString *weatherInfo;

@end




