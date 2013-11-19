//
//  ViewController.m
//  JSSQLiteDemo
//
//  Created by Do Nhu Huy on 7/31/13.
//  Copyright (c) 2013 Do Nhu Huy. All rights reserved.
//

#import "ViewController.h"
#import "UserSQLiteController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize javascriptBridge = _bridge;

- (void)viewDidLoad
{
    [super viewDidLoad];
//	NSURL *url = [[NSBundle mainBundle] URLForResource:@"Google" withExtension:@"html"];
//    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    [WebViewJavascriptBridge enableLogging];
    
    _bridge = [WebViewJavascriptBridge bridgeForWebView:_webView handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"ObjC received message from JS: %@", data);
        responseCallback(@"Response for message from ObjC");
       
    }];
    
    
    
//    [_bridge send:@"A string sent from ObjC before Webview has loaded." responseCallback:^(id responseData) {
//        NSLog(@"objc got response! %@", responseData);
//    }];
    
//    [_bridge callHandler:@"testJavascriptHandler" data:[NSDictionary dictionaryWithObject:@"before ready" forKey:@"foo"]];
    
//    [self renderButtons:_webView];
    
    [_bridge registerHandler:@"getListUser" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"getListUser : %@", data);
        UserSQLiteController * userController =[[UserSQLiteController alloc] init];
        NSMutableArray *listUsers = [userController getListUsers];
        responseCallback(listUsers);
    }];
    
    [_bridge registerHandler:@"createUser" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"createUser : %@", data);
        UserSQLiteController * userController =[[UserSQLiteController alloc] init];
        NSDictionary * dict = (NSDictionary*)data;
        BOOL isSuccess = [userController insertUser:dict];
        responseCallback([NSNumber numberWithBool:isSuccess]);
    }];

    
    [_bridge registerHandler:@"updateUser" handler:^(id data, WVJBResponseCallback responseCallback) {
          NSLog(@"updateUser : %@", data);
        UserSQLiteController * userController =[[UserSQLiteController alloc] init];
        NSDictionary * dict = (NSDictionary*)data;
        BOOL isSuccess = [userController updateUser:dict];
        responseCallback([NSNumber numberWithBool:isSuccess]);
    }];

    
    [_bridge registerHandler:@"deleteUser" handler:^(id data, WVJBResponseCallback responseCallback) {
          NSLog(@"deleteUser : %@", data);
        UserSQLiteController * userController =[[UserSQLiteController alloc] init];
        BOOL isSuccess = [userController clearAll];
        responseCallback([NSNumber numberWithBool:isSuccess]);
    }];

    [self loadExamplePage:_webView];
    

}

- (void)renderButtons:(UIWebView*)webView {
    UIButton *messageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[messageButton setTitle:@"Send message" forState:UIControlStateNormal];
	[messageButton addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
	[self.view insertSubview:messageButton aboveSubview:webView];
	messageButton.frame = CGRectMake(20, 414, 130, 45);
    
    UIButton *callbackButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [callbackButton setTitle:@"Call handler" forState:UIControlStateNormal];
    [callbackButton addTarget:self action:@selector(callHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:callbackButton aboveSubview:webView];
	callbackButton.frame = CGRectMake(170, 414, 130, 45);
}

- (void)sendMessage:(id)sender {
    [_bridge send:@"A string sent from ObjC to JS" responseCallback:^(id response) {
        NSLog(@"sendMessage got response: %@", response);
    }];
}

- (void)callHandler:(id)sender {
    NSDictionary* data = [NSDictionary dictionaryWithObject:@"Hi there, JS!" forKey:@"greetingFromObjC"];
    [_bridge callHandler:@"testJavascriptHandler" data:data responseCallback:^(id response) {
        NSLog(@"testJavascriptHandler responded: %@", response);
    }];
}

- (void)loadExamplePage:(UIWebView*)webView {
    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"JSSQLiteDemo" ofType:@"html"];
    NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    [webView loadHTMLString:appHtml baseURL:nil];
}


- (BOOL)shouldAutorotate{
    return YES;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return (UIInterfaceOrientationLandscapeLeft | UIInterfaceOrientationLandscapeRight);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    
    // mode Lanscape
    return ((interfaceOrientation == UIInterfaceOrientationLandscapeLeft)||
            (interfaceOrientation == UIInterfaceOrientationLandscapeRight));
    
}

@end
