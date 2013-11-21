//
//  MKStoreKitManager.m
//  ContactManager
//
//  Created by iMac02 on 22/10/2012.
//
//

#import "MKStoreKitManager.h"

@interface MKStoreKitManager ()

@property (nonatomic, copy) void (^onFailed)(id error);
@property (nonatomic, copy) void (^onTransactionCancelled)();
@property (nonatomic, copy) void (^onTransactionCompleted)(NSString *productId, NSData* receiptData, NSArray* downloads);

@property (nonatomic, copy) void (^onRestoreFailed)(NSError* error);
@property (nonatomic, copy) void (^onRestoreCompleted)();

- (void) paymentWithProductIdentifier:(NSString*)productIdentifier;
- (void) saveTransaction:(NSString*) productIdentifier forReceipt:(NSData*) receiptData;

- (void) completeTransaction: (SKPaymentTransaction *)transaction;
- (void) restoreTransaction: (SKPaymentTransaction *)transaction;
- (void) failedTransaction: (SKPaymentTransaction *)transaction;
- (void) provideContent:(NSString*) productIdentifier
            forReceipt:(NSData*) receiptData
         hostedContent:(NSArray*) hostedContent;

@end

@implementation MKStoreKitManager
/**********************************************************************/
/**********************************************************************/
#pragma mark Singleton Methods
static MKStoreKitManager* _sharedStoreManager;
/**********************************************************************/
+ (MKStoreKitManager*)sharedStoreKitManager
{
	if(!_sharedStoreManager) {
		static dispatch_once_t oncePredicate;
		dispatch_once(&oncePredicate, ^{
			_sharedStoreManager = [[super allocWithZone:nil] init];
        });
        
#if TARGET_IPHONE_SIMULATOR
        NSLog(@"You are running in Simulator MKStoreKit runs only on devices");
#else
        _sharedStoreManager = [[self alloc] init];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:_sharedStoreManager];
#endif
    }
    return _sharedStoreManager;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedStoreKitManager];
}


- (id)copyWithZone:(NSZone *)zone
{
    return self;
}
/**********************************************************************/
/**********************************************************************/
/**********************************************************************/

- (void) paymentWithProductIdentifier:(NSString*)productIdentifier
{
    _skProductsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:productIdentifier]];
    _skProductsRequest.delegate = self;
    [_skProductsRequest start];
}
/**********************************************************************/
- (void) paymentWithProductIdentifier:(NSString*)productIdentifier
                           onComplete:(void (^)(NSString*, NSData*, NSArray*)) completionBlock
                          onCancelled:(void (^)(void)) cancelBlock
                               onFail:(void (^)(id))failBlock
{
    self.onTransactionCompleted = completionBlock;
    self.onTransactionCancelled = cancelBlock;
    self.onFailed = failBlock;
    
    if ([SKPaymentQueue canMakePayments]) {
        [self paymentWithProductIdentifier:productIdentifier];
    }
    else {
        if (self.onFailed) {
            self.onFailed(@"Not canMakePayments");
        }
    }
}

