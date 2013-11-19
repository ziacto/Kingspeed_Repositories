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

#import "PagingViewLandscape.h"


@interface PagingViewLandscape () <UIScrollViewDelegate>

- (void)configurePages;
- (void)configurePage:(UIView *)page forIndex:(NSInteger)index;

- (CGRect)frameForScrollView;
- (CGRect)frameForPageAtIndex:(NSUInteger)index;

- (void)recyclePage:(UIView *)page;

- (void)knownToBeMoving;
- (void)knownToBeIdle;

@end



@implementation PagingViewLandscape

@synthesize delegate=_delegate;
@synthesize gapBetweenPages=_gapBetweenPages;
@synthesize pagesToPreload=_pagesToPreload;
@synthesize pageCount=_pageCount;
@synthesize currentPageIndex=_currentPageIndex;
@synthesize moving=_scrollViewIsMoving;
@synthesize previousPageIndex=_previousPageIndex;
@synthesize recyclingEnabled=_recyclingEnabled;
@synthesize horizontal=_horizontal;


#pragma mark -
#pragma mark init/dealloc

- (void)commonInit {
    _visiblePages = [[NSMutableSet alloc] init];
    _recycledPages = [[NSMutableSet alloc] init];
    _currentPageIndex = 0;
    _gapBetweenPages = 20.0;
    _pagesToPreload = 1;
    _recyclingEnabled = YES;
    _firstLoadedPageIndex = _lastLoadedPageIndex = -1;
    _horizontal = YES;

    // We are using an oversized UIScrollView to implement interpage gaps,
    // and we need it to clipped on the sides. This is important when
    // someone uses ATPagingView in a non-fullscreen layout.
    self.clipsToBounds = YES;

    _scrollView = [[UIScrollView alloc] initWithFrame:[self frameForScrollView]];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleRightMargin;
    _scrollView.pagingEnabled = YES;
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.bounces = YES;
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
    
    [self setBackgroundColor:[UIColor clearColor]];
    
    /***************************************/
//    CGRect rect = [self frameForScrollView];
//    rect.origin.x = 0;
//    rect.origin.y = 0;
//    _imgBackground = [[UIImageView alloc] initWithFrame:rect];
//    _imgBackground.image  = [UIImage imageNamed:@"bg_day.png"];
//    
//    _imgBackground.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin |
//    UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
//    [_scrollView addSubview:_imgBackground];
    /***************************************/
    
    _isFinishChange = YES;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self commonInit];
    }
    return self;
}

#pragma mark Properties

- (void)setGapBetweenPages:(CGFloat)value {
    _gapBetweenPages = value;
    [self setNeedsLayout];
}

- (void)setPagesToPreload:(NSInteger)value {
    BOOL reconfigure = _pagesToPreload != value;
    _pagesToPreload = value;
    if (reconfigure) {
        [self configurePages];
    }
}

-(void)setHorizontal:(BOOL)value {
    BOOL reconfigure = _horizontal != value;
    _horizontal = value;
    if (reconfigure) {
        [self layoutIfNeeded]; // force call to layoutSubview to set _scrollView.frame
        [self configurePages];
    }
}

#pragma mark -
#pragma mark Data

- (void)reloadData {
    _pageCount = [_delegate numberOfPagesLandscapeInPagingView:self];

    // recycle all pages
    for (UIView *view in _visiblePages) {
        [self recyclePage:view];
    }
    [_visiblePages removeAllObjects];

    [self configurePages];
}


#pragma mark -
#pragma mark Page Views

- (UIView *)viewForPageAtIndex:(NSUInteger)index {
    for (UIView *page in _visiblePages)
        if (page.tag == index)
            return page;
    return nil;
}

- (UIView *)currentPageView
{
    return [self viewForPageAtIndex:_currentPageIndex];
}

