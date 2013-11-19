/***********************************************************************
 *	File name:	ObjectViewController.m
 *	Project:	Photo Albums
 *	Description:
 *  Author:		Dat Nguyen Mau
 *  Created:    on 3/1/12.
 *	Device:		Iphone vs IPad
 *  Company:	__MyCompanyName__
 *  Copyright:	2012 . All rights reserved.
 ***********************************************************************/

#import "ObjectViewController.h"

@implementation ObjectViewController

-(void)viewDidLoad
{
	self.navigationController.navigationBar.tintColor = COLOR(2, 100, 162);
	[self.view setBackgroundColor:COLOR(234,237,250)];
	
	UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	btn.frame = CGRectMake(20, 20, 100, 40);
	btn.backgroundColor = [UIColor clearColor];
	[btn setTitle:@"Item" forState:UIControlStateNormal];
	[btn addTarget:self action:@selector(openView) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:btn];
}

-(void)openView
{
	UIViewController *targetViewController = [[ObjectViewController alloc] init];
    [self.navigationController pushViewController:targetViewController animated:YES];
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
}

@end
