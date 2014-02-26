/*
 *     Generated by class-dump 3.1.2.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2007 by Steve Nygard.
 */

#import "NSAttributedString.h"

@interface NSAttributedString (AtomicAddress)
+ (id)atomicAddressFromDictionary:(id)fp8;
- (BOOL)containsOnlyAtoms;
- (id)unatomicAddress;
- (id)dictionaryRepresentation;
- (id)atomicAddresses;
- (id)allAddresses;
- (id)addressAttachments;
- (id)unatomicAddresses;
- (id)replaceAttachmentsWithAddressesIncludeName:(BOOL)fp8;
- (BOOL)containsAddressAttachments;
- (id)stringWithAtomsExpanded;
- (id)stringOfAddressesWithAtomsExpandedIncludeName:(BOOL)fp8;
- (id)mutableCopyWithNewAttachments:(id *)fp8;
- (struct _NSRange)convertPlainTextRange:(struct _NSRange)fp8;
- (struct _NSRange)convertToPlainTextRange:(struct _NSRange)fp8;
- (void)testSpotlighting;
- (BOOL)knownToHaveNoRecord;
- (id)addressBookRecord;
- (void)displayCommasExceptAtEnd;
- (void)displayCommasForAllAddresses;
@end
