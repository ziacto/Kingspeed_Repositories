/*
 *     Generated by class-dump 3.0.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004 by Steve Nygard.
 */

#import "NSString.h"

@interface NSString (NSStringUtils)
+ (id)messageIDStringWithDomainHint:(id)fp8;
+ (id)stringRepresentationForBytes:(long long)fp8;
+ (id)stringWithAttachmentCharacter;
+ (id)stringWithData:(id)fp8 encoding:(unsigned int)fp12;
- (id)MD5Digest;
- (BOOL)boolValue;
- (int)caseInsensitiveCompareExcludingXDash:(id)fp8;
- (int)compareAsInts:(id)fp8;
- (id)componentsSeparatedByPattern:(id)fp8;
- (BOOL)containsOnlyBreakingWhitespace;
- (BOOL)containsOnlyWhitespace;
- (id)createStringByEndTruncatingForWidth:(float)fp8 usingFont:(id)fp12;
- (id)encodedMessageID;
- (id)fileSystemString;
- (id)messageIDSubstring;
- (id)smartCapitalizedString;
- (id)stringByLocalizingReOrFwdPrefix;
- (id)stringByRemovingCharactersInSet:(id)fp8;
- (id)stringByRemovingLineEndingsForHTML;
- (id)stringByReplacingString:(id)fp8 withString:(id)fp12;
- (id)stringWithNoExtraSpaces;
- (unsigned int)subjectPrefixLength;
- (id)uniqueFilenameWithRespectToFilenames:(id)fp8;
@end
