/***********************************************************************
 *	File name:	MacroFunctionFolderAlbum.h
 *	Project:	Photo Albums
 *	Description:
 *  Author:		Dat Nguyen Mau
 *  Created:    on 3/1/12.
 *	Device:		Iphone vs IPad
 *  Company:	__MyCompanyName__
 *  Copyright:	2012 . All rights reserved.
 ***********************************************************************/

#import <UIKit/UIKit.h>
#import "MacroObjectLauncher.h"

@interface ObjectsPageControl : UIPageControl {
	NSInteger currentPage;
	NSInteger numberOfPages;
    NSInteger maxNumberOfPages;
	BOOL hidesForSinglePage;
}

@property (nonatomic) NSInteger currentPage;
@property (nonatomic) NSInteger numberOfPages;
@property (nonatomic) NSInteger maxNumberOfPages;
@property (nonatomic) BOOL hidesForSinglePage;
@property (nonatomic, retain) UIColor *inactivePageColor;
@property (nonatomic, retain) UIColor *activePageColor;

@end