- (void)configurePages {
    if (_horizontal && (_scrollView.frame.size.height <= _gapBetweenPages + 1e-6)) {
        return;  // not our time yet
    } else if (_scrollView.frame.size.width <= _gapBetweenPages + 1e-6) {
        return;  // not our time yet
    }
    if (_pageCount == 0 && _currentPageIndex > 0)
        return;  // still not our time

    // normally layoutSubviews won't even call us, but protect against any other calls too (e.g. if someones does reloadPages)
    if (_rotationInProgress)
        return;

    // to avoid hiccups while scrolling, do not preload invisible pages temporarily
    BOOL quickMode = (_scrollViewIsMoving && _pagesToPreload > 0);

    CGSize contentSize;
    if (_horizontal) {
        contentSize = CGSizeMake(_scrollView.frame.size.width * _pageCount, _scrollView.frame.size.height);
    } else {
        contentSize = CGSizeMake(_scrollView.frame.size.width, _scrollView.frame.size.height * _pageCount);
    }
    
    if (!CGSizeEqualToSize(_scrollView.contentSize, contentSize)) {
#ifdef AT_PAGING_VIEW_TRACE_LAYOUT
        NSLog(@"configurePages: _scrollView.frame == %@, setting _scrollView.contentSize = %@",
              NSStringFromCGRect(_scrollView.frame), NSStringFromCGSize(contentSize));
#endif
        _scrollView.contentSize = contentSize;
        if (_horizontal) {
            _scrollView.contentOffset = CGPointMake(_scrollView.frame.size.width * _currentPageIndex, 0);
        } else {
            _scrollView.contentOffset = CGPointMake(0, _scrollView.frame.size.height * _currentPageIndex);
        }
    } else {
#ifdef AT_PAGING_VIEW_TRACE_LAYOUT
        NSLog(@"configurePages: _scrollView.frame == %@", NSStringFromCGRect(_scrollView.frame));
#endif
    }

    CGRect visibleBounds = _scrollView.bounds;
    NSInteger newPageIndex;
    if (_horizontal) {
        newPageIndex = MIN(MAX(floorf(CGRectGetMidX(visibleBounds) / CGRectGetWidth(visibleBounds)), 0), _pageCount - 1);
    } else {
        newPageIndex = MIN(MAX(floorf(CGRectGetMidY(visibleBounds) / CGRectGetHeight(visibleBounds)), 0), _pageCount - 1);
    }
#ifdef AT_PAGING_VIEW_TRACE_LAYOUT
    NSLog(@"newPageIndex == %d", newPageIndex);
#endif

    newPageIndex = MAX(0, MIN(_pageCount, newPageIndex));

    // calculate which pages are visible
    int firstVisiblePage = self.firstVisiblePageIndex;
    int lastVisiblePage  = self.lastVisiblePageIndex;
    int firstPage = MAX(0,            MIN(firstVisiblePage, newPageIndex - _pagesToPreload));
    int lastPage  = MIN(_pageCount-1, MAX(lastVisiblePage,  newPageIndex + _pagesToPreload));

    // recycle no longer visible pages
    NSMutableSet *pagesToRemove = [NSMutableSet set];
    for (UIView *page in _visiblePages) {
        if (page.tag < firstPage || page.tag > lastPage) {
            [self recyclePage:page];
            [pagesToRemove addObject:page];
        }
    }
    [_visiblePages minusSet:pagesToRemove];

    // add missing pages
    for (int index = firstPage; index <= lastPage; index++) {
        if ([self viewForPageAtIndex:index] == nil) {
            // only preload visible pages in quick mode
            if (quickMode && (index < firstVisiblePage || index > lastVisiblePage))
                continue;
            UIView *page = [_delegate viewForPageLandscapeInPagingView:self atIndex:index];
            [self configurePage:page forIndex:index];
            [_scrollView addSubview:page];
            [_visiblePages addObject:page];
        }
    }

    // update loaded pages info
    BOOL loadedPagesChanged;
    if (quickMode) {
        // Delay the notification until we actually load all the promised pages.
        // Also don't update _firstLoadedPageIndex and _lastLoadedPageIndex, so
        // that the next time we are called with quickMode==NO, we know that a
        // notification is still needed.
        loadedPagesChanged = NO;
    } else {
        loadedPagesChanged = (_firstLoadedPageIndex != firstPage || _lastLoadedPageIndex != lastPage);
        if (loadedPagesChanged) {
            _firstLoadedPageIndex = firstPage;
            _lastLoadedPageIndex  = lastPage;
#ifdef AT_PAGING_VIEW_TRACE_DELEGATE_CALLS
            NSLog(@"loadedPagesChanged: first == %d, last == %d", _firstLoadedPageIndex, _lastLoadedPageIndex);
#endif
        }
    }

    // update current page index
    BOOL pageIndexChanged = (newPageIndex != _currentPageIndex);
    if (pageIndexChanged) {
        _previousPageIndex = _currentPageIndex;
        _currentPageIndex = newPageIndex;
        if (_delegate && [_delegate respondsToSelector:@selector(currentPageLandscapeWillChangeInPagingView:nextPage:)] && _isFinishChange) {
            _isFinishChange = NO;
            [_delegate currentPageLandscapeWillChangeInPagingView:self nextPage:(_previousPageIndex < _currentPageIndex ? YES:NO)];
        }
#ifdef AT_PAGING_VIEW_TRACE_DELEGATE_CALLS
        NSLog(@"_currentPageIndex == %d", _currentPageIndex);
#endif
    }

    if (loadedPagesChanged || pageIndexChanged) {
        if ([_delegate respondsToSelector:@selector(pagesLandscapeDidChangeInPagingView:)]) {
#ifdef AT_PAGING_VIEW_TRACE_DELEGATE_CALLS
            NSLog(@"pagesDidChangeInPagingView");
#endif
            [_delegate pagesLandscapeDidChangeInPagingView:self];
        }
    }
}

