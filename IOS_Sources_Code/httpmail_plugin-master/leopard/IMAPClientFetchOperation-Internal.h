/*
 *     Generated by class-dump 3.1.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2005 by Steve Nygard.
 */

#import <Message/IMAPClientFetchOperation.h>

@interface IMAPClientFetchOperation (Internal)
+ (id)_headersToFetch;
+ (id)_fetchDataItemsForMessageSkeletonsWithHeaders:(id)fp8;
- (id)_createMessageSetCommandString;
- (id)_fetchDataItemsForMessageSkeletonsWithAdditionalHeaderFields:(id)fp8;
@end
