/***********************************************************************
 *	File name:	ObjectsPagesViewController.h
 *	Project:	Photo Albums
 *	Description:
 *  Author:		Dat Nguyen Mau
 *  Created:    on 3/1/12.
 *	Device:		Iphone vs IPad
 *  Company:	__MyCompanyName__
 *  Copyright:	2012 . All rights reserved.
 ***********************************************************************/

#import <UIKit/UIKit.h>
#import "ObjectsPagesView.h"

@class ObjectsPagesView;

@interface ObjectsPagesViewController : UIViewController <ObjectsPagesViewDelegate, UINavigationControllerDelegate> {
}

@property (nonatomic, retain) UINavigationController *launcherNavigationController;
@property (nonatomic, retain) ObjectsPagesView *launcherView;
@property (nonatomic, retain) NSMutableDictionary *appControllers;

-(BOOL)hasSavedLauncherItems;
-(void)clearSavedLauncherItems;

@end
