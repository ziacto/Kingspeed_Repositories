/***********************************************************************
 *	File name:	UITextViewPerformAction.m
 *	Project:
 *	Description:
 *  Author:
 *  Created:    on 3/1/12.
 *	Device:		Iphone vs IPad
 *  Company:	__MyCompanyName__
 *  Copyright:	2012 . All rights reserved.
 ***********************************************************************/

#import "UITextView+Actions.h"

@implementation UITextViewPerformAction

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    BOOL boolTemp = NO;
    if (action == @selector(cut:)||action == @selector(paste:)||action == @selector(copy:)||action == @selector(select:)||action == @selector(selectAll:)){
        boolTemp = [super canPerformAction:action withSender:sender];
    }
    
    return boolTemp;
}
@end
