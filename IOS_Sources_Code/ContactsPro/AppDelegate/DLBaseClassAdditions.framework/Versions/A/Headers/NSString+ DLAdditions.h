/***********************************************************************
 *	File name:	___________
 *	Project:	DLBaseClassFramework
 *	Description:
 *  Author:		Dat Nguyen Mau
 *  Created:    on 9/4/2013.
 *	Device:		Iphone vs IPad
 *  Company:	__MyCompanyName__
 *  Copyright:	2012 . All rights reserved.
 ***********************************************************************/

#import <Foundation/Foundation.h>

#define DL_Trim_String( object ) [object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

NSString *dl_DocumentPath(void);

@interface NSString (DLString)

+ (NSString*)dl_DocumentPath;

- (id)removeSubString:(NSString *) stringRemove;
- (BOOL)isOnlyNumbers;
- (BOOL)isHexString;
+ (BOOL)isEmtyString:(NSString*)string;
+ (BOOL)isEmtyStringWithTrimWhiteSpace:(NSString*)string;

- (NSString *)MD5Hash;
- (NSString*)SHA1;

- (BOOL)validFolderPath;
- (BOOL)validFilePath;
- (BOOL)validEmailAddress;

// Function with many args
- (NSString*)stringByAppendingStrings:(NSString*)first, ... NS_REQUIRES_NIL_TERMINATION;
- (NSString *)toHexString;
- (NSString *)stringFromHexString;

// for XOR string (^) like PHP
- (NSString *)stringByXorWithString:(NSString *)cipher;
- (NSString *)stringByDecodingFromCipher:(NSString *)cipher;

@end



@interface NSData (DLBase64)
+ (NSData *)dataWithBase64EncodedString:(NSString *)string;
- (NSString *)base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth;
- (NSString *)base64EncodedString;

@end


@interface NSString (DLBase64)

+ (NSString *)stringWithBase64EncodedString:(NSString *)string;
- (NSString *)base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth;
- (NSString *)base64EncodedString;
- (NSString *)base64DecodedString;
- (NSData *)base64DecodedData;

@end





