/*
 *     Generated by class-dump 3.1.2.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2007 by Steve Nygard.
 */

#import "NSNotificationCenter.h"

@class NSHashTable;

@interface MailNotificationCenter : NSNotificationCenter
{
    NSHashTable *_nameTable;
}

- (void)addObserver:(id)fp8 selector:(SEL)fp12 name:(id)fp16 object:(id)fp20;
- (void)addObserverInMainThread:(id)fp8 selector:(SEL)fp12 name:(id)fp16 object:(id)fp20;
- (void)postNotification:(id)fp8;
- (void)postNotificationName:(id)fp8 object:(id)fp12 userInfo:(id)fp16;
- (void)_postNotificationWithMangledName:(id)fp8 object:(id)fp12 userInfo:(id)fp16;
- (void)removeSafeObserver:(id)fp8;
- (void)removeObserver:(id)fp8 name:(id)fp12 object:(id)fp16;

@end
