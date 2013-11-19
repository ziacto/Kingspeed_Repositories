//
//  ViewController.h
//  JSSQLiteDemo
//
//  Created by Do Nhu Huy on 7/31/13.
//  Copyright (c) 2013 Do Nhu Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebViewJavascriptBridge.h"

@interface ViewController : UIViewController{
    UIWebView * _webView;
}

@property (strong, nonatomic) WebViewJavascriptBridge *javascriptBridge;

- (void)renderButtons:(UIWebView*)webView;
- (void)loadExamplePage:(UIWebView*)webView;
@end
