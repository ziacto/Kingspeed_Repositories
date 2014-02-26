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

#import "ProjectXcode_4_1ViewController.h"

@implementation ProjectXcode_4_1ViewController

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - View lifecycle
#pragma mark -
/*************************************************************/
/*************************************************************/
#pragma mark DEALLOC
- (void) dealloc
{
    [super dealloc];
}

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView
 {
 }
 */


#pragma mark -
#pragma mark VIEW DIDLOAD
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark -
#pragma mark VIEW APPEAR
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

#pragma mark -
#pragma mark VIEW DISAPPEAR
- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}
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