/**********************************************************************/
/**********************************************************************/
#pragma mark -
#pragma mark  SKProductsRequestDelegate methods_____________________________________________________________
// StoreKit returns a response from an SKProductsRequest.
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    // Populate the inappBuy button with the received product info.
    
    SKProduct *validProduct = nil;
    int count = [response.products count];
    if (count > 0) {
        validProduct = [response.products objectAtIndex:0];
        
        NSLog(@"________________________validationURL: %@",kReceiptValidationURL);
        SKPayment *paymentRequest = [SKPayment paymentWithProduct:validProduct];
        // Request a purchase of the selected item.
        [[SKPaymentQueue defaultQueue] addPayment:paymentRequest];
    }
    if (!validProduct) {
        if (self.onFailed) {
            self.onFailed([@"InValid Product: " stringByAppendingString:[response.invalidProductIdentifiers objectAtIndex:0]]);
        }
    }
    _skProductsRequest = nil;
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    if (self.onFailed) {
        self.onFailed(error);
    }
    _skProductsRequest = nil;
}
/**********************************************************************/
/**********************************************************************/
#pragma mark -
#pragma mark _______________________SKPaymentTransactionObserver Delegate
// Sent when the transaction array has changed (additions or state changes).  Client should check state of transactions and finish as appropriate.
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for(SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"__________ Purchasing...");
                
                break;
                
			case SKPaymentTransactionStatePurchased:
				NSLog(@"__________ Purchased");
                [self completeTransaction:transaction];
				
                break;
                
            case SKPaymentTransactionStateRestored:
				NSLog(@"__________ Restored");
                [self restoreTransaction:transaction];
				
            case SKPaymentTransactionStateFailed:
				
                [self failedTransaction:transaction];
				
                break;
				
            default:
				
                break;
		}
    }
}
/**********************************************************************/
// Sent when transactions are removed from the queue (via finishTransaction:).
- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions
{
    NSLog(@"__________ paymentQueue removedTransactions");
}
/**********************************************************************/
// Sent when an error is encountered while adding transactions from the user's purchase history back to the queue.
- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    NSLog(@"__________ paymentQueue restoreCompletedTransactionsFailedWithError");
}
/**********************************************************************/
// Sent when all transactions from the user's purchase history have successfully been added back to the queue.
- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    NSLog(@"__________ paymentQueueRestoreCompletedTransactionsFinished");
}
/**********************************************************************/
// Sent when the download state has changed.
- (void)paymentQueue:(SKPaymentQueue *)queue updatedDownloads:(NSArray *)downloads
{
    NSLog(@"__________ paymentQueue updatedDownloads");
}
/**********************************************************************/
/**********************************************************************/
/**********************************************************************/
/**********************************************************************/
- (void) completeTransaction: (SKPaymentTransaction *)transaction
{
    NSArray *downloads = nil;
    
    [self provideContent:transaction.payment.productIdentifier
              forReceipt:transaction.transactionReceipt
           hostedContent:downloads];
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

/**********************************************************************/
- (void) restoreTransaction: (SKPaymentTransaction *)transaction
{
    NSArray *downloads = nil;
    
    [self provideContent: transaction.originalTransaction.payment.productIdentifier
              forReceipt:transaction.transactionReceipt
           hostedContent:downloads];
	
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}
/**********************************************************************/
- (void) failedTransaction: (SKPaymentTransaction *)transaction
{
    
#ifndef NDEBUG
    NSLog(@"Failed transaction: %@", [transaction description]);
    NSLog(@"error: %@", transaction.error);
#endif
	
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
    if (transaction.error.code != SKErrorPaymentCancelled) {
        if (self.onFailed) {
            self.onFailed(transaction.error);
        }
    }
    else {
        if(self.onTransactionCancelled)
            self.onTransactionCancelled();
    }
}

/**********************************************************************/
/**********************************************************************/
/**********************************************************************/
#pragma mark In-App purchases callbacks
// In most cases you don't have to touch these methods
- (void) provideContent:(NSString*) productIdentifier
            forReceipt:(NSData*) receiptData
         hostedContent:(NSArray*) hostedContent
{
//    if (self.onTransactionCompleted) {
//        self.onTransactionCompleted(productIdentifier, receiptData, hostedContent);
//    }
    [self saveTransaction:productIdentifier forReceipt:receiptData];
}

// saves a record of the transaction by storing the receipt to sandbox
- (void) saveTransaction:(NSString*) productIdentifier forReceipt:(NSData*) receiptData
{
    // UUID
    NSString *deviceUuid;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    id uuid = [defaults objectForKey:@"deviceUuid"];
    if (uuid)
        deviceUuid = (NSString *)uuid;
    else {
        CFUUIDRef uuid = CFUUIDCreate(NULL);
        CFStringRef cfUuid = CFUUIDCreateString(NULL, uuid);
        deviceUuid = (__bridge NSString *)cfUuid;
        CFRelease(uuid);
        [defaults setObject:deviceUuid forKey:@"deviceUuid"];
    }
    
    NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    @"false",@"sandbox",
                                    @"iPhone",@"device",
                                    deviceUuid,@"UUID",
                                    DEVELOPMENT_VALUE,@"development",
                                    [[UIDevice currentDevice] systemVersion],@"iOSVersion",
                                    [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"],@"AppVersion",
                                    [receiptData base64EncodedString],@"receipt",
                                    nil];
    
    NSString *jsonStringToServer = @"";
    jsonStringToServer= [jsonDictionary JSONString];
    //    NSLog(@"string to send: %@",jsonStringToServer);
    
    /**********************************************************/
    // validate to https://buy.itunes.apple.com/verifyReceipt
    
    NSLog(@"validate to buy.itunes");
    
    NSMutableURLRequest *validationRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:kReceiptValidationURL]];
    [validationRequest setHTTPMethod:@"POST"];
    NSString *receiptStringToServer = [NSString stringWithFormat:@"{\"receipt-data\":\"%@\"}",[receiptData base64EncodedString]];
    [validationRequest setHTTPBody:[receiptStringToServer dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:validationRequest returningResponse:nil error:nil];
    
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding: NSUTF8StringEncoding];
    
    id jsonParse = [responseString objectFromJSONString];
    
    if ([jsonParse isKindOfClass:[NSDictionary class]]) {
        NSInteger status = [[jsonParse objectForKey:@"status"] integerValue];
        if (status == 0) {
            NSDictionary *receiptRespond = (NSDictionary *) [jsonParse objectForKey:@"receipt"];
            NSString *productIDRespond = (NSString *) [receiptRespond objectForKey:@"product_id"];
            
            NSLog(@"productIDRespond0:%@",productIDRespond);
            
            if (self.onTransactionCompleted) {
                self.onTransactionCompleted(productIDRespond, nil,nil);
            }
        }
        // jennyhut 0725
        else {
            
            /********************************/
            // validate to https://sandbox.itunes.apple.com/verifyReceipt
            
            NSLog(@"validate to sandbox.itunes");
            validationRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:kReceiptValidationURL]];
            [validationRequest setHTTPMethod:@"POST"];
            receiptStringToServer = [NSString stringWithFormat:@"{\"receipt-data\":\"%@\"}",[receiptData base64EncodedString]];
            [validationRequest setHTTPBody:[receiptStringToServer dataUsingEncoding:NSUTF8StringEncoding]];
            responseData = [NSURLConnection sendSynchronousRequest:validationRequest returningResponse:nil error:nil];
            
            responseString = [[NSString alloc] initWithData:responseData encoding: NSUTF8StringEncoding];
            
            jsonParse = [responseString objectFromJSONString];
            
            if ([jsonParse isKindOfClass:[NSDictionary class]]) {
                
                NSInteger status = [[jsonParse objectForKey:@"status"] integerValue];
                if (status == 0) {
                    
                    NSDictionary *receiptRespond = (NSDictionary *) [jsonParse objectForKey:@"receipt"];
                    NSString *productIDRespond = (NSString *) [receiptRespond objectForKey:@"product_id"];
                    
                    if (self.onTransactionCompleted) {
                        self.onTransactionCompleted(productIDRespond, nil,nil);
                    }
                    
                    NSLog(@"productIDRespond1:%@",productIDRespond);
                }
                else {
                    if (self.onFailed) {
                        self.onFailed(@"No product avaiable");
                    }
                }
            }
            else {
                if (self.onFailed) {
                    self.onFailed(@"No product avaiable");
                }
            }
        }
    }
    else {
        if (self.onFailed) {
            self.onFailed(@"No product avaiable");
        }
    }
}

@end
