/*
 *     Generated by class-dump 3.1.2.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2007 by Steve Nygard.
 */

#import "NSObject.h"

@class ImportAssistant, NSArray, NSMutableArray, NSString;

@interface Importer : NSObject
{
    ImportAssistant *_delegate;
    NSMutableArray *_importArray;
    NSString *_applicationString;
    NSArray *_importFields;
    BOOL _importCanceled;
}

+ (id)explanatoryText;
+ (id)name;
- (id)init;
- (id)name;
- (void)setDelegate:(id)fp8;
- (id)delegate;
- (id)importArray;
- (void)clearImportArray;
- (id)importArrayEnumerator;
- (void)addItemToImportArray:(id)fp8;
- (int)countOfEnabledItems;
- (BOOL)importCanceled;
- (void)setImportCanceled:(BOOL)fp8;
- (id)importFields;
- (void)setImportFields:(id)fp8;
- (void)sortArray:(id)fp8;
- (id)statusLine;
- (id)importFinishedText;
- (id)creatorCode;
- (void)cleanup;
- (id)prepareForImport;
- (void)performImport;
- (void)importFinished;
- (void)_runApplescript:(id)fp8 andReturnArray:(id)fp12;
- (id)runApplescript:(id)fp8;
- (id)arrayFromDescriptor:(id)fp8;
- (BOOL)setApplicationString;
- (void)dealloc;

@end
