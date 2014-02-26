/*
 *     Generated by class-dump 3.1.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2005 by Steve Nygard.
 */

#import "NSObject.h"

@class ActivityAggregator, ColorBackgroundView, ExpandingSplitView, MailVerticalSplitView, NSArray, NSButton, NSMutableArray, NSMutableSet, NSTextField, SplitterAnimation;

@interface ActivityViewController : NSObject
{
    NSTextField *_titleTextField;
    ExpandingSplitView *_splitView;
    ColorBackgroundView *_contentView;
    ColorBackgroundView *_mailActivityView;
    NSButton *_mailActivityViewToggleButton;
    MailVerticalSplitView *_verticalSplitView;
    NSMutableArray *_viewQueue;
    NSMutableSet *_viewsPendingHide;
    NSArray *_activeBackgroundColors;
    NSArray *_inactiveBackgroundColors;
    SplitterAnimation *_splitterAnimation;
    ActivityAggregator *_activityAggregator;
    float _activityViewHeight;
    float _mailActivityViewHeight;
    BOOL _isVisible;
    BOOL _isHidePostponingDisabled;
    BOOL _isViewQueueAnimating;
    BOOL _hasActiveAppearance;
}

- (id)init;
- (void)dealloc;
- (void)unregisterObservedKeyPaths;
- (void)setVerticalSplitView:(id)fp8;
- (void)setSplitterAnimation:(id)fp8;
- (void)setVisible:(BOOL)fp8;
- (void)setVisible:(BOOL)fp8 animate:(BOOL)fp12;
- (void)setViewFrameSize:(id)fp8;
- (void)setViewFrameOrigin:(id)fp8;
- (id)backgroundColorsForContentView;
- (id)backgroundColorForViewQueueIndex:(unsigned int)fp8;
- (void)setHasActiveAppearance:(BOOL)fp8;
- (void)handleWindowKeyOrMainChangeNotification:(id)fp8;
- (void)awakeFromNib;
- (void)configureBackgroundColors;
- (void)configureActivityAggegateViews;
- (void)configureTitleTextField;
- (void)finishAwake;
- (void)toggleDisplay:(id)fp8;
- (void)updateBackgroundColors;
- (void)updateViewsInQueue;
- (void)addViewToQueue:(id)fp8;
- (BOOL)removeViewFromQueue:(id)fp8;
- (void)showView:(id)fp8;
- (void)hideView:(id)fp8;
- (void)popView:(id)fp8;
- (void)hideViews:(id)fp8;
- (void)observeValueForKeyPath:(id)fp8 ofObject:(id)fp12 change:(id)fp16 context:(void *)fp20;
- (void)animationDidEnd:(id)fp8;
- (void)splitView:(id)fp8 resizeSubviewsWithOldSize:(struct _NSSize)fp12;
- (float)splitView:(id)fp8 constrainMinCoordinate:(float)fp12 ofSubviewAt:(int)fp16;
- (void)setSplitViewPercentage:(float)fp8 animate:(BOOL)fp12;
- (void)splitViewDidResizeSubviews:(id)fp8;
- (BOOL)isHidePostponingDisabled;
- (void)setIsHidePostponingDisabled:(BOOL)fp8;
- (id)verticalSplitView;
- (BOOL)isVisible;
- (BOOL)isViewQueueAnimating;
- (void)setIsViewQueueAnimating:(BOOL)fp8;
- (BOOL)hasActiveAppearance;
- (id)inactiveBackgroundColors;
- (void)setInactiveBackgroundColors:(id)fp8;
- (id)activeBackgroundColors;
- (void)setActiveBackgroundColors:(id)fp8;

@end
