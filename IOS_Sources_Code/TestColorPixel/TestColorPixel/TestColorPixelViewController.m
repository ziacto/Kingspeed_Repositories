//
//  TestColorPixelViewController.m
//  TestColorPixel
//
//  Created by iMac02 on 12/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TestColorPixelViewController.h"

@implementation TestColorPixelViewController

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}


- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.anyObject;
    CGPoint location = [touch locationInView:testColor];
    
    if ([touch view] == testColor) {
        
        NSLog(@"====> %@",[ImageColorDNM getPixelColorAtLocation:location forImage:testColor.image]);
        NSLog(@"----> %@",[ImageColorDNM getPixelColorAtLocationWithoutCGContext:location forImage:testColor.image]);
    }
}

@end
