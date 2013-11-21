//
//  NSString+xmlDocPtr.h
//  GiftCard
//
//  Created by iMac02 on 28/9/2012.
//  Copyright (c) 2012 iMac02. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <libxml/tree.h>

#define trimString( object ) [object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

NSString* xmlDocPtr_to_string(xmlDocPtr doc);

@interface NSString (XML)
+(id) stringFromXmlDocPtr:(xmlDocPtr)docXML;
- (id) prettyXMLString;

- (NSString *)stringByTrimming;
- (id) removeSubString:(NSString *) stringRemove;
- (NSString*) stringBetweenString:(NSString*)start andString:(NSString*)end;
- (NSString*) stringByTagXML:(NSString*)tagXML;
- (BOOL) isOnlyNumbers;
- (BOOL) isEmty;
+ (BOOL) isEmtyString:(NSString*)string;
- (NSMutableArray*) componentsByLenght:(NSInteger) lenght;
- (NSString*) insertSubString:(NSString*)sub withLenght:(int) lenght;

@end
