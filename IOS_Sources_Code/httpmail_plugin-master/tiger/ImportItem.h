/*
 *     Generated by class-dump 3.0.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004 by Steve Nygard.
 */

#import "NSObject.h"

@class NSString;

@interface ImportItem : NSObject
{
    BOOL _isEnabled;
    NSString *_displayName;
    float _progressValue;
    NSString *_fullPath;
    NSString *_relativePath;
    int _itemCount;
    id _identifier;
    int _subfolderCount;
    id _importFields;
}

- (id)displayName;
- (id)fullPath;
- (id)identifier;
- (id)importFields;
- (BOOL)isEnabled;
- (int)itemCount;
- (float)progressValue;
- (id)relativePath;
- (void)setDisplayName:(id)fp8;
- (void)setFullPath:(id)fp8;
- (void)setIdentifier:(id)fp8;
- (void)setImportFields:(id)fp8;
- (void)setIsEnabled:(BOOL)fp8;
- (void)setItemCount:(int)fp8;
- (void)setProgressValue:(float)fp8;
- (void)setRelativePath:(id)fp8;
- (void)setSubfolderCount:(int)fp8;
- (int)subfolderCount;

@end
