/*
 *     Generated by class-dump 3.1.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2005 by Steve Nygard.
 */

#import <Message/ConcurrentOperation.h>

@class NSInvocation;

@interface InvocationOperation : ConcurrentOperation
{
    NSInvocation *invocation;
}

+ (id)operationWithInvocation:(id)fp8;
- (id)initWithInvocation:(id)fp8;
- (void)dealloc;
- (BOOL)isConcurrent;
- (BOOL)performOnMainThread;
- (void)setPerformOnMainThread:(BOOL)fp8;
- (BOOL)performOnBackgroundThread;
- (void)setPerformOnBackgroundThread:(BOOL)fp8;
- (BOOL)manuallyMarkCompletion;
- (void)setManuallyMarkCompletion:(BOOL)fp8;
- (id)description;
- (void)start;
- (void)main;
- (id)invocation;
- (void)setInvocation:(id)fp8;

@end
