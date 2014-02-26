/*
 *     Generated by class-dump 3.1.2.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2007 by Steve Nygard.
 */

#import "NSObject.h"

@class NSView;

@interface MouseTracker : NSObject
{
    NSView *_view;
    struct _NSRect _trackingRect;
    int _trackingRectTag;
    BOOL _mouseOver;
    id _delegate;
}

- (id)initWithTrackingRect:(struct _NSRect)fp8 inView:(id)fp24;
- (void)dealloc;
- (void)setDelegate:(id)fp8;
- (struct _NSRect)trackingRect;
- (id)view;
- (BOOL)mouseOver;
- (void)_updateMouseIsOver;
- (void)mouseEntered:(id)fp8;
- (void)mouseExited:(id)fp8;
- (void)mouseMoved:(id)fp8;

@end
