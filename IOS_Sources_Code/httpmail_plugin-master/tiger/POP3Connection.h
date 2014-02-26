/*
 *     Generated by class-dump 3.0.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004 by Steve Nygard.
 */

#import <Message/Connection.h>

@class NSData, NSMutableData;

@interface POP3Connection : Connection
{
    NSMutableData *_sendBuffer;
    struct __CFDictionary *_listResults;
    NSData *_apopTimeStamp;
    id _delegate;
    unsigned int _numberOfMessagesAvailable:24;
    unsigned int _state:4;
    unsigned int _delegateRespondsToReceivedNumberOfBytes:1;
    unsigned int _delegateRespondsToWillRetrieveMessageNumber:1;
    unsigned int _delegateRespondsToDidRetrieveMessageNumber:1;
    unsigned int _hidingPassword:1;
}

- (BOOL)_doBasicConnectionWithAccount:(id)fp8;
- (int)_getListResults;
- (id)_retrieveMessage:(unsigned long)fp8 ofSize:(unsigned int)fp12 informDelegate:(BOOL)fp16;
- (BOOL)authenticateUsingAccount:(id)fp8;
- (BOOL)authenticateUsingAccount:(id)fp8 authenticator:(id)fp12;
- (id)authenticationMechanisms;
- (id)capabilities;
- (BOOL)connectUsingAccount:(id)fp8;
- (void)dealloc;
- (int)dele:(unsigned long)fp8;
- (id)delegate;
- (int)deleteMessagesOnServer:(struct __CFArray *)fp8;
- (void)disableAPOP;
- (int)doStat;
- (int)fetchMessages:(struct __CFArray *)fp8;
- (void)finalize;
- (int)getMessageNumbers:(struct __CFArray **)fp8 andMessageIdsByNumber:(struct __CFDictionary **)fp12;
- (void)getTopOfMessageNumber:(unsigned long)fp8 intoMutableData:(id)fp12;
- (id)idForMessageNumber:(int)fp8;
- (id)init;
- (int)list:(int)fp8;
- (BOOL)messagesAvailable;
- (unsigned int)numberOfMessagesAvailable;
- (int)quit;
- (id)retainedMessageHeaderForMessageNumber:(unsigned long)fp8;
- (int)retr:(unsigned long)fp8;
- (void)setDelegate:(id)fp8;
- (unsigned long)sizeOfMessageNumber:(unsigned long)fp8;
- (BOOL)startTLSForAccount:(id)fp8;
- (BOOL)supportsAPOP;

@end
