/*
 *     Generated by class-dump 3.0.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004 by Steve Nygard.
 */

#import "NSObject.h"

@interface NSObject (MainThreadMessaging)
- (void)performOnewaySelectorInMainThread:(SEL)fp8 withObject:(id)fp12;
- (void)performOnewaySelectorInMainThread:(SEL)fp8 withObject:(id)fp12 withObject:(id)fp16;
- (void)performSelectorInMainThread:(SEL)fp8;
- (void)performSelectorInMainThread:(SEL)fp8 withObject:(id)fp12;
- (void)performSelectorInMainThread:(SEL)fp8 withObject:(id)fp12 withObject:(id)fp16;
@end
