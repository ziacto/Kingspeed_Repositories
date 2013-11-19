#import "ExampleAppDelegate.h"

@implementation ExampleAppDelegate

@synthesize window = _window;
@synthesize javascriptBridge = _bridge;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIWebView* webView = [[UIWebView alloc] initWithFrame:self.window.bounds];
    [self.window addSubview:webView];
    
//    [WebViewJavascriptBridge enableLogging];
    
    _bridge = [WebViewJavascriptBridge bridgeForWebView:webView handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"ObjC received message from JS: %@", data);
        responseCallback(@"Response for message from ObjC");
    }];
    
    [_bridge registerHandler:@"testObjcCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"testObjcCallback called: %@", data);
        responseCallback(@"Response from testObjcCallback");
    }];
    
    [_bridge send:@"A string sent from ObjC before Webview has loaded." responseCallback:^(id responseData) {
        NSLog(@"objc got response! %@", responseData);
    }];
    
    [_bridge callHandler:@"testJavascriptHandler" data:[NSDictionary dictionaryWithObject:@"before ready" forKey:@"foo"]];
    
    [self renderButtons:webView];
    [self loadExamplePage:webView];
    
    [_bridge send:@"A string sent from ObjC to JS" responseCallback:^(id response) {
        NSLog(@"sendMessage got response: %@", response);
    }];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)renderButtons:(UIWebView*)webView {
    UIButton *messageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[messageButton setTitle:@"Send message" forState:UIControlStateNormal];
	[messageButton addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
	[self.window insertSubview:messageButton aboveSubview:webView];
	messageButton.frame = CGRectMake(20, 414, 130, 45);
    
    UIButton *callbackButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [callbackButton setTitle:@"Call handler" forState:UIControlStateNormal];
    [callbackButton addTarget:self action:@selector(callHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.window insertSubview:callbackButton aboveSubview:webView];
	callbackButton.frame = CGRectMake(170, 414, 130, 45);
}

- (void)sendMessage:(id)sender {
    NSString *date = @"2013-10-07T03:46:06Z";
    
    NSString *secret = @"8b35339112614d65";
    NSString *data = [@"13ac1988bb90dff8784743f5b1c0ebbb" stringByAppendingString:date];
    
    {
        int blocksize = 64;
        if ([secret length] > blocksize) {
            secret = [[[secret SHA1] toHexString] base64EncodedString];
        }
        
        NSString *ipad = [@"" str_pad:blocksize pad:@"6"];
        NSString *opad = [@"" str_pad:blocksize pad:@"\\"];
        NSString *k_ipad = [secret stringByXorWithString:ipad];
        NSString *k_opad = [secret stringByXorWithString:opad];
        
        [_bridge send:[[k_ipad stringByAppendingString:data] SHA1] responseCallback:^(id response) {
            NSString *sigKey = [[k_opad stringByAppendingString:[response objectForKey:@"Javascript Responds"]] SHA1];
            NSLog(@"________________ sig: %@", sigKey);
        }];
        
        //    return sha1($k_opad . pack("H*", sha1($k_ipad . $data)));
        //sig: d2bfa050f4ee677bfc8161b0f57339ec2078b9cd
    }
    
}

- (void)callHandler:(id)sender {
    NSDictionary* data = [NSDictionary dictionaryWithObject:@"Hi there, JS!" forKey:@"greetingFromObjC"];
    [_bridge callHandler:@"testJavascriptHandler" data:data responseCallback:^(id response) {
        NSLog(@"testJavascriptHandler responded: %@", response);
    }];
}

- (void)loadExamplePage:(UIWebView*)webView {
    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"ExampleApp" ofType:@"html"];
    NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    [webView loadHTMLString:appHtml baseURL:nil];
}

@end


@implementation NSString (Pack_Pad)

- (NSString*)str_pad:(int)lenght pad:(NSString*)strPad
{
    if (!strPad) return self;
    return [self stringByPaddingToLength:lenght withString:strPad startingAtIndex:0];
}


@end

