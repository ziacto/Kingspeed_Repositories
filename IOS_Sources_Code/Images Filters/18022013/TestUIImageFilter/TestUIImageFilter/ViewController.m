//
//  ViewController.m
//  TestUIImageFilter
//
//  Created by iMac02 on 21/2/2013.
//  Copyright (c) 2013 iMac02. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

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


- (IBAction)sliderDidChangeValue:(UISlider*)sender
{
    _imageView.image = [_imageView.image changeImageBrightness:sender.value];
}

@end
