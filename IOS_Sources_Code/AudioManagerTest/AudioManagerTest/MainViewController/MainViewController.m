//
//  ViewController.m
//  AudioManagerTest
//
//  Created by Nguyen Mau Dat on 7/22/13.
//  Copyright (c) 2013 Nguyen Mau Dat. All rights reserved.
//

#import "MainViewController.h"
#import "SimpleAudioEngine_objc.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    SimpleAudioEngine *__audioEngine = [SimpleAudioEngine sharedEngine];
    [__audioEngine playBackgroundMusic:@"04_subetenomononi.aif" loop:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
