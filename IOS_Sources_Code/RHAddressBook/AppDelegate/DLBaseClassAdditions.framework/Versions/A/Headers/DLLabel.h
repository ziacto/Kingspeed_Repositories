/***********************************************************************
 *	File name:	___________
 *	Project:	DLBaseClassFramework
 *	Description:
 *  Author:		Dat Nguyen Mau
 *  Created:    on 9/4/2013.
 *	Device:		Iphone vs IPad
 *  Company:	__MyCompanyName__
 *  Copyright:	2012 . All rights reserved.
 ***********************************************************************/

#import <UIKit/UIKit.h>

typedef enum
{
    DLTextAlignmentTopLeft = 0,
    DLTextAlignmentTopCenter,
    DLTextAlignmentTopRight,
    
    DLTextAlignmentMiddleLeft,      // default
    DLTextAlignmentMiddleCenter,
    DLTextAlignmentMiddleRight,
    
    DLTextAlignmentBottomLeft,
    DLTextAlignmentBottomCenter,
    DLTextAlignmentBottomRight,
    
} DLTextAlignment;

@interface DLLabel : UILabel

// use this for alignment text in DLLabel
// this is the best label class for alignment text with Hiragino font on all IOS version
// not use textAlignment of UILabel
// the textAlignment property will be set according to dlTextAlignment
@property (nonatomic,assign) DLTextAlignment dlTextAlignment;

@end



