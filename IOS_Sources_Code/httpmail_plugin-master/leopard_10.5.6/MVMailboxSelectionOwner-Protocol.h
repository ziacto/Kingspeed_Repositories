/*
 *     Generated by class-dump 3.1.2.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2007 by Steve Nygard.
 */

@protocol MVMailboxSelectionOwner
- (id)selectedMailboxes;
- (id)selectedMailbox;
- (id)sortedSectionItemsForTimeMachine;
- (BOOL)isSelectedMailboxSpecial;
- (void)selectPathsToMailboxes:(id)fp8;
- (BOOL)mailboxIsExpanded:(id)fp8;
- (BOOL)sectionIsExpanded:(id)fp8;
- (void)revealMailbox:(id)fp8;
- (id)mailboxSelectionWindow;
@end
