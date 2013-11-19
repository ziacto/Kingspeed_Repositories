//
//  mapLinesAppDelegate.m
//  mapLines
//
//  Created by Craig on 4/12/09.
//  Copyright Craig Spitzkoff 2009. All rights reserved.
//

#import "mapLinesAppDelegate.h"
#import "mapLinesViewController.h"

@implementation mapLinesAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
	
	
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
