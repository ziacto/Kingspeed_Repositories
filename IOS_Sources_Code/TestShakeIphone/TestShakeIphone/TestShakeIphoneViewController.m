//
//  TestShakeIphoneViewController.m
//  TestShakeIphone
//
//  Created by iMac02 on 10/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TestShakeIphoneViewController.h"


@implementation TestShakeIphoneViewController


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    label1.hidden = YES;
    label2.hidden = YES;
    [self becomeFirstResponder];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [self resignFirstResponder];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Shake Functions

-(BOOL)canBecomeFirstResponder {
    return YES;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}



- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if(event.type == UIEventSubtypeMotionShake)
    {
        NSLog(@"begin shake");
        [self.view setBackgroundColor:[UIColor grayColor]];
        label1.text = @"Begin Shake";
        label1.hidden = NO;
    }
    [super motionBegan:motion withEvent:event];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	
	if (event.type == UIEventSubtypeMotionShake) {
		NSLog(@"user shaked");
        label2.text = @"End Shake";
        label2.hidden = NO;
		
	}
}
- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"user shaked");
    label2.text = @"Cancel Shake";
    label2.hidden = NO;
}

//======================================================================
                        // End Shake Functions.
//----------------------------------------------------------------------



@end
