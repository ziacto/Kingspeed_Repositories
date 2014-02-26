/*
 *     Generated by class-dump 3.1.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2005 by Steve Nygard.
 */

#import "NSObject.h"

@class ChildWindowController, NSFont, NSMenu, NSMutableSet, ToDoListDatePanel, ToDoListView, ToDoMall;

@interface ToDoListController : NSObject
{
    ToDoListView *_listView;
    ToDoMall *_todoMall;
    id _delegate;
    NSMutableSet *_selection;
    NSFont *_font;
    NSFont *_boldFont;
    NSMenu *_headerMenu;
    NSMenu *_contextMenu;
    NSMenu *_calendarMenu;
    NSMenu *_priorityMenu;
    NSMenu *_dueDateMenu;
    NSMenu *_completeDateMenu;
    struct {
        unsigned int showAlertForPastDue:1;
        unsigned int showIncompleteInBold:1;
        unsigned int allowSubjectEditing:1;
        unsigned int allowDateDueEditing:1;
        unsigned int allowDateCompletedEditing:1;
        unsigned int allowPriorityEditing:1;
        unsigned int allowCalendarEditing:1;
        unsigned int isShowingSearchResults:1;
        unsigned int allowTableEditingWhenShowingDetails:1;
        unsigned int reserved:23;
    } _flags;
    BOOL _applyingUserDefaults;
    ChildWindowController *_childController;
    int _childWindowAttachmentRow;
    BOOL _userDidEditText;
    ToDoListDatePanel *_datePanel;
}

- (id)init;
- (void)awakeFromNib;
- (void)finalizeSetupAndAttachMall:(id)fp8;
- (void)setCalendarMenu:(id)fp8;
- (id)calendarMenu;
- (void)setPriorityMenu:(id)fp8;
- (id)priorityMenu;
- (void)dealloc;
- (id)delegate;
- (void)setDelegate:(id)fp8;
- (void)setMailboxUids:(id)fp8;
- (void)reload:(id)fp8;
- (id)selectedItems;
- (BOOL)selectionIsEditable;
- (id)font;
- (id)boldFont;
- (void)setFont:(id)fp8;
- (float)fontSize;
- (void)setFontSize:(float)fp8;
- (BOOL)showsAlertForPastDue;
- (void)setShowsAlertForPastDue:(BOOL)fp8;
- (BOOL)showsIncompleteItemsInBold;
- (void)sethowsIncompleteItemsInBold:(BOOL)fp8;
- (void)changeCalendar:(id)fp8;
- (void)changePriority:(id)fp8;
- (void)changeDateDue:(id)fp8;
- (void)changeDateComplete:(id)fp8;
- (void)removeAlarms:(id)fp8;
- (void)editAlarms:(id)fp8;
- (void)deleteSelected:(id)fp8;
- (void)toggleCompleted:(id)fp8;
- (void)showToDoMessageReference:(id)fp8 inSeparateWindow:(BOOL)fp12;
- (void)jumpToMessage:(id)fp8;
- (void)toggleColumnVisible:(id)fp8;
- (void)selectItems:(id)fp8;
- (void)selectToDo:(id)fp8;
- (void)editSelectedToDo:(id)fp8;
- (void)editSelectedToDoAndDisplayDetails:(id)fp8;
- (void)editToDo:(id)fp8;
- (void)jumpToiCal:(id)fp8;
- (void)clearSearch;
- (BOOL)isShowingSearchResults;
- (void)searchForString:(id)fp8 in:(int)fp12 withSelectedMailboxes:(id)fp16 withOptions:(int)fp20;
- (BOOL)validateMenuItem:(id)fp8;
- (void)menuNeedsUpdate:(id)fp8;
- (void)viewerPreferencesChanged:(id)fp8;
- (void)applySettingsFromDefaults:(id)fp8;
- (void)saveSettingsToDefaults:(id)fp8;
- (int)numberOfRowsInTableView:(id)fp8;
- (id)tableView:(id)fp8 objectValueForTableColumn:(id)fp12 row:(int)fp16;
- (void)tableView:(id)fp8 setObjectValue:(id)fp12 forTableColumn:(id)fp16 row:(int)fp20;
- (void)tableView:(id)fp8 sortDescriptorsDidChange:(id)fp12;
- (BOOL)tableView:(id)fp8 shouldMakeFocusedCell:(id)fp12;
- (BOOL)tableView:(id)fp8 writeRowsWithIndexes:(id)fp12 toPasteboard:(id)fp16;
- (unsigned int)tableView:(id)fp8 validateDrop:(id)fp12 proposedRow:(int)fp16 proposedDropOperation:(unsigned int)fp20;
- (BOOL)tableView:(id)fp8 acceptDrop:(id)fp12 row:(int)fp16 dropOperation:(unsigned int)fp20;
- (void)controlTextDidBeginEditing:(id)fp8;
- (void)controlTextDidChange:(id)fp8;
- (BOOL)control:(id)fp8 textView:(id)fp12 doCommandBySelector:(SEL)fp16;
- (void)moveLeft:(id)fp8;
- (void)toDoListContentsWillCompletelyChange;
- (void)toDoListContentsCompletelyChanged;
- (void)toDoListWasSorted;
- (void)toDosAddedAtIndexes:(id)fp8;
- (void)toDosDeletedAtIndexes:(id)fp8;
- (void)toDosUpdatedAtIndexes:(id)fp8;
- (BOOL)selectionShouldChangeInTableView:(id)fp8;
- (void)tableView:(id)fp8 didClickTableColumn:(id)fp12;
- (void)tableView:(id)fp8 didDragTableColumn:(id)fp12;
- (BOOL)tableView:(id)fp8 shouldEditTableColumn:(id)fp12 row:(int)fp16;
- (BOOL)tableView:(id)fp8 shouldSelectRow:(int)fp12;
- (BOOL)tableView:(id)fp8 shouldSelectTableColumn:(id)fp12;
- (id)tableView:(id)fp8 toolTipForCell:(id)fp12 rect:(struct _NSRect *)fp16 tableColumn:(id)fp20 row:(int)fp24 mouseLocation:(struct _NSPoint)fp28;
- (void)tableView:(id)fp8 willDisplayCell:(id)fp12 forTableColumn:(id)fp16 row:(int)fp20;
- (void)tableViewBoundsDidChange:(id)fp8;
- (void)tableViewFrameDidChange:(id)fp8;
- (void)tableViewColumnDidMove:(id)fp8;
- (void)tableViewColumnDidResize:(id)fp8;
- (void)tableViewSelectionDidChange:(id)fp8;
- (void)sortByTagOfSender:(id)fp8;
- (void)makeToDoListFirstResponder;
- (id)detailsWindowController:(id)fp8 undoManagerForWindow:(id)fp12;
- (void)displayAlarmsWindowForRows:(id)fp8;
- (void)displayDetailsWindowForRow:(int)fp8;
- (void)_childController;
- (BOOL)childWindowIsVisible;
- (void)closeChildWindow;
- (id)childWindowController;
- (void)setChildWindowController:(id)fp8;
- (void)windowDidSelectNextKeyView:(id)fp8;
- (void)childWindowDidBecomeKey:(id)fp8;
- (void)childWindowWillClose:(id)fp8;
- (void)listViewBoundsOrFrameDidChange:(id)fp8;
- (struct _NSPoint)childWindowController:(id)fp8 bestFrameOriginForWindow:(id)fp12;
- (void)cut:(id)fp8;
- (void)copy:(id)fp8;
- (void)paste:(id)fp8;
- (BOOL)canInsertFromPasteboard;

@end
