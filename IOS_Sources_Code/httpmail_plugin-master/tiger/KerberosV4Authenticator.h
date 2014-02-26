/*
 *     Generated by class-dump 3.0.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004 by Steve Nygard.
 */

#import <Message/SASLAuthenticator.h>

#import "SASLSecurityLayerProtocol.h"

@interface KerberosV4Authenticator : SASLAuthenticator <SASLSecurityLayer>
{
    struct KClientSessionOpaque *_session;
    struct KClientPrincipalOpaque *_serverPrincipal;
    unsigned int _checksum;
    unsigned int _securityLevel:4;
    unsigned int _maxCipherBufferSize:24;
}

+ (id)allocWithZone:(struct _NSZone *)fp8;
- (id)createDecryptedDataForBytes:(const char *)fp8 length:(unsigned int)fp12;
- (id)createEncryptedDataForBytes:(const char *)fp8 length:(unsigned int)fp12;
- (void)dealloc;
- (unsigned int)encryptionBufferSize;
- (void)finalize;
- (id)responseForServerData:(id)fp8;
- (id)securityLayer;
- (void)setAuthenticationState:(int)fp8;

@end
