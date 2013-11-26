/***********************************************************************
 *	File name:	fasdg.h
 *	Project:	Universal
 *	Description:
 *  Author:		Dat Nguyen Mau
 *  Created:    on 3/1/12.
 *	Device:		Iphone vs IPad
 *  Company:	__MyCompanyName__
 *  Copyright:	2012 . All rights reserved.
 ***********************************************************************/

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

#import "SubViewController.h"

@interface MainViewController : DLBaseIOS7ViewController <ABNewPersonViewControllerDelegate,UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>
{
    IBOutlet UITableView *_tableAddress;
    
    NSArray *_listAddressBook;
    NSArray *_listSearchResult;
    
    NSIndexPath *_selectedIndexPath;
}

/*************************************************************/
/*************************************************************/
#pragma mark -
#pragma mark Variables

/*************************************************************/
/*************************************************************/
#pragma mark -
#pragma mark FUNCTIONS FOR LOAD
/*************************************************************/
/*************************************************************/
#pragma mark -
#pragma mark FUNCTIONS FOR EVENTS HANDLE

/*************************************************************/
/*************************************************************/

@end
