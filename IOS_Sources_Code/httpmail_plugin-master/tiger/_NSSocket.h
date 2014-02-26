/*
 *     Generated by class-dump 3.0.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004 by Steve Nygard.
 */

#import "NSObject.h"

@class NSString;

@interface _NSSocket : NSObject
{
    struct __CFReadStream *_readStream;
    struct __CFWriteStream *_writeStream;
    NSString *_protocol;
    void *_stats;
    void *_request;
    unsigned int _numTimeoutSecs:16;
    unsigned int _openCompleted:1;
    unsigned int _canRead:1;
    unsigned int _canWrite:1;
    unsigned int _error:1;
    unsigned int _closed:1;
    unsigned int _ignoreCerts:1;
    float _lastReadTime;
}

+ (void)_runIOThread;
+ (void)handlePortMessage:(id)fp8;
+ (void)initialize;
+ (void)setSimulatedSocketSpeed:(int)fp8;
+ (int)simulatedSocketSpeed;
- (void)abort;
- (BOOL)connectToHost:(id)fp8 withPort:(unsigned int)fp12 protocol:(id)fp16;
- (void)dealloc;
- (int)fileDescriptor;
- (void)finalize;
- (id)init;
- (id)initWithTimeout:(int)fp8;
- (BOOL)isReadable;
- (BOOL)isValid;
- (BOOL)isWritable;
- (float)lastReadTime;
- (int)readBytes:(char *)fp8 length:(int)fp12;
- (id)remoteHostname;
- (unsigned int)remotePortNumber;
- (id)securityProtocol;
- (id)serverCertificates;
- (void)setIgnoreSSLCertificates:(BOOL)fp8;
- (BOOL)setSecurityProtocol:(id)fp8;
- (void)setTimeout:(int)fp8;
- (id)sourceIPAddress;
- (int)timeout;
- (int)writeBytes:(const char *)fp8 length:(int)fp12;

@end
