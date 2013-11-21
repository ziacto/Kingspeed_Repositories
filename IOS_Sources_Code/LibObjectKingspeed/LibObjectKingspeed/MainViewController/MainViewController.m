//
//  ViewController.m
//  LibObjectKingspeed
//
//  Created by iMac02 on 24/10/2012.
//  Copyright (c) 2012 iMac02. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"__________________________ %@", [@"Album_1" base64Encoded]);
}

@end
