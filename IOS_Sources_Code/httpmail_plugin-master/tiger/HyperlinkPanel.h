/*
 *     Generated by class-dump 3.0.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004 by Steve Nygard.
 */

#import "NSObject.h"

@class DOMHTMLAnchorElement, EditingMessageWebView, NSButton, NSString, NSTextField;

@interface HyperlinkPanel : NSObject
{
    NSTextField *_linkTextField;
    NSButton *_okButton;
    NSButton *_removeLinkButton;
    EditingMessageWebView *_currentWebView;
    DOMHTMLAnchorElement *_selectedAnchor;
    NSString *_selectedText;
}

+ (void)runPanelForView:(id)fp8;
- (void)dealloc;
- (id)init;
- (void)orderOutPanel:(id)fp8;

@end
