/*
 *     Generated by class-dump 3.1.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2005 by Steve Nygard.
 */

#import "NSObject.h"

@class NSMutableArray;

@interface ToDoSnapshotDifferences : NSObject
{
    NSMutableArray *_adds;
    NSMutableArray *_deletes;
    NSMutableArray *_updates;
    NSMutableArray *_oddities;
}

- (id)init;
- (void)dealloc;
- (void)appendAdd:(id)fp8;
- (void)appendDelete:(id)fp8;
- (void)appendUpdate:(id)fp8;
- (void)appendOddity:(id)fp8;
- (id)adds;
- (id)deletes;
- (id)updates;
- (id)oddities;

@end
