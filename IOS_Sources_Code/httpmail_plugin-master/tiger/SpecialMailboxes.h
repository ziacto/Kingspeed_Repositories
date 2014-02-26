/*
 *     Generated by class-dump 3.0.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004 by Steve Nygard.
 */

#import "NSObject.h"

@class NSButton, NSPopUpButton, NSView;

@interface SpecialMailboxes : NSObject
{
    NSView *_view;
    NSPopUpButton *_sentMessagesAgePopup;
    NSPopUpButton *_junkAgePopup;
    NSPopUpButton *_trashAgePopup;
    NSButton *_trashCheckbox;
}

+ (id)specialMailboxesForAccountClass:(Class)fp8;
- (void)awakeFromNib;
- (void)dealloc;
- (BOOL)isAccountInformationDirty:(id)fp8;
- (BOOL)moveDeletedMailToTrash;
- (void)moveToTrashClicked:(id)fp8;
- (void)postSpecialMailboxesDidChangeNotification:(id)fp8;
- (void)setUIElementsEnabled:(BOOL)fp8;
- (BOOL)setupAccountFromValuesInUI:(id)fp8;
- (void)setupUIFromValuesInAccount:(id)fp8;
- (id)view;

@end
