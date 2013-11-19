/***********************************************************************
 *	File name:	_______________.h
 *	Project:	Location Camera
 *	Description:
 *  Author:		Dat Nguyen Mau
 *  Created:    on 18/02/2013.
 *	Device:		Iphone vs IPad
 *  Company:	__MyCompanyName__
 *  Copyright:	2012 . All rights reserved.
 ***********************************************************************/

#import "UIDevice+additions.h"

@implementation UIDevice (additions)
+ (float)iosVersion
{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}
- (void) recallDeviceOrientationWithOrientation:(UIInterfaceOrientation)interfaceOrientation
{
//    SEL theSelector = NSSelectorFromString(@"setOrientation:");
//    NSInvocation *anInvocation = [NSInvocation invocationWithMethodSignature: [self methodSignatureForSelector:theSelector]];
//    
//    [anInvocation setSelector:theSelector];
//    [anInvocation setTarget:self];
//    [anInvocation setArgument:&interfaceOrientation atIndex:2];
//    
//    [anInvocation invoke];
    
//    NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:sel]];
//    [inv setSelector:sel];
//    [inv setTarget:self];
//    [inv setArgument:&i atIndex:2]; //arguments 0 and 1 are self and _cmd respectively, automatically set by NSInvocation
//    [inv setArgument:&bol atIndex:3];
//    [inv setArgument:&str atIndex:4];
//    [inv invoke];
    
    [self performSelector:NSSelectorFromString(@"setOrientation:") withObject:(id)interfaceOrientation];
}

+ (BOOL)isIphone5OrLater
{
    return [[UIScreen mainScreen] bounds].size.height >= 568. ? YES : NO;
}

@end
