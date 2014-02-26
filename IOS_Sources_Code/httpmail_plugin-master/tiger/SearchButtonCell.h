/*
 *     Generated by class-dump 3.0.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004 by Steve Nygard.
 */

#import "NSButtonCell.h"

@interface SearchButtonCell : NSButtonCell
{
    BOOL _mouseInside;
    struct _NSSize _titleSize;
}

- (BOOL)_enablesOnWindowChangedKeyState;
- (BOOL)_getButtonImageParts:(id *)fp8:(id *)fp12:(id *)fp16;
- (id)_highlightTextColor;
- (BOOL)_needRedrawOnWindowChangedKeyState;
- (BOOL)_needsRedrawOnMouseInsideChange;
- (id)_normalTextColor;
- (BOOL)_shouldShowRollovers;
- (id)_textAttributes;
- (id)_textWithShadowAttributes;
- (id)attributedTitle;
- (float)buttonHeight;
- (struct _NSSize)cellSizeForBounds:(struct _NSRect)fp8;
- (void)drawInteriorWithFrame:(struct _NSRect)fp8 inView:(id)fp24;
- (void)drawWithFrame:(struct _NSRect)fp8 inView:(id)fp24;
- (id)initTextCell:(id)fp8;
- (BOOL)isEnabled;
- (BOOL)isPressed;
- (BOOL)isSelected;
- (void)mouseEntered:(id)fp8;
- (void)mouseExited:(id)fp8;
- (void)setTitle:(id)fp8;
- (struct _NSRect)titleRectForBounds:(struct _NSRect)fp8;

@end
