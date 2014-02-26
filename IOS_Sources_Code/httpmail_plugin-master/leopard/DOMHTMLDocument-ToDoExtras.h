/*
 *     Generated by class-dump 3.1.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2005 by Steve Nygard.
 */

#import "DOMHTMLDocument.h"

@interface DOMHTMLDocument (ToDoExtras)
- (id)stripFrozenToDoElement:(id)fp8;
- (id)thawFrozenToDoElement:(id)fp8 todo:(id)fp12 displayReference:(BOOL)fp16;
- (id)todoElementById:(id)fp8;
- (void)freezeToDoElement:(id)fp8;
- (void)freezeToDos;
- (id)todoPriorityForKey:(int)fp8;
- (id)createFrozenToDoElement:(id)fp8 todoElement:(id)fp12;
- (void)resumeToDos;
- (void)pauseToDos;
- (id)createAddNotesButtonElement;
- (id)createEmbedElement:(id)fp8 mode:(id)fp12 class:(id)fp16 id:(id)fp20 todoID:(id)fp24;
- (id)addNotesButtonElement;
- (id)addNotesContainerElement;
- (id)createToDoElement:(id)fp8 displayReference:(BOOL)fp12;
@end
