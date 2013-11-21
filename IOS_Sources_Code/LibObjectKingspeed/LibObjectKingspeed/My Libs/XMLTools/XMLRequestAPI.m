////
////  XMLRequestAPI.m
////  GiftCard
////
////  Created by iMac02 on 28/9/2012.
////  Copyright (c) 2012 iMac02. All rights reserved.
////
//
//#import "XMLRequestAPI.h"
//#import "XMLWriter.h"
//#import "NSString+xmlDocPtr.h"
//
//#import "BarCodeReaderController.h"
//#import "CardProccessViewController.h"
//
//#define FORMAT_TIME_REQUEST @"yyyy-MM-ddTHH:mm:ss"
//
//@interface XMLRequestAPI ()
//+ (NSString*) getCardRequestAction:(CardRequestAPI)action soapAction:(NSString**)soapAction cardNumber:(NSString*)cardNumber janCode:(NSString*) janCode money:(NSString*)money autoScan:(BOOL) autoScan;
//+ (NSString*) xmlPostQueryEndPoit;
//
//+ (NSString*) xmlPostActivationWithCardNumber:(NSString*)cardNumber janCode:(NSString*) janCode;
//+ (NSString*) xmlPostRedemptionWithCardNumber:(NSString*)cardNumber janCode:(NSString*) janCode money:(NSString*)money autoScan:(BOOL) autoScan;
//+ (NSString*) xmlPostUndoActivationWithCardNumber:(NSString*)cardNumber janCode:(NSString*) janCode;
//+ (NSString*) xmlPostUndoRedemptionWithCardNumber:(NSString*)cardNumber janCode:(NSString*) janCode money:(NSString*)money;
//+ (NSString*) xmlPostBalanceInquiryWithCardNumber:(NSString*)cardNumber janCode:(NSString*) janCode autoScan:(BOOL) autoScan;
//+ (NSString*) xmlHeader;
//+ (NSString*) xmlFooter;
//+ (NSString*) dateFormatRequestAndRandomRQnumber:(NSString**) rdNumber;
//
//
//- (void) gotoActivationView:(NSString*) xmlResponse;
//- (void) gotoRedemptionView:(NSString*) xmlResponse;
//- (void) gotoUndoActivationView:(NSString*) xmlResponse;
//- (void) gotoUndoRedemptionView:(NSString*) xmlResponse;
//- (void) gotoBalanceInqueryView:(NSString*) xmlResponse;
//
//- (void) showHub;
//
//@end
//
//@implementation XMLRequestAPI
//
//static XMLRequestAPI *shareInstance_ = nil;
////===================================================
//@synthesize cardRequestAction = _cardRequestApiAction;
////===================================================
//
//// Init
//+(XMLRequestAPI*) shareInstance
//{
//	@synchronized(self) {
//		if (!shareInstance_) {
//			shareInstance_ = [[XMLRequestAPI alloc] init];
//        }
//	}
//	return shareInstance_;
//}
//
//+ (id) alloc
//{
//	@synchronized(self) {
//		NSAssert(shareInstance_ == nil, @"Attempted to allocate a second instance of a singleton.");
//		return [super alloc];
//	}
//	return nil;
//}
//
//- (id) init
//{
//    if((self = [super init])) {
//        // initial variables
//        _cardRequestApiAction = CardRequestAPINon;
//    }
//    
//    return self;
//}
//
///************************************************************/
///********************* Send Data To Server ******************/
///************************************************************/
//#pragma mark -
//#pragma mark ASIHTTPRequestDelegate Methods ______________________________
////- (void)requestStarted:(ASIHTTPRequest *)request
////{
////    if (!_receivedDatas) _receivedDatas = [[NSMutableData alloc] init];
////    [_receivedDatas setLength:0];
////}
////- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
////{
////    
////}
////- (void)request:(ASIHTTPRequest *)request didReceiveData:(NSData *)data
////{
////    [_receivedDatas appendData:data];
////}
////- (void)requestFinished:(ASIHTTPRequest *)request
////{
////    NSString *xmlResponse = [[NSString alloc] initWithData:_receivedDatas encoding:NSUTF8StringEncoding];
////    
////    /****************/
////    if (LOG_CARD_RESPONSE_XML)
////        NSLog(@"________________________________________________ REQUEST_RESPONSE:\n%@", [xmlResponse prettyXMLString]);
////    /****************/
////    
////    NSString *processResult = [xmlResponse stringByTagXML:@"ProcessResult"];
////    NSString *mess = [[AppDelegate shareApp] getMessageWithCardProcessResult:processResult];
////    
////    if ([processResult isEqualToString:CardResponseResult_000]) {
////        // save data card response to userdefaults
////        [[AppDelegate shareApp] saveHistoryCardFromXMLResponse:xmlResponse];
////        switch (_cardRequestApiAction) {
////                /***************************/
////            case CardRequestAPIActivation: {
////                [self gotoActivationView:xmlResponse];
////            }
////                break;
////                /***************************/
////            case CardRequestAPIRedemption: {
////                [self gotoRedemptionView:xmlResponse];
////            }
////                break;
////                /***************************/
////            case CardRequestAPIUndoActivation: {
////                [self gotoUndoActivationView:xmlResponse];
////            }
////                break;
////                /***************************/
////            case CardRequestAPIUndoRedemption: {
////                [self gotoUndoRedemptionView:xmlResponse];
////            }
////                break;
////                /***************************/
////            case CardRequestAPIBalanceInquiry: {
////                [self gotoBalanceInqueryView:xmlResponse];
////            }
////                break;
////                /***************************/
////            default:
////                break;
////        }
////        
////        _cardRequestApiAction = CardRequestAPINon;
////        _currentViewController = nil;
////        
////        if (mess) [[AppDelegate shareApp] alert:nil mess:mess];
////    }
////    else {
////        // new 24/10/2012
////        if ([processResult isEqualToString:CardResponseResult_500] || [processResult isEqualToString:CardResponseResult_502] || [processResult isEqualToString:CardResponseResult_509]) {
////            [[AppDelegate shareApp] saveHistoryCardFromXMLResponse:xmlResponse];
////        }
////        /**********************************/
////        
////        if (mess) {
////            if ([mess isEqualToString:MessCardResult_220] && _cardRequestApiAction == CardRequestAPIUndoRedemption) {
////                [[AppDelegate shareApp] alert:nil mess:MessCardResult_220_UndoRedemp];
////            }
////            else {
////                [[AppDelegate shareApp] alert:kTitleAlertRequestResult mess:mess];
////            }
////        }
////        
////        if ([_currentViewController.nibName isEqualToString:@"EnterBarcodeViewController"] ||
////            [_currentViewController.nibName isEqualToString:@"DeleteViewController"]) {
////            // No action
////        }
////        else {
////            [_currentViewController.navigationController popToRootViewControllerAnimated:YES];
////            _cardRequestApiAction = CardRequestAPINon;
////            _currentViewController = nil;
////        }
////    }
////    
////    [MBProgressHUD hideAllHUDsForView:[AppDelegate shareApp].window animated:YES];
////}
////- (void)requestFailed:(ASIHTTPRequest *)request
////{
////    NSLog(@"______requestFailed");
////    
////    if ([_currentViewController.nibName isEqualToString:@"BarCodeReaderController"]) {
////        BarCodeReaderController *_barCodeView = (BarCodeReaderController*)_currentViewController;
////        [_barCodeView continueScanBarcode];
////    }
////    
////    [MBProgressHUD hideAllHUDsForView:[AppDelegate shareApp].window animated:YES];
////    
////    [[AppDelegate shareApp] alert:nil mess:MESS_NETWORK_ERROR];
////}
//
///************************************************************/
///************************************************************/
//- (void) gotoActivationView:(NSString*) xmlResponse
//{
//    CardProccessViewController *_activationView = [[CardProccessViewController alloc] initWithNibName:@"CardProccessViewController" bundle:nil cardAction:CardActionActivationScreen xmlResponse:xmlResponse];
//    [_currentViewController.navigationController pushViewController:_activationView animated:YES];
//    [_currentViewController.navigationController setToolbarHidden:YES animated:YES];
//}
//- (void) gotoRedemptionView:(NSString*) xmlResponse
//{
//    CardProccessViewController *_redemptionViewController = [[CardProccessViewController alloc] initWithNibName:@"CardProccessViewController" bundle:nil cardAction:CardActionRedemptionScreen xmlResponse:xmlResponse];
//    [_currentViewController.navigationController pushViewController:_redemptionViewController animated:YES];
//    [_currentViewController.navigationController setToolbarHidden:YES animated:YES];
//}
//- (void) gotoUndoActivationView:(NSString*) xmlResponse
//{
//    CardProccessViewController *_undoActivationView = [[CardProccessViewController alloc] initWithNibName:@"CardProccessViewController" bundle:nil cardAction:CardActionUndoActivationScreen xmlResponse:xmlResponse];
//    [_currentViewController.navigationController pushViewController:_undoActivationView animated:YES];
//    [_currentViewController.navigationController setToolbarHidden:YES animated:YES];
//}
//- (void) gotoUndoRedemptionView:(NSString*) xmlResponse
//{
//    CardProccessViewController *_undoRedemptionViewController = [[CardProccessViewController alloc] initWithNibName:@"CardProccessViewController" bundle:nil cardAction:CardActionUndoRedemptionScreen xmlResponse:xmlResponse];
//    [_currentViewController.navigationController pushViewController:_undoRedemptionViewController animated:YES];
//    [_currentViewController.navigationController setToolbarHidden:YES animated:YES];
//}
//- (void) gotoBalanceInqueryView:(NSString*) xmlResponse
//{
//    CardProccessViewController *_balanceQueryView = [[CardProccessViewController alloc] initWithNibName:@"CardProccessViewController" bundle:nil cardAction:CardActionBalanceInquiryScreen xmlResponse:xmlResponse];
//    [_currentViewController.navigationController pushViewController:_balanceQueryView animated:YES];
//    [_currentViewController.navigationController setToolbarHidden:YES animated:YES];
//}
///***************************************************************/
//- (void) showHub
//{
//    [MBProgressHUD showHUDAddedTo:[AppDelegate shareApp].window animated:NO];
//}
///***************************************************************/
//- (void) sendRequestDataWithCardNumber:(NSString*)cardNumber janCode:(NSString*) janCode action:(CardRequestAPI) action money:(NSString*)money fromViewController:(UIViewController*)viewController_ autoScan:(BOOL) autoScan
//{
//    [self performSelectorInBackground:@selector(showHub) withObject:nil];
//    
//    _currentViewController = viewController_;
//    
//    NSString *soapAction = nil;
//    NSString *dataString = [XMLRequestAPI getCardRequestAction:action soapAction:&soapAction cardNumber:cardNumber janCode:janCode money:money autoScan:autoScan];
//    NSData *postBody = [dataString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
//    
//    if (LOG_CARD_REQUEST_XML) {
//        NSLog(@"_______ REQUEST_STRING:\n%@", dataString);
//    }
//    
//    NSMutableDictionary * postDataDict = [NSMutableDictionary dictionaryWithObject:postBody forKey:@"xmlData"];
//    MKNetworkOperation * requestOperation = [self operationWithURLString:API_URL_REQUEST params:postDataDict httpMethod:@"POST"];
//
//    [requestOperation setUsername:kAPI_UserID password:kAPI_Pass basicAuth:YES];
//    [requestOperation addHeaders:[NSDictionary dictionaryWithObjectsAndKeys:soapAction,@"soapAction",@"text/xml",@"Accept",@"text/xml",@"Content-Type",[NSString stringWithFormat:@"%d", [postBody length]],@"Content-Length", nil]];
//    
//    [requestOperation setCustomPostDataEncodingHandler:^NSString *(NSDictionary *postDataDict) {
//        NSData * postData = [postDataDict objectForKey:@"xmlData"];
//        NSString * postString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
//        return postString;
//    }
//     forType:@"text/xml"];
//    
//    [requestOperation onCompletion:^(MKNetworkOperation *operation) {
//        NSLog(@"________________Respone:\n %@", [operation.responseString prettyXMLString]);
////        DLog(@"%@", operation);
//    } onError:^(NSError *error) {
//        DLog(@"%@", error);
//    }];
//    
//    [self enqueueOperation:requestOperation];
//    
////    ASIFormDataRequest *_asiFormDataRequest = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:API_URL_REQUEST]];
////    [_asiFormDataRequest setTimeOutSeconds:TIMEOUT_REQUEST];
////    [_asiFormDataRequest setValidatesSecureCertificate:NO];
////    [_asiFormDataRequest setUsername:kAPI_UserID];
////    [_asiFormDataRequest setPassword:kAPI_Pass];
////    [_asiFormDataRequest setCacheStoragePolicy:ASICacheForSessionDurationCacheStoragePolicy];
////    [_asiFormDataRequest applyAuthorizationHeader];
////    
////    [_asiFormDataRequest setRequestMethod:@"POST"];
////    [_asiFormDataRequest addRequestHeader:@"soapAction" value:soapAction];
////    [_asiFormDataRequest addRequestHeader:@"Accept" value:@"text/xml"];
////    [_asiFormDataRequest addRequestHeader:@"Content-Type" value:@"text/xml"];
////    [_asiFormDataRequest addRequestHeader:@"Content-Length" value:[NSString stringWithFormat:@"%d", [postBody length]]];
////    [_asiFormDataRequest appendPostData:postBody];
////    [_asiFormDataRequest setDelegate:self];
////    [_asiFormDataRequest startSynchronous];
//}
///***************************************************************/
///***************************************************************
//+ (void) sendRequestDataWithCardNumber:(NSString*)cardNumber janCode:(NSString*) janCode action:(CardRequestAPI) action delegate:(id) delegate_ money:(NSString*)money autoScan:(BOOL) autoScan
//{
//    NSString *soapAction = nil;
//    NSString *dataString = [XMLRequestAPI getCardRequestAction:action soapAction:&soapAction cardNumber:cardNumber janCode:janCode money:money autoScan:autoScan];
//    NSData *postBody = [dataString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
//    
//    if (LOG_CARD_REQUEST_XML) {
//        NSLog(@"_______ REQUEST_STRING:\n%@", dataString);
//    }
//    
//    ASIFormDataRequest *_asiFormDataRequest = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:API_URL_REQUEST]];
//    [_asiFormDataRequest setTimeOutSeconds:TIMEOUT_REQUEST];
//    [_asiFormDataRequest setValidatesSecureCertificate:NO];
//    [_asiFormDataRequest setUsername:kAPI_UserID];
//    [_asiFormDataRequest setPassword:kAPI_Pass];
//    [_asiFormDataRequest setCacheStoragePolicy:ASICacheForSessionDurationCacheStoragePolicy];
//    [_asiFormDataRequest applyAuthorizationHeader];
//    
//    [_asiFormDataRequest setRequestMethod:@"POST"];
//    [_asiFormDataRequest addRequestHeader:@"soapAction" value:soapAction];
//    [_asiFormDataRequest addRequestHeader:@"Accept" value:@"text/xml"];
//    [_asiFormDataRequest addRequestHeader:@"Content-Type" value:@"text/xml"];
//    [_asiFormDataRequest addRequestHeader:@"Content-Length" value:[NSString stringWithFormat:@"%d", [postBody length]]];
//    [_asiFormDataRequest appendPostData:postBody];
//    [_asiFormDataRequest setDelegate:delegate_];
//    [_asiFormDataRequest startSynchronous];
//}
//***************************************************************/
//+ (NSString*) getCardRequestAction:(CardRequestAPI)action soapAction:(NSString**)soapAction cardNumber:(NSString*)cardNumber janCode:(NSString*) janCode money:(NSString*)money autoScan:(BOOL) autoScan
//{
//    NSString *dataString = @"";
//    
//    switch (action) {
//        case CardRequestAPIQueryEndPoint:{
//            dataString = [XMLRequestAPI xmlPostQueryEndPoit];
//            *soapAction = SoapActionQueryEndPoint;
//        }
//            break;
//            
//        case CardRequestAPIActivation:{
//            dataString = [XMLRequestAPI xmlPostActivationWithCardNumber:cardNumber janCode:janCode];
//            *soapAction = SoapActionActivation;
//        }
//            break;
//            
//        case CardRequestAPIRedemption:{
//            dataString = [XMLRequestAPI xmlPostRedemptionWithCardNumber:cardNumber janCode:janCode money:money autoScan:autoScan];
//            *soapAction = SoapActionRedemption;
//        }
//            break;
//            
//        case CardRequestAPIUndoActivation:{
//            dataString = [XMLRequestAPI xmlPostUndoActivationWithCardNumber:cardNumber janCode:janCode];
//            *soapAction = SoapActionUndoActivation;
//        }
//            break;
//            
//        case CardRequestAPIUndoRedemption:{
//            dataString = [XMLRequestAPI xmlPostUndoRedemptionWithCardNumber:cardNumber janCode:janCode money:money];
//            *soapAction = SoapActionUndoRedemption;
//        }
//            break;
//            
//        case CardRequestAPIBalanceInquiry:{
//            dataString = [XMLRequestAPI xmlPostBalanceInquiryWithCardNumber:cardNumber janCode:janCode autoScan:autoScan];
//            *soapAction = SoapActionBalanceInquiry;
//        }
//            break;
//            
//        default:
//            break;
//    }
//    
//    //	NSLog(@"_______________XML: %@", dataString);
//    
//    return dataString;
//}
///************************************************************/
///************************************************************/
//+ (NSString*) xmlPostQueryEndPoit
//{
//    NSString *strRequestNumber = @"1234";
//    NSString *strDate = [XMLRequestAPI dateFormatRequestAndRandomRQnumber:&strRequestNumber];
//    
//    NSMutableString *dataString = [[NSMutableString alloc] initWithString:[XMLRequestAPI xmlHeader]];
//    
//    [dataString appendString:@"<QueryEndPoint  xmlns=\"http://schemas.uniteloyaltyservices.net/GiftCardProcessor/\">"];
//    [dataString appendString:@"<request>"];
//    [dataString appendString:@"<ConnectionComment></ConnectionComment>"];
//    [dataString appendString:@"<CurrencyCode>JPY</CurrencyCode>"];
//    [dataString appendFormat:@"<EnterpriseID>%@</EnterpriseID>",kEnterpriseID];
//    [dataString appendFormat:@"<ProcessorID>%@</ProcessorID>",kProcessorID];
//    [dataString appendFormat:@"<RequestNumber>%@</RequestNumber>",strRequestNumber];
//    [dataString appendString:@"<RequestOperation>QueryEndPoint</RequestOperation>"];
//    [dataString appendString:@"<RequestOperationComment></RequestOperationComment>"];
//    [dataString appendFormat:@"<SendDateTime>%@</SendDateTime>",strDate];
//    [dataString appendFormat:@"<StoreID>%@</StoreID>",[[NSUserDefaults standardUserDefaults] objectForKey:userDefaultStoreIDSetting]];
//    [dataString appendFormat:@"<StoreTradingDateTime>%@</StoreTradingDateTime>", strDate];
//    [dataString appendString:@"<TerminalID>0</TerminalID>"];
//    [dataString appendString:@"<Timezone>+0900</Timezone>"];
//    [dataString appendString:@"<TradingReceiptNumber>0</TradingReceiptNumber>"];
//    [dataString appendString:@"<Version>1000</Version>"];
//    [dataString appendString:@"</request>"];
//    [dataString appendString:@"</QueryEndPoint>"];
//    
//    [dataString appendString:[XMLRequestAPI xmlFooter]];
//    
//    return [dataString copy];
//}
///************************************************************/
//+ (NSString*) xmlPostActivationWithCardNumber:(NSString*)cardNumber janCode:(NSString*) janCode
//{
//    NSString *strRequestNumber = @"1234";
//    NSString *strDate = [XMLRequestAPI dateFormatRequestAndRandomRQnumber:&strRequestNumber];
//    
//    NSString *storeID = [[NSUserDefaults standardUserDefaults] objectForKey:userDefaultStoreIDSetting];
//    XMLWriter *writer = [[XMLWriter alloc] init];
//    
//    /****** Header ******/
//    [writer writeStartDocumentWithEncodingAndVersion:@"utf-8" version:@"1.0"];
//    [writer writeStartElement:@"s:Envelope"];
//    [writer writeAttribute:@"xmlns:s" value:@"http://schemas.xmlsoap.org/soap/envelope/"];
//    [writer writeStartElement:@"s:Body"];
//    
//    /****** Request ******/
//    [writer writeStartElement:@"Activation"];
//    [writer writeAttribute:@"xmlns" value:@"http://schemas.uniteloyaltyservices.net/GiftCardProcessor/"];
//    
//    [writer writeStartElement:@"request"];
//    [writer writeAttribute:@"xmlns:i" value:@"http://www.w3.org/2001/XMLSchema-instance"];
//    
//    [writer writeStartElement:@"ConnectionComment"];    [writer writeCharacters:@""];           [writer writeEndElement];
//    [writer writeStartElement:@"CurrencyCode"];     [writer writeCharacters:@"JPY"];            [writer writeEndElement];
//    [writer writeStartElement:@"EnterpriseID"];     [writer writeCharacters:kEnterpriseID];     [writer writeEndElement];
//    [writer writeStartElement:@"ProcessorID"];      [writer writeCharacters:kProcessorID];      [writer writeEndElement];
//    [writer writeStartElement:@"RequestNumber"];    [writer writeCharacters:strRequestNumber];  [writer writeEndElement];
//    [writer writeStartElement:@"RequestOperation"]; [writer writeCharacters:@"Activation"];     [writer writeEndElement];
//    [writer writeStartElement:@"RequestOperationComment"];    [writer writeCharacters:@""];     [writer writeEndElement];
//    [writer writeStartElement:@"SendDateTime"];     [writer writeCharacters:strDate];           [writer writeEndElement];
//    [writer writeStartElement:@"StoreID"];          [writer writeCharacters:storeID];           [writer writeEndElement];
//    [writer writeStartElement:@"StoreTradingDateTime"];    [writer writeCharacters:strDate];    [writer writeEndElement];
//    [writer writeStartElement:@"TerminalID"];       [writer writeCharacters:@"0"];              [writer writeEndElement];
//    [writer writeStartElement:@"Timezone"];         [writer writeCharacters:@"+0900"];          [writer writeEndElement];
//    [writer writeStartElement:@"TradingReceiptNumber"];    [writer writeCharacters:@"0"];       [writer writeEndElement];
//    [writer writeStartElement:@"Version"];          [writer writeCharacters:@"1000"];           [writer writeEndElement];
//    
//    /*** <!-- card info-->  ***/
//    [writer writeLinebreak]; [writer writeLinebreak]; [writer writeIndentation];
//    [writer writeComment:@" card info "];
//    [writer writeStartElement:@"CardInputMethod"];      [writer writeCharacters:@"Barcode"];    [writer writeEndElement];
//    [writer writeStartElement:@"CardNumber"];           [writer writeCharacters:cardNumber];    [writer writeEndElement];
//    [writer writeStartElement:@"FaceAmount"];           [writer writeCharacters:@"0"];          [writer writeEndElement];
//    [writer writeStartElement:@"FieldsSetting"];        [writer writeCharacters:@"JanCode,CardNumber,CardInputMethod"]; [writer writeEndElement];
//    [writer writeStartElement:@"JanCode"];              [writer writeCharacters:janCode];       [writer writeEndElement];
//    [writer writeStartElement:@"PIN"];                  [writer writeCharacters:@"0"];          [writer writeEndElement];
//    [writer writeStartElement:@"RedemptionAmount"];     [writer writeCharacters:@"0"];          [writer writeEndElement];
//    
//    /****** Close Request ******/
//    [writer writeEndDocument];
//    
//    return [writer toString];
//}
///************************************************************/
//+ (NSString*) xmlPostRedemptionWithCardNumber:(NSString*)cardNumber janCode:(NSString*) janCode money:(NSString*)money autoScan:(BOOL) autoScan
//{
//    NSString *strRequestNumber = @"1234";
//    NSString *strDate = [XMLRequestAPI dateFormatRequestAndRandomRQnumber:&strRequestNumber];
//    
//    NSString *fieldSetting = @"JanCode,CardNumber,CardInputMethod,RedemptionAmount";
//    NSString *cardInputMethodStr = @"Barcode";
//    NSString *janCodeType = janCode;
//    if (!autoScan) {
//        cardInputMethodStr = @"Manual";
//        janCodeType = @"0";
//        fieldSetting = @"CardNumber,CardInputMethod,RedemptionAmount";
//    }
//    
//    NSString *storeID = [[NSUserDefaults standardUserDefaults] objectForKey:userDefaultStoreIDSetting];
//    XMLWriter *writer = [[XMLWriter alloc] init];
//    
//    /****** Header ******/
//    [writer writeStartDocumentWithEncodingAndVersion:@"utf-8" version:@"1.0"];
//    [writer writeStartElement:@"s:Envelope"];
//    [writer writeAttribute:@"xmlns:s" value:@"http://schemas.xmlsoap.org/soap/envelope/"];
//    [writer writeStartElement:@"s:Body"];
//    
//    /****** Request ******/
//    [writer writeStartElement:@"Redemption"];
//    [writer writeAttribute:@"xmlns" value:@"http://schemas.uniteloyaltyservices.net/GiftCardProcessor/"];
//    
//    [writer writeStartElement:@"request"];
//    [writer writeAttribute:@"xmlns:i" value:@"http://www.w3.org/2001/XMLSchema-instance"];
//    
//    [writer writeStartElement:@"ConnectionComment"];    [writer writeCharacters:@""];           [writer writeEndElement];
//    [writer writeStartElement:@"CurrencyCode"];     [writer writeCharacters:@"JPY"];            [writer writeEndElement];
//    [writer writeStartElement:@"EnterpriseID"];     [writer writeCharacters:kEnterpriseID];     [writer writeEndElement];
//    [writer writeStartElement:@"ProcessorID"];      [writer writeCharacters:kProcessorID];      [writer writeEndElement];
//    [writer writeStartElement:@"RequestNumber"];    [writer writeCharacters:strRequestNumber];  [writer writeEndElement];
//    [writer writeStartElement:@"RequestOperation"]; [writer writeCharacters:@"Redemption"];     [writer writeEndElement];
//    [writer writeStartElement:@"RequestOperationComment"];    [writer writeCharacters:@""];     [writer writeEndElement];
//    [writer writeStartElement:@"SendDateTime"];     [writer writeCharacters:strDate];           [writer writeEndElement];
//    [writer writeStartElement:@"StoreID"];          [writer writeCharacters:storeID];           [writer writeEndElement];
//    [writer writeStartElement:@"StoreTradingDateTime"];    [writer writeCharacters:strDate];    [writer writeEndElement];
//    [writer writeStartElement:@"TerminalID"];       [writer writeCharacters:@"0"];              [writer writeEndElement];
//    [writer writeStartElement:@"Timezone"];         [writer writeCharacters:@"+0900"];          [writer writeEndElement];
//    [writer writeStartElement:@"TradingReceiptNumber"];    [writer writeCharacters:@"0"];       [writer writeEndElement];
//    [writer writeStartElement:@"Version"];          [writer writeCharacters:@"1000"];           [writer writeEndElement];
//    
//    /*** <!-- card info-->  ***/
//    [writer writeLinebreak]; [writer writeLinebreak]; [writer writeIndentation];
//    [writer writeComment:@" card info "];
//    [writer writeStartElement:@"CardInputMethod"];      [writer writeCharacters:cardInputMethodStr];    [writer writeEndElement];
//    [writer writeStartElement:@"CardNumber"];           [writer writeCharacters:cardNumber];    [writer writeEndElement];
//    [writer writeStartElement:@"FaceAmount"];           [writer writeCharacters:@"0"];          [writer writeEndElement];
//    [writer writeStartElement:@"FieldsSetting"];        [writer writeCharacters:fieldSetting];  [writer writeEndElement];
//    [writer writeStartElement:@"JanCode"];              [writer writeCharacters:janCodeType];   [writer writeEndElement];
//    [writer writeStartElement:@"PIN"];                  [writer writeCharacters:@"0"];          [writer writeEndElement];
//    [writer writeStartElement:@"RedemptionAmount"];     [writer writeCharacters:money];         [writer writeEndElement];
//    
//    /****** Close Request ******/
//    [writer writeEndDocument];
//    
//    return [writer toString];
//}
///************************************************************/
//+ (NSString*) xmlPostUndoActivationWithCardNumber:(NSString*)cardNumber janCode:(NSString*) janCode
//{
//    NSString *strRequestNumber = @"1234";
//    NSString *strDate = [XMLRequestAPI dateFormatRequestAndRandomRQnumber:&strRequestNumber];
//   
//    NSString *storeID = [[NSUserDefaults standardUserDefaults] objectForKey:userDefaultStoreIDSetting];
//    XMLWriter *writer = [[XMLWriter alloc] init];
//    
//    /****** Header ******/
//    [writer writeStartDocumentWithEncodingAndVersion:@"utf-8" version:@"1.0"];
//    [writer writeStartElement:@"s:Envelope"];
//    [writer writeAttribute:@"xmlns:s" value:@"http://schemas.xmlsoap.org/soap/envelope/"];
//    [writer writeStartElement:@"s:Body"];
//    
//    /****** Request ******/
//    [writer writeStartElement:@"UndoActivation"];
//    [writer writeAttribute:@"xmlns" value:@"http://schemas.uniteloyaltyservices.net/GiftCardProcessor/"];
//    
//    [writer writeStartElement:@"request"];
//    [writer writeAttribute:@"xmlns:i" value:@"http://www.w3.org/2001/XMLSchema-instance"];
//    
//    [writer writeStartElement:@"ConnectionComment"];    [writer writeCharacters:@""];           [writer writeEndElement];
//    [writer writeStartElement:@"CurrencyCode"];     [writer writeCharacters:@"JPY"];            [writer writeEndElement];
//    [writer writeStartElement:@"EnterpriseID"];     [writer writeCharacters:kEnterpriseID];     [writer writeEndElement];
//    [writer writeStartElement:@"ProcessorID"];      [writer writeCharacters:kProcessorID];      [writer writeEndElement];
//    [writer writeStartElement:@"RequestNumber"];    [writer writeCharacters:strRequestNumber];  [writer writeEndElement];
//    [writer writeStartElement:@"RequestOperation"]; [writer writeCharacters:@"UndoActivation"]; [writer writeEndElement];
//    [writer writeStartElement:@"RequestOperationComment"];    [writer writeCharacters:@""];     [writer writeEndElement];
//    [writer writeStartElement:@"SendDateTime"];     [writer writeCharacters:strDate];           [writer writeEndElement];
//    [writer writeStartElement:@"StoreID"];          [writer writeCharacters:storeID];           [writer writeEndElement];
//    [writer writeStartElement:@"StoreTradingDateTime"];    [writer writeCharacters:strDate];    [writer writeEndElement];
//    [writer writeStartElement:@"TerminalID"];       [writer writeCharacters:@"0"];              [writer writeEndElement];
//    [writer writeStartElement:@"Timezone"];         [writer writeCharacters:@"+0900"];          [writer writeEndElement];
//    [writer writeStartElement:@"TradingReceiptNumber"];    [writer writeCharacters:@"0"];       [writer writeEndElement];
//    [writer writeStartElement:@"Version"];          [writer writeCharacters:@"1000"];           [writer writeEndElement];
//    
//    /*** <!-- card info-->  ***/
//    [writer writeLinebreak]; [writer writeLinebreak]; [writer writeIndentation];
//    [writer writeComment:@" card info "];
//    [writer writeStartElement:@"CardInputMethod"];          [writer writeCharacters:@"Barcode"];    [writer writeEndElement];
//    [writer writeStartElement:@"CardNumber"];               [writer writeCharacters:cardNumber];    [writer writeEndElement];
//    [writer writeStartElement:@"FaceAmount"];               [writer writeCharacters:@"0"];          [writer writeEndElement];
//    [writer writeStartElement:@"FieldsSetting"];            [writer writeCharacters:@"JanCode,CardNumber,CardInputMethod"]; [writer writeEndElement];
//    [writer writeStartElement:@"JanCode"];                  [writer writeCharacters:janCode];       [writer writeEndElement];
//    [writer writeStartElement:@"PIN"];                      [writer writeCharacters:@"0"];          [writer writeEndElement];
//    [writer writeStartElement:@"RedemptionAmount"];         [writer writeCharacters:@"0"];          [writer writeEndElement];
//    
//    [writer writeStartElement:@"TargetApprovalNumber"];     [writer writeCharacters:@"0"];          [writer writeEndElement];
//    [writer writeStartElement:@"TargetEnterpriseID"];       [writer writeCharacters:@""];           [writer writeEndElement];
//    [writer writeStartElement:@"TargetProcessorID"];        [writer writeCharacters:@""];           [writer writeEndElement];
//    [writer writeStartElement:@"TargetRequestNumber"];      [writer writeCharacters:@"0"];          [writer writeEndElement];
//    [writer writeStartElement:@"TargetRequestOperation"];   [writer writeCharacters:@""];           [writer writeEndElement];
//    [writer writeStartElement:@"TargetSendDate"];           [writer writeCharacters:strDate];       [writer writeEndElement];
//    [writer writeStartElement:@"TargetStoreID"];            [writer writeCharacters:@""];           [writer writeEndElement];
//    [writer writeStartElement:@"TargetStoreTradingDate"];   [writer writeCharacters:strDate];       [writer writeEndElement];
//    [writer writeStartElement:@"TargetTerminalID"];         [writer writeCharacters:@""];           [writer writeEndElement];
//    [writer writeStartElement:@"TargetTimezone"];           [writer writeCharacters:@""];           [writer writeEndElement];
//    [writer writeStartElement:@"TargetVersion"];            [writer writeCharacters:@"0"];          [writer writeEndElement];
//    [writer writeStartElement:@"UndoReason"];               [writer writeCharacters:@"Operation"];  [writer writeEndElement];
//
//    /****** Close Request ******/
//    [writer writeEndDocument];
//    
//    return [writer toString];
//}
///************************************************************/
//+ (NSString*) xmlPostUndoRedemptionWithCardNumber:(NSString*)cardNumber janCode:(NSString*) janCode money:(NSString*)money
//{
//    NSString *strRequestNumber = @"1234";
//    NSString *strDate = [XMLRequestAPI dateFormatRequestAndRandomRQnumber:&strRequestNumber];
//    
//    NSString *storeID = [[NSUserDefaults standardUserDefaults] objectForKey:userDefaultStoreIDSetting];
//    XMLWriter *writer = [[XMLWriter alloc] init];
//    
//    /****** Header ******/
//    [writer writeStartDocumentWithEncodingAndVersion:@"utf-8" version:@"1.0"];
//    [writer writeStartElement:@"s:Envelope"];
//    [writer writeAttribute:@"xmlns:s" value:@"http://schemas.xmlsoap.org/soap/envelope/"];
//    [writer writeStartElement:@"s:Body"];
//    
//    /****** Request ******/
//    [writer writeStartElement:@"UndoRedemption"];
//    [writer writeAttribute:@"xmlns" value:@"http://schemas.uniteloyaltyservices.net/GiftCardProcessor/"];
//    
//    [writer writeStartElement:@"request"];
//    [writer writeAttribute:@"xmlns:i" value:@"http://www.w3.org/2001/XMLSchema-instance"];
//    
//    [writer writeStartElement:@"ConnectionComment"];    [writer writeCharacters:@""];           [writer writeEndElement];
//    [writer writeStartElement:@"CurrencyCode"];     [writer writeCharacters:@"JPY"];            [writer writeEndElement];
//    [writer writeStartElement:@"EnterpriseID"];     [writer writeCharacters:kEnterpriseID];     [writer writeEndElement];
//    [writer writeStartElement:@"ProcessorID"];      [writer writeCharacters:kProcessorID];      [writer writeEndElement];
//    [writer writeStartElement:@"RequestNumber"];    [writer writeCharacters:strRequestNumber];  [writer writeEndElement];
//    [writer writeStartElement:@"RequestOperation"]; [writer writeCharacters:@"UndoRedemption"]; [writer writeEndElement];
//    [writer writeStartElement:@"RequestOperationComment"];    [writer writeCharacters:@""];     [writer writeEndElement];
//    [writer writeStartElement:@"SendDateTime"];     [writer writeCharacters:strDate];           [writer writeEndElement];
//    [writer writeStartElement:@"StoreID"];          [writer writeCharacters:storeID];           [writer writeEndElement];
//    [writer writeStartElement:@"StoreTradingDateTime"];    [writer writeCharacters:strDate];    [writer writeEndElement];
//    [writer writeStartElement:@"TerminalID"];       [writer writeCharacters:@"0"];              [writer writeEndElement];
//    [writer writeStartElement:@"Timezone"];         [writer writeCharacters:@"+0900"];          [writer writeEndElement];
//    [writer writeStartElement:@"TradingReceiptNumber"];    [writer writeCharacters:@"0"];       [writer writeEndElement];
//    [writer writeStartElement:@"Version"];          [writer writeCharacters:@"1000"];           [writer writeEndElement];
//    
//    /*** <!-- card info-->  ***/
//    [writer writeLinebreak]; [writer writeLinebreak]; [writer writeIndentation];
//    [writer writeComment:@" card info "];
//    [writer writeStartElement:@"CardInputMethod"];      [writer writeCharacters:@"Barcode"];    [writer writeEndElement];
//    [writer writeStartElement:@"CardNumber"];           [writer writeCharacters:cardNumber];    [writer writeEndElement];
//    [writer writeStartElement:@"FaceAmount"];           [writer writeCharacters:@"0"];          [writer writeEndElement];
//    [writer writeStartElement:@"FieldsSetting"];        [writer writeCharacters:@"JanCode,CardNumber,CardInputMethod,RedemptionAmount"]; [writer writeEndElement];
//    [writer writeStartElement:@"JanCode"];              [writer writeCharacters:janCode];       [writer writeEndElement];
//    [writer writeStartElement:@"PIN"];                  [writer writeCharacters:@"0"];          [writer writeEndElement];
//    [writer writeStartElement:@"RedemptionAmount"];     [writer writeCharacters:money];         [writer writeEndElement];
//    
//    /************/
//    [writer writeStartElement:@"TargetApprovalNumber"];     [writer writeCharacters:@"0"];          [writer writeEndElement];
//    [writer writeStartElement:@"TargetEnterpriseID"];       [writer writeCharacters:@""];           [writer writeEndElement];
//    [writer writeStartElement:@"TargetProcessorID"];        [writer writeCharacters:@""];           [writer writeEndElement];
//    [writer writeStartElement:@"TargetRequestNumber"];      [writer writeCharacters:@"0"];          [writer writeEndElement];
//    [writer writeStartElement:@"TargetRequestOperation"];   [writer writeCharacters:@""];           [writer writeEndElement];
//    [writer writeStartElement:@"TargetSendDate"];           [writer writeCharacters:strDate];       [writer writeEndElement];
//    [writer writeStartElement:@"TargetStoreID"];            [writer writeCharacters:@""];           [writer writeEndElement];
//    [writer writeStartElement:@"TargetStoreTradingDate"];   [writer writeCharacters:strDate];       [writer writeEndElement];
//    [writer writeStartElement:@"TargetTerminalID"];         [writer writeCharacters:@""];           [writer writeEndElement];
//    [writer writeStartElement:@"TargetTimezone"];           [writer writeCharacters:@""];           [writer writeEndElement];
//    [writer writeStartElement:@"TargetVersion"];            [writer writeCharacters:@"0"];          [writer writeEndElement];
//    [writer writeStartElement:@"UndoReason"];               [writer writeCharacters:@"Operation"];  [writer writeEndElement];
//    /************/
//    /****** Close Request ******/
//    [writer writeEndDocument];
//    
//    return [writer toString];
//}
///************************************************************/
//+ (NSString*) xmlPostBalanceInquiryWithCardNumber:(NSString*)cardNumber janCode:(NSString*) janCode autoScan:(BOOL) autoScan
//{
//    NSString *strRequestNumber = @"1234";
//    NSString *strDate = [XMLRequestAPI dateFormatRequestAndRandomRQnumber:&strRequestNumber];
//    
//    NSString *fieldSetting = @"JanCode,CardNumber,CardInputMethod,RedemptionAmount";
//    NSString *cardInputMethodStr = @"Barcode";
//    NSString *janCodeType = janCode;
//    if (!autoScan) {
//        cardInputMethodStr = @"Manual";
//        janCodeType = @"0";
//        fieldSetting = @"CardNumber,CardInputMethod,RedemptionAmount";
//    }
//    
//    NSString *storeID = [[NSUserDefaults standardUserDefaults] objectForKey:userDefaultStoreIDSetting];
//    XMLWriter *writer = [[XMLWriter alloc] init];
//    
//    /****** Header ******/
//    [writer writeStartDocumentWithEncodingAndVersion:@"utf-8" version:@"1.0"];
//    [writer writeStartElement:@"s:Envelope"];
//    [writer writeAttribute:@"xmlns:s" value:@"http://schemas.xmlsoap.org/soap/envelope/"];
//    [writer writeStartElement:@"s:Body"];
//    
//    /****** Request ******/
//    [writer writeStartElement:@"BalanceInquiry"];
//    [writer writeAttribute:@"xmlns" value:@"http://schemas.uniteloyaltyservices.net/GiftCardProcessor/"];
//    
//    [writer writeStartElement:@"request"];
//    [writer writeAttribute:@"xmlns:i" value:@"http://www.w3.org/2001/XMLSchema-instance"];
//    
//    [writer writeStartElement:@"ConnectionComment"];    [writer writeCharacters:@""];           [writer writeEndElement];
//    [writer writeStartElement:@"CurrencyCode"];     [writer writeCharacters:@"JPY"];            [writer writeEndElement];
//    [writer writeStartElement:@"EnterpriseID"];     [writer writeCharacters:kEnterpriseID];     [writer writeEndElement];
//    [writer writeStartElement:@"ProcessorID"];      [writer writeCharacters:kProcessorID];      [writer writeEndElement];
//    [writer writeStartElement:@"RequestNumber"];    [writer writeCharacters:strRequestNumber];  [writer writeEndElement];
//    [writer writeStartElement:@"RequestOperation"]; [writer writeCharacters:@"BalanceInquiry"]; [writer writeEndElement];
//    [writer writeStartElement:@"RequestOperationComment"];    [writer writeCharacters:@""];     [writer writeEndElement];
//    [writer writeStartElement:@"SendDateTime"];     [writer writeCharacters:strDate];           [writer writeEndElement];
//    [writer writeStartElement:@"StoreID"];          [writer writeCharacters:storeID];           [writer writeEndElement];
//    [writer writeStartElement:@"StoreTradingDateTime"];    [writer writeCharacters:strDate];    [writer writeEndElement];
//    [writer writeStartElement:@"TerminalID"];       [writer writeCharacters:@"0"];              [writer writeEndElement];
//    [writer writeStartElement:@"Timezone"];         [writer writeCharacters:@"+0900"];          [writer writeEndElement];
//    [writer writeStartElement:@"TradingReceiptNumber"];    [writer writeCharacters:@"0"];       [writer writeEndElement];
//    [writer writeStartElement:@"Version"];          [writer writeCharacters:@"1000"];           [writer writeEndElement];
//    
//    /*** <!-- card info-->  ***/
//    [writer writeLinebreak]; [writer writeLinebreak]; [writer writeIndentation];
//    [writer writeComment:@" card info "];
//    [writer writeStartElement:@"CardInputMethod"];      [writer writeCharacters:cardInputMethodStr];    [writer writeEndElement];
//    [writer writeStartElement:@"CardNumber"];           [writer writeCharacters:cardNumber];    [writer writeEndElement];
//    [writer writeStartElement:@"FaceAmount"];           [writer writeCharacters:@"0"];          [writer writeEndElement];
//    [writer writeStartElement:@"FieldsSetting"];        [writer writeCharacters:fieldSetting];  [writer writeEndElement];
//    [writer writeStartElement:@"JanCode"];              [writer writeCharacters:janCode];       [writer writeEndElement];
//    [writer writeStartElement:@"PIN"];                  [writer writeCharacters:@"0"];          [writer writeEndElement];
//    [writer writeStartElement:@"RedemptionAmount"];     [writer writeCharacters:@"0"];          [writer writeEndElement];
//    
//    /****** Close Request ******/
//    [writer writeEndDocument];
//    
//    return [writer toString];
//}
///************************************************************/
///************************************************************/
//+ (NSString*) xmlHeader
//{
//    return [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"xmlHeader.txt" ofType:nil] encoding:NSUTF8StringEncoding error:nil];
//}
//+ (NSString*) xmlFooter
//{
//    return @"</soap:Body></soap:Envelope>";
//}
//+ (NSString*) dateFormatRequestAndRandomRQnumber:(NSString**) rdNumber
//{
//    NSDate *dateRequest = [NSDate date];
//    NSString *strDate = [dateRequest stringFromDateWithFormat:DATE_STRING andTimeZone:[NSTimeZone timeZoneForHoursFromGMT:9]];
//    strDate = [strDate stringByAppendingString:@"T"];
//    strDate = [strDate stringByAppendingString:[dateRequest stringFromDateWithFormat:TIME_STRING andTimeZone:[NSTimeZone timeZoneForHoursFromGMT:9]]];
//    
//    int randomRequestNumber = dateRequest.hour * 10000 + dateRequest.minute * 100 + dateRequest.seconds;
//    *rdNumber = [NSString stringWithFormat:@"%i",randomRequestNumber];
//    return strDate;
//}
///************************************************************/
///***************************************************************/
//@end
