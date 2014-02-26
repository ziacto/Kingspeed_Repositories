/*
 *     Generated by class-dump 3.0.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004 by Steve Nygard.
 */

#import "NSObject.h"

@class NSMutableArray, NSMutableDictionary, NSTimer;

@interface AttachmentManager : NSObject
{
    NSMutableArray *_openedAttachmentPaths;
    NSMutableDictionary *_openedAttachmentMessageIDs;
    NSMutableArray *_messageIDPurgeQueue;
    NSTimer *_purgeTimer;
    int _purgeBehavior;
}

+ (void)_registerDefaults;
+ (BOOL)attachmentPurgingIsEnabled;
+ (id)openedAttachmentListPath;
+ (id)sharedInstance;
- (void)_confirmDownloadSheetDidEnd:(id)fp8 returnCode:(int)fp12 contextInfo:(struct SheetContext *)fp16;
- (void)_confirmExecutableSheetDidEnd:(id)fp8 alertReturn:(int)fp12 context:(id)fp16;
- (void)_downloadCompleted:(id)fp8;
- (void)_gatekeeperApprovalDidEnd:(id)fp8;
- (void)_openFromDownloadedNotification:(id)fp8;
- (id)_savePanelForFilename:(id)fp8 directory:(id)fp12;
- (int)attachmentPurgingBehavior;
- (void)beginLoadingInlineAttachmentsInView:(id)fp8;
- (void)cancelLoadingInlineAttachmentsInView:(id)fp8;
- (void)chooseApplicationToOpenAttachments:(id)fp8 needsSave:(BOOL)fp12 window:(id)fp16 delegate:(id)fp20;
- (void)configureOpenWithMenu:(id)fp8 forAttachments:(id)fp12;
- (id)contextualMenuForAttachments:(id)fp8 forEditing:(BOOL)fp12;
- (void)dealloc;
- (void)disableAttachmentPurging;
- (BOOL)dragAbortedBecauseOneOrMoreAttachmentsNotDownloaded:(id)fp8 inView:(id)fp12;
- (BOOL)dragAttachments:(id)fp8 startPoint:(struct _NSPoint)fp12 view:(id)fp20 event:(id)fp24 image:(id)fp28 delegate:(id)fp32;
- (void)draggedAttachmentsWereGatekeeperApproved:(id)fp8;
- (void)enableAttachmentPurging;
- (BOOL)gatekeeperApprovalForAttachments:(id)fp8 draggedFromView:(id)fp12 delegate:(id)fp16;
- (BOOL)gatekeeperApprovalForAttachments:(id)fp8 target:(id)fp12 didEndSelector:(SEL)fp16 userInfo:(id)fp20;
- (id)init;
- (void)initializeAttachmentPurging;
- (void)openAttachments:(id)fp8 applicationURL:(struct __CFURL *)fp12 window:(id)fp16 delegate:(id)fp20;
- (void)openAttachmentsWithDictionary:(id)fp8;
- (BOOL)openFileAtPath:(id)fp8 withApplication:(id)fp12 stayInBackground:(BOOL)fp16;
- (BOOL)openFileURL:(id)fp8 stayInBackground:(BOOL)fp12 window:(id)fp16;
- (BOOL)openInvitationAttachments:(id)fp8 openImmediately:(BOOL)fp12;
- (BOOL)openTemporaryAttachments:(id)fp8 applicationBundle:(id)fp12 window:(id)fp16;
- (id)pathsForDraggedAttachments:(id)fp8 fromView:(id)fp12;
- (void)prepareAttributedString:(id)fp8 forPrinter:(id)fp12;
- (void)runSavePanelForAttachments:(id)fp8 window:(id)fp12;
- (void)runSavePanelForAttachments:(id)fp8 window:(id)fp12 gatekeeperApproved:(BOOL)fp16;
- (void)runSavePanelForAttachmentsFromDictionary:(id)fp8;
- (void)saveAttachments:(id)fp8 toDirectory:(id)fp12 makePathsUnique:(BOOL)fp16 window:(id)fp20;
- (void)saveAttachments:(id)fp8 toDirectory:(id)fp12 makePathsUnique:(BOOL)fp16 window:(id)fp20 gatekeeperApproved:(BOOL)fp24;
- (void)saveAttachmentsFromMessages:(id)fp8 window:(id)fp12;
- (void)saveAttachmentsToDirectoryMakePathsUniqueWindowFromDictionary:(id)fp8;
- (void)saveAttachmentsToDownloadDirectory:(id)fp8 window:(id)fp12;
- (void)saveAttachmentsToDownloadDirectory:(id)fp8 window:(id)fp12 gatekeeperApproved:(BOOL)fp16;
- (void)saveAttachmentsToDownloadDirectoryFromDictionary:(id)fp8;
- (void)setAttachmentPurgingBehavior:(int)fp8;
- (id)uniquedPathForFile:(id)fp8 inDirectory:(id)fp12;

@end