- (void)configurePage:(UIView *)page forIndex:(NSInteger)index {
    page.tag = index;
    page.frame = [self frameForPageAtIndex:index];
    [page setNeedsDisplay]; // just in case
}


#pragma mark -
#pragma mark Rotation

// Why do we even have to handle rotation separately, instead of just sticking
// more magic inside layoutSubviews?
//
// This is how I've been doing rotatable paged screens since long ago.
// However, since layoutSubviews is more or less an equivalent of
// willAnimateRotation, and since there is probably a way to catch didRotate,
// maybe we can get rid of this special case.
//
// Just needs more work.

- (void)willAnimateRotation {
    _rotationInProgress = YES;

    // recycle non-current pages, otherwise they might show up during the rotation
    NSMutableSet *pagesToRemove = [NSMutableSet set];
    for (UIView *view in _visiblePages)
        if (view.tag != _currentPageIndex) {
            [self recyclePage:view];
            [pagesToRemove addObject:view];
        }
    [_visiblePages minusSet:pagesToRemove];

    // We're inside an animation block, this has two consequences:
    //
    // 1) we need to resize the page view now (so that the size change is animated);
    //
    // 2) we cannot update the scroll view's contentOffset to align it with the new
    // page boundaries (since any such change will be animated in very funny ways).
    //
    // (Note that the scroll view has already been resized by now.)
    //
    // So we set the new size, but keep the old position here.
    CGSize pageSize = _scrollView.frame.size;
    if (_horizontal) {
        [self viewForPageAtIndex:_currentPageIndex].frame = CGRectMake(_scrollView.contentOffset.x + _gapBetweenPages/2, 0, pageSize.width - _gapBetweenPages, pageSize.height);
    } else {
        [self viewForPageAtIndex:_currentPageIndex].frame = CGRectMake(0, _scrollView.contentOffset.y + _gapBetweenPages/2, pageSize.width, pageSize.height - _gapBetweenPages);
    }
}

- (void)didRotate {
    // Adjust frames according to the new page size - this does not cause any visible
    // changes, because we move the pages and adjust contentOffset simultaneously.
    for (UIView *view in _visiblePages)
        [self configurePage:view forIndex:view.tag];

    if (_horizontal) {
        _scrollView.contentOffset = CGPointMake(_currentPageIndex * _scrollView.frame.size.width, 0);
    } else {
        _scrollView.contentOffset = CGPointMake(0, _currentPageIndex * _scrollView.frame.size.height);
    }

    _rotationInProgress = NO;

    [self configurePages];
}


#pragma mark -
#pragma mark Page navigation

- (void)setCurrentPageIndex:(NSInteger)newPageIndex {
#ifdef AT_PAGING_VIEW_TRACE_LAYOUT
    NSLog(@"setCurrentPageIndex(%d): _scrollView.frame == %@", newPageIndex, NSStringFromCGRect(_scrollView.frame));
#endif
    if (_horizontal && (_scrollView.frame.size.width > 0 && fabsf(_scrollView.frame.origin.x - (-_gapBetweenPages/2)) < 1e-6) ) {
        _scrollView.contentOffset = CGPointMake(_scrollView.frame.size.width * newPageIndex, 0);
    } else if (_scrollView.frame.size.height > 0 && fabsf(_scrollView.frame.origin.y - (-_gapBetweenPages/2)) < 1e-6) {
        _scrollView.contentOffset = CGPointMake(0, _scrollView.frame.size.height * newPageIndex);
    }
    _currentPageIndex = newPageIndex;
}


#pragma mark -
#pragma mark Layouting

