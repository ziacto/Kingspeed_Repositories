//
//  MKStoreKitManager.h
//  ContactManager
//
//  Created by iMac02 on 22/10/2012.
//
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "NSData+Base64.h"
#import "JSONKit.h"

#define DEVELOPMENT_VALUE                               @"sandbox"  //@"production" or @"sandbox"
#ifndef NDEBUG
#define kReceiptValidationURL @"https://sandbox.itunes.apple.com/verifyReceipt"
#else
#define kReceiptValidationURL @"https://buy.itunes.apple.com/verifyReceipt"
#endif

//#define kProductIdentifier     @"jp.co.xing.utaehon.koi"
#define kProductIdentifier     @"jp.co.xing.utaehon.doko.ashi.donsu"
//#define kProductIdentifier     @"jp.co.xing.utaehon.tewo.kuro.meda"

@interface MKStoreKitManager : NSObject<SKProductsRequestDelegate, SKPaymentTransactionObserver>
{
    SKProductsRequest *_skProductsRequest;
}

+ (MKStoreKitManager*)sharedStoreKitManager;

// use this method to invoke a purchase
- (void) paymentWithProductIdentifier:(NSString*)productIdentifier
                           onComplete:(void (^)(NSString*, NSData*, NSArray*)) completionBlock
                          onCancelled:(void (^)(void)) cancelBlock
                               onFail:(void (^)(id))failBlock;


@end
