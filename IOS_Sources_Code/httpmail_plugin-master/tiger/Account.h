/*
 *     Generated by class-dump 3.0.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004 by Steve Nygard.
 */

#import <Foundation/Foundation.h>

@class NSMutableDictionary;

@interface Account : NSObject 
{
    NSMutableDictionary *_info;
    unsigned int _isOffline:1;
    unsigned int _willingToGoOnline:1;
    unsigned int _autosynchronizingEnabled:1;
    unsigned int _ignoreSSLCertificates:1;
    unsigned int _promptedToIgnoreSSLCertificates:1;
    unsigned int _isActive:2;
}

+ (id)ISPAccounts;
+ (id)ISPDeliveryAccountTypes;
+ (id)ISPReceivingAccountTypes;
+ (id)_ispPlist;
+ (void)_loadISPPlistsAtPath:(id)fp8;
+ (id)_meCardFromMacBuddyPlistFile;
+ (id)accountTypeString;
+ (id)accountsVersion;
+ (BOOL)allObjectsInArrayAreOffline:(id)fp8;
+ (id)createAccountWithDictionary:(id)fp8;
+ (BOOL)haveAccountsBeenConfigured;
+ (void)initialize;
+ (id)myFullName;
+ (id)readAccountsUsingDefaultsKey:(id)fp8;
+ (id)readAccountsUsingDefaultsKey:(id)fp8 forceReadFromMailPreferences:(BOOL)fp12;
+ (void)saveAccountInfoToDefaults;
+ (void)saveAccounts:(id)fp8 usingDefaultsKey:(id)fp12;
- (id)ISPAccountID;
- (BOOL)_connectAndAuthenticate:(id)fp8;
- (BOOL)_ignoreSSLCertificates;
- (void)_queueAccountInfoDidChange;
- (void)_removePasswordInKeychain;
- (void)_setAccountInfo:(id)fp8;
- (void)_setIgnoreSSLCertificates:(BOOL)fp8;
- (BOOL)_shouldRetryConnectionWithoutCertificateCheckingAfterError:(id)fp8;
- (BOOL)_shouldTryDirectSSLConnectionOnPort:(unsigned int)fp8;
- (id)accountInfo;
- (void)accountInfoDidChange;
- (id)authenticatedConnection;
- (BOOL)canGoOffline;
- (Class)connectionClass;
- (BOOL)dataWasSyncedVersion:(id)fp8 newData:(id)fp12 acceptedChanges:(id)fp16;
- (BOOL)dataWillBeSyncedVersion:(id *)fp8 data:(id *)fp12;
- (void)dealloc;
- (unsigned int)defaultPortNumber;
- (unsigned int)defaultSecurePortNumber;
- (id)defaultsDictionary;
- (id)displayName;
- (id)domain;
- (void)finalize;
- (id)hostname;
- (id)init;
- (BOOL)isActive;
- (BOOL)isInactivatedInsteadOfBeingDeleted;
- (BOOL)isOffline;
- (BOOL)isWillingToGoOnline;
- (id)nameForMailboxUid:(id)fp8;
- (id)password;
- (id)passwordFromKeychain;
- (id)passwordFromStoredUserInfo;
- (unsigned int)portNumber;
- (id)preferredAuthScheme;
- (id)promptUserForPasswordWithMessage:(id)fp8;
- (id)promptUserIfNeededForPasswordWithMessage:(id)fp8;
- (void)releaseAllConnections;
- (BOOL)requiresAuthentication;
- (id)saslProfileName;
- (id)secureServiceName;
- (id)serviceName;
- (void)setAccountInfo:(id)fp8;
- (void)setAutosynchronizingEnabled:(BOOL)fp8;
- (void)setDisplayName:(id)fp8;
- (void)setDomain:(id)fp8;
- (void)setHostname:(id)fp8;
- (void)setISPAccountID:(id)fp8;
- (void)setInactivatedInsteadOfBeingDeleted:(BOOL)fp8;
- (void)setIsActive:(BOOL)fp8;
- (void)setIsOffline:(BOOL)fp8;
- (void)setIsWillingToGoOnline:(BOOL)fp8;
- (void)setPassword:(id)fp8;
- (void)setPasswordInKeychain:(id)fp8;
- (void)setPortNumber:(unsigned int)fp8;
- (void)setPreferredAuthScheme:(id)fp8;
- (void)setTemporaryPassword:(id)fp8;
- (void)setUsername:(id)fp8;
- (void)setUsesSSL:(BOOL)fp8;
- (id)uniqueId;
- (void)updateAccountsFromPlist:(id)fp8 acceptedChanges:(id)fp12;
- (void)updateFromSyncedDictionary:(id)fp8;
- (id)username;
- (BOOL)usesSSL;
- (void)validateConnections;

@end
