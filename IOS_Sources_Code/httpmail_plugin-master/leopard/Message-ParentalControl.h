/*
 *     Generated by class-dump 3.1.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2005 by Steve Nygard.
 */

#import <Message/Message.h>

@interface Message (ParentalControl)
- (BOOL)isParentResponseMessage:(char *)fp8 isRejected:(char *)fp12 requestedAddresses:(id)fp16 requestIsForSenders:(char *)fp20;
- (BOOL)isChildRequestMessage:(id)fp8 requestIsForSenders:(char *)fp12 childAddress:(id *)fp16 permissionRequestState:(int *)fp20;
- (BOOL)isChildRequestMessage;
@end
