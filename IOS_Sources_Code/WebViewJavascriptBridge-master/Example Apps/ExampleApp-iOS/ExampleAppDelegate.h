#import <UIKit/UIKit.h>
#import "WebViewJavascriptBridge.h"
#import <DLBaseClassAdditions/DLBaseClassAdditions.h>

@interface ExampleAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) WebViewJavascriptBridge *javascriptBridge;

- (void)renderButtons:(UIWebView*)webView;
- (void)loadExamplePage:(UIWebView*)webView;

@end


@interface NSString (Pack_Pad)
- (NSString*)str_pad:(int)lenght pad:(NSString*)strPad;

@end

