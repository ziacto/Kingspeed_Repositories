/*
 *     Generated by class-dump 3.1.2.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2007 by Steve Nygard.
 */

#import "NSAnimation.h"

@class DOMCSSStyleDeclaration, NSString;

@interface DOMCSSStylePropertyAnimation : NSAnimation
{
    NSString *_property;
    float _startValue;
    float _endValue;
    DOMCSSStyleDeclaration *_style;
}

- (id)initWithDuration:(double)fp8 animationCurve:(unsigned int)fp16 element:(id)fp20 property:(id)fp24;
- (void)dealloc;
- (BOOL)isIncreasing;
- (void)reset;
- (void)reverse;
- (void)setCurrentProgress:(float)fp8;
- (id)style;
- (void)setStyle:(id)fp8;
- (float)startValue;
- (void)setStartValue:(float)fp8;
- (float)endValue;
- (void)setEndValue:(float)fp8;
- (id)property;
- (void)setProperty:(id)fp8;

@end
