/*
 *     Generated by class-dump 3.0.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004 by Steve Nygard.
 */

#import "NSObject.h"

@class NSMutableDictionary, NSString;

@interface UsageCounter : NSObject
{
    NSString *_name;
    NSMutableDictionary *_counts;
    BOOL _isDirty;
}

+ (BOOL)gatherJunkMailUsageCounts;
+ (void)setGatherJunkMailUsageCounts:(BOOL)fp8;
+ (id)sharedInstance;
- (id)_dictionaryForKey:(id)fp8 createIfNeeded:(BOOL)fp12;
- (unsigned int)countForKey:(id)fp8;
- (unsigned int)countForKey:(id)fp8 includeToday:(BOOL)fp12;
- (void)dealloc;
- (void)finalize;
- (void)incrementCountForKey:(id)fp8;
- (void)incrementCountForKey:(id)fp8 byCount:(int)fp12;
- (id)initWithName:(id)fp8;
- (unsigned int)numberOfDaysAvailableForKey:(id)fp8;
- (void)removeCountForKey:(id)fp8;
- (void)saveDefaults;

@end
