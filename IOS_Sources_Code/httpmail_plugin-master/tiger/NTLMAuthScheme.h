/*
 *     Generated by class-dump 3.0.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004 by Steve Nygard.
 */

#import <Message/AuthScheme.h>

@interface NTLMAuthScheme : AuthScheme
{
}

+ (void)initialize;
- (Class)authenticatorClassForAccount:(id)fp8;
- (BOOL)hasEncryption;
- (id)humanReadableName;
- (id)name;
- (BOOL)requiresDomain;
- (BOOL)sendsPlainTextPasswords;

@end
