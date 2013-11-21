//
//  NSString+xmlDocPtr.m
//  GiftCard
//
//  Created by iMac02 on 28/9/2012.
//  Copyright (c) 2012 iMac02. All rights reserved.
//

#import "NSString+Extentions.h"
#import "RegexKitLite.h"

NSString* xmlDocPtr_to_string(xmlDocPtr doc)
{
    NSString *outStr = nil;
    xmlChar *s;
    int size;
    xmlDocDumpMemory(doc, &s, &size);
    if (s != NULL) outStr = [NSString stringWithUTF8String:(const char *)s];
    xmlFree(s);
    return outStr;
}

@implementation NSString (XML)

+(id) stringFromXmlDocPtr:(xmlDocPtr)docXML
{
    NSString *outStr = nil;
    xmlChar *s;
    int size;
    xmlDocDumpMemory(docXML, &s, &size);
    if (s != NULL) outStr = [NSString stringWithUTF8String:(const char *)s];
    xmlFree(s);
    return outStr;
}

- (id) prettyXMLString
{
    const char *utf8Str = [self UTF8String];
    // NOTE: We are assuming a string length that fits into an int
    xmlDocPtr doc = xmlReadMemory(utf8Str, (int)strlen(utf8Str), NULL, // URL
                                  NULL, // encoding
                                  (XML_PARSE_NOCDATA | XML_PARSE_NOBLANKS));
    
    xmlNodePtr xmlNode_ = NULL;
    if (doc != NULL) {
        // copy the root node from the doc
        xmlNodePtr root = xmlDocGetRootElement(doc);
        if (root) {
            xmlNode_ = xmlCopyNode(root, 1); // 1: recursive
        }
        xmlFreeDoc(doc);
    }
    
    
    NSString *_prettyXMLString = @"";
    //------------
    if (xmlNode_ != NULL) {
        NSString *str = nil;
        xmlBufferPtr buff = xmlBufferCreate();
        if (buff) {
            
            xmlDocPtr doc = NULL;
            int level = 0;
            // enable formatting (pretty print / beautifier)
            int format = 1;
            
            int result = xmlNodeDump(buff, doc, xmlNode_, level, format);
            
            if (result > -1) {
                str = [[NSString alloc] initWithBytes:(xmlBufferContent(buff))
                                               length:(xmlBufferLength(buff))
                                             encoding:NSUTF8StringEncoding];
            }
            xmlBufferFree(buff);
        }
        
        // remove leading and trailing whitespace
        NSCharacterSet *ws = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *trimmed = [str stringByTrimmingCharactersInSet:ws];
        _prettyXMLString = [trimmed copy];
    }
    else {
        _prettyXMLString = [self copy];
    }
    
    return _prettyXMLString;
}

- (NSString *)stringByTrimming
{
	NSMutableString *mStr = [self mutableCopy];
	CFStringTrimWhitespace((__bridge CFMutableStringRef)mStr);
	
	NSString *result = [mStr copy];
	
	return result;
}

- (id) removeSubString:(NSString *) stringRemove
{
    if (!self || self.length < stringRemove.length) return self;
    
    return [self stringByReplacingOccurrencesOfString:stringRemove withString:@""];
}

//- (NSString*) stringBetweenString:(NSString*)start andString:(NSString*)end
//{
//    NSScanner* scanner = [NSScanner scannerWithString:self];
//    [scanner setCharactersToBeSkipped:nil];
//    [scanner scanUpToString:start intoString:NULL];
//    if ([scanner scanString:start intoString:NULL]) {
//        NSString* result = nil;
//        if ([scanner scanUpToString:end intoString:&result]) {
//            return result;
//        }
//    }
//    return nil;
//}

- (NSString*) stringBetweenString:(NSString *)start andString:(NSString *)end
{
    NSString* regExp = [NSString stringWithFormat:@"(?<=%@)[^,]*(?=%@)",start,end]; //@"(?<=_dlc_DocIdUrl:SW\|)[^,]*(?=,)";
    return [self stringByMatching:regExp];
}

- (NSString*) stringByTagXML:(NSString*)tagXML
{
    NSString *start = [@"<" stringByAppendingFormat:@"%@>",tagXML];
    NSString *end = [@"</" stringByAppendingFormat:@"%@>",tagXML];
    return [self stringBetweenString:start andString:end];
}

- (BOOL) isOnlyNumbers
{
    BOOL valid;
    NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:self];
    valid = [alphaNums isSupersetOfSet:inStringSet];
    return valid;
}

- (BOOL) isEmty
{
    NSString *str = trimString(self);
    return [str isEqualToString:@""];
}

+ (BOOL) isEmtyString:(NSString*)string
{
    if (!string) return YES;
    return [string isEmty];
}

- (NSMutableArray*) componentsByLenght:(NSInteger) lenght
{
    if (!self) return nil;
    if (lenght >= self.length) return [NSMutableArray arrayWithObject:self];
    
    int count = 1;
    if ((self.length % lenght) == 0) {
        count = self.length / lenght;
    }
    else count = self.length / lenght + 1;
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (int i = 0; i < count; i++) {
        if (i * lenght + lenght < self.length) {
            NSRange range = NSMakeRange(i*lenght, lenght);
            [arr addObject:[self substringWithRange:range]];
        }
        else {
            [arr addObject:[self substringFromIndex:(i*lenght)]];
        }
    }
    
    return arr;
}

- (NSString*) insertSubString:(NSString*)sub withLenght:(int) lenght
{
    NSMutableArray *arr = [self componentsByLenght:lenght];
    if (!arr || arr.count == 1) return self;
    NSString *result = @"";
    for (int i = 0; i < arr.count; i++) {
        if (i == 0) {
            result = [result stringByAppendingFormat:@"%@",[arr objectAtIndex:i]];
        }
        else {
            result = [result stringByAppendingFormat:@"-%@",[arr objectAtIndex:i]];
        }
    }
    
    return result;
}

@end
