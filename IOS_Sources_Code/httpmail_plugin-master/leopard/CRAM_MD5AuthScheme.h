/*
 *     Generated by class-dump 3.1.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2005 by Steve Nygard.
 */

#import <Message/AuthScheme.h>

@interface CRAM_MD5AuthScheme : AuthScheme
{
}

- (Class)authenticatorClassForAccount:(id)fp8;
- (id)name;
- (id)humanReadableName;
- (BOOL)sendsPlainTextPasswords;
- (BOOL)hasEncryption;
- (unsigned int)securityLevel;
- (BOOL)canAuthenticateAccount:(id)fp8 connection:(id)fp12;

@end
