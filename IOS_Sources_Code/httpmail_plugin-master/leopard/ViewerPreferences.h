/*
 *     Generated by class-dump 3.1.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2005 by Steve Nygard.
 */

#import "NSPreferencesModule.h"

@class NSButton, NSColorWell, NSMutableArray, NSPanel, NSPopUpButton, NSTableView;

@interface ViewerPreferences : NSPreferencesModule
{
    NSButton *_highlightThreadCheckbox;
    NSColorWell *_threadHighlightColorWell;
    NSButton *loadURLsSwitch;
    NSButton *showPresenceSwitch;
    NSButton *showUnreadMessagesInBoldSwitch;
    NSButton *useSmartAddressesSwitch;
    NSPopUpButton *headerDetailPopup;
    NSTableView *customHeaderTable;
    NSButton *addHeaderButton;
    NSButton *removeHeaderButton;
    NSPanel *customHeaderPanel;
    NSMutableArray *filteredHeaders;
    int nextRowToSelectAfterEditing;
    BOOL isEditingHeader;
}

+ (void)postViewingPreferencesChanged;
+ (void)postPresencePreferenceChanged;
- (void)awakeFromNib;
- (void)dealloc;
- (BOOL)isResizable;
- (id)titleForIdentifier:(id)fp8;
- (id)windowTitle;
- (void)_initializeHeaderDetailLevelPopup;
- (void)_updateCustomHeaderUI;
- (void)initializeFromDefaults;
- (void)loadURLsClicked:(id)fp8;
- (void)showPresenceClicked:(id)fp8;
- (void)useSmartAddressesClicked:(id)fp8;
- (void)editCustomHeadersClicked;
- (void)_customHeaderSheetDidEnd:(id)fp8 returnCode:(int)fp12 contextInfo:(void *)fp16;
- (void)_headerTableBeganEditing:(id)fp8;
- (void)_headerTableEndedEditing:(id)fp8;
- (void)_removeInvalidHeaders;
- (void)_endEditingHeader;
- (void)okClicked:(id)fp8;
- (void)cancelClicked:(id)fp8;
- (void)removeHeaderClicked:(id)fp8;
- (void)addHeaderClicked:(id)fp8;
- (int)numberOfRowsInTableView:(id)fp8;
- (id)tableView:(id)fp8 objectValueForTableColumn:(id)fp12 row:(int)fp16;
- (void)tableView:(id)fp8 setObjectValue:(id)fp12 forTableColumn:(id)fp16 row:(int)fp20;
- (void)headerDetailLevelChanged:(id)fp8;
- (void)highlightThreadClicked:(id)fp8;
- (void)threadHighlightColorChanged:(id)fp8;
- (void)showUnreadMessagesInBoldChanged:(id)fp8;

@end