- (void)layoutSubviews {
    if (_rotationInProgress)
        return;

    CGRect oldFrame = _scrollView.frame;
    CGRect newFrame = [self frameForScrollView];
    if (!CGRectEqualToRect(oldFrame, newFrame)) {
        // Strangely enough, if we do this assignment every time without the above
        // check, bouncing will behave incorrectly.
        _scrollView.frame = newFrame;
    }
    
//    CGRect rectBg = newFrame; rectBg.origin.y = 0; rectBg.origin.x = 0;
//    _imgBackground.frame = rectBg;

    if (_horizontal) {
        if (oldFrame.size.width != 0 && _scrollView.frame.size.width != oldFrame.size.width) {
            // rotation is in progress, don't do any adjustments just yet
        } else if (oldFrame.size.height != _scrollView.frame.size.height) {
            // some other height change (the initial change from 0 to some specific size,
            // or maybe an in-call status bar has appeared or disappeared)
            [self configurePages];
        }
    } else {
        if (oldFrame.size.height != 0 && _scrollView.frame.size.height != oldFrame.size.height) {
            // rotation is in progress, don't do any adjustments just yet
        } else if (oldFrame.size.width != _scrollView.frame.size.width) {
            // some other width change ?
            [self configurePages];
        }
    }
}

- (NSInteger)firstVisiblePageIndex {
    CGRect visibleBounds = _scrollView.bounds;
    if (_horizontal) {
        return MAX(floorf(CGRectGetMinX(visibleBounds) / CGRectGetWidth(visibleBounds)), 0);
    } else {
        return MAX(floorf(CGRectGetMinY(visibleBounds) / CGRectGetHeight(visibleBounds)), 0);
    }
}

- (NSInteger)lastVisiblePageIndex {
    CGRect visibleBounds = _scrollView.bounds;
    if (_horizontal) {
        return MIN(floorf((CGRectGetMaxX(visibleBounds)-1) / CGRectGetWidth(visibleBounds)), _pageCount - 1);
    } else {
        return MIN(floorf((CGRectGetMaxY(visibleBounds)-1) / CGRectGetHeight(visibleBounds)), _pageCount - 1);
    }
}

- (NSInteger)firstLoadedPageIndex {
    return _firstLoadedPageIndex;
}

- (NSInteger)lastLoadedPageIndex {
    return _lastLoadedPageIndex;
}

- (CGRect)frameForScrollView {
    CGSize size = self.bounds.size;
    if (_horizontal) {
        return CGRectMake(-_gapBetweenPages/2, 0, size.width + _gapBetweenPages, size.height);
    } else {
        return CGRectMake(0, -_gapBetweenPages/2, size.width, size.height + _gapBetweenPages);
    }
}

// not public because this is in scroll view coordinates
- (CGRect)frameForPageAtIndex:(NSUInteger)index {
    CGFloat pageWidthWithGap = _scrollView.frame.size.width;
    CGFloat pageHeightWithGap = _scrollView.frame.size.height;
    CGSize pageSize = self.bounds.size;

    if (_horizontal) {
        return CGRectMake(pageWidthWithGap * index + _gapBetweenPages/2, 0, pageSize.width, pageSize.height);
    } else {
        return CGRectMake(0, pageHeightWithGap * index + _gapBetweenPages/2, pageSize.width, pageSize.height);
    }
}


#pragma mark -
#pragma mark Recycling

// It's the caller's responsibility to remove this page from _visiblePages,
// since this method is often called while traversing _visiblePages array.
- (void)recyclePage:(UIView *)page {
    if ([page respondsToSelector:@selector(prepareForReuse)]) {
        [(id)page prepareForReuse];
    }
    if (_recyclingEnabled) {
        [_recycledPages addObject:page];
    } else {
#ifdef AT_PAGING_VIEW_TRACE_PAGE_LIFECYCLE
        NSLog(@"Releasing page %d because recycling is disabled", page.tag);
#endif
    }
    [page removeFromSuperview];
}

- (UIView *)dequeueReusablePage {
    UIView *result = [_recycledPages anyObject];
    if (result) {
        [_recycledPages removeObject:result];
    }
    return result;
}


#pragma mark -
#pragma mark UIScrollViewDelegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_rotationInProgress)
        return;
    [self configurePages];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self knownToBeMoving];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self knownToBeIdle];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self knownToBeIdle];
}


#pragma mark -
#pragma mark Busy/Idle tracking

- (void)knownToBeMoving {
    if (!_scrollViewIsMoving) {
        _scrollViewIsMoving = YES;
        
        _oldPageIndex = _currentPageIndex;
        
        if ([_delegate respondsToSelector:@selector(pagingViewLandscapeWillBeginMoving:)]) {
            [_delegate pagingViewLandscapeWillBeginMoving:self];
        }
    }
}

