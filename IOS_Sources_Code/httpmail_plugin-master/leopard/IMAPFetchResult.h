/*
 *     Generated by class-dump 3.1.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2005 by Steve Nygard.
 */

#import "NSObject.h"

@class NSArray, NSData, NSString;

@interface IMAPFetchResult : NSObject
{
    int _itemType;
    union {
        NSArray *envelope;
        NSString *internalDate;
        unsigned int messageSize;
        NSArray *bodyStructure;
        struct {
            NSString *section;
            unsigned int startOffset;
            NSData *sectionData;
        } bodySectionInfo;
        unsigned int uid;
        NSArray *flags;
    } _typeSpecific;
}

- (id)initWithType:(int)fp8;
- (void)dealloc;
- (int)type;
- (BOOL)needsLineEndingConversion;
- (id)envelope;
- (void)setEnvelope:(id)fp8;
- (id)internalDate;
- (void)setInternalDate:(id)fp8;
- (id)fetchData;
- (void)setFetchData:(id)fp8;
- (unsigned long)messageSize;
- (void)setMessageSize:(unsigned long)fp8;
- (id)bodyStructure;
- (void)setBodyStructure:(id)fp8;
- (unsigned long)startOffset;
- (void)setStartOffset:(unsigned long)fp8;
- (id)section;
- (void)setSection:(id)fp8;
- (unsigned long)uid;
- (void)setUid:(unsigned long)fp8;
- (id)flagsArray;
- (void)setFlagsArray:(id)fp8;
- (unsigned long)encoding;
- (unsigned long)messageFlags;
- (id)description;

@end