- (void)knownToBeIdle {
    if (_scrollViewIsMoving) {
        _scrollViewIsMoving = NO;

        if (_pagesToPreload > 0) {
            // we didn't preload invisible pages during scrolling, so now is the time
            [self configurePages];
        }

        if ([_delegate respondsToSelector:@selector(pagingViewLandscapeDidEndMoving:)]) {
            [_delegate pagingViewLandscapeDidEndMoving:self];
        }
        
        if (_oldPageIndex != _currentPageIndex) {
            if (_delegate && [_delegate respondsToSelector:@selector(currentPageLandscapeDidChangeInPagingView:nextPage:)]) {
                [_delegate currentPageLandscapeDidChangeInPagingView:self nextPage:(_oldPageIndex < _currentPageIndex ? YES:NO)];
            }
        }
        
        _isFinishChange = YES;
    }
}


/*************************************************************************************/
/*************************************************************************************/
//              For Zooming
/*************************************************************************************/
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    if (_delegate && [_delegate respondsToSelector:@selector(pagingViewLandscapeDidZoom:withScroll:)]) {
        [_delegate pagingViewLandscapeDidZoom:self withScroll:scrollView];
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if (_delegate && [_delegate respondsToSelector:@selector(viewForZoomingInPagingView:withScroll:)]) {
        return [_delegate viewForZoomingInPagingView:self withScroll:scrollView];
    }
    return nil;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
    if (_delegate && [_delegate respondsToSelector:@selector(pagingViewLandscapeWillBeginZooming:withScroll:view:)]) {
        [_delegate pagingViewLandscapeWillBeginZooming:self withScroll:scrollView view:view];
    }
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
    if (_delegate && [_delegate respondsToSelector:@selector(pagingViewLandscapeDidEndZooming:withScroll:view:atScale:)]) {
        [_delegate pagingViewLandscapeDidEndZooming:self withScroll:scrollView view:view atScale:scale];
    }
}

@end




@interface UIPageView ()
{
    UIImageView *_imageView;
    UILabel *_lblLocation;
    UILabel *_lblWeather;
}
@end

@implementation UIPageView

- (id)initWithFrame:(CGRect)frame image:(UIImage*)image
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:_imageView];
        [self setBackgroundColor:[UIColor clearColor]];
        _imageView.image = image;
        
        CGRect rect = _imageView.frame;
        if (image.size.width > 320.) {
            rect.size = CGSizeMake(image.size.width/2., image.size.height/2.);
        }
        else {
            rect.size = image.size;
        }
        
        rect.origin.y = frame.size.height - rect.size.height;
        _imageView.frame = rect;
        
        _lblLocation = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 50)];
        _lblLocation.textColor = [UIColor whiteColor];
        _lblLocation.backgroundColor = [UIColor clearColor];
        _lblLocation.font = [UIFont boldSystemFontOfSize:40];
        _lblLocation.textAlignment = UITextAlignmentCenter;
        
        [self addSubview:_lblLocation];
        
        _lblWeather = [[UILabel alloc] initWithFrame:CGRectMake(20, frame.size.height - 50, frame.size.width - 20, 60)];
        _lblWeather.textColor = [UIColor whiteColor];
        _lblWeather.backgroundColor = [UIColor clearColor];
        _lblWeather.font = [UIFont boldSystemFontOfSize:15];
        _lblWeather.textAlignment = UITextAlignmentLeft;
        _lblWeather.numberOfLines = 2;
        
        [self addSubview:_lblWeather];
    }
    
    return self;
}

- (UIImage*)imagePage
{
    return _imageView.image;
}

- (void)setImagePage:(UIImage *)imagePage__
{
    _imageView.image = imagePage__;
    
    CGRect rect = _imageView.frame;
    if (imagePage__.size.width > 320.) {
        rect.size = CGSizeMake(imagePage__.size.width/2., imagePage__.size.height/2.);
    }
    else {
        rect.size = imagePage__.size;
    }
    
    rect.origin.y = self.frame.size.height - rect.size.height;
    _imageView.frame = rect;
}

- (NSString*)locationText
{
    return _lblLocation.text;
}
- (void)setLocationText:(NSString *)locationText__
{
    _lblLocation.text = locationText__;
}

- (NSString*)weatherInfo
{
    return _lblWeather.text;
}
- (void)setWeatherInfo:(NSString *)weatherInfo__
{
    _lblWeather.text = weatherInfo__;
}

@end

