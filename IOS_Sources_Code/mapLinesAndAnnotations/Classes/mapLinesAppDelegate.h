//
//  mapLinesAppDelegate.h
//  mapLines
//
//  Created by Craig on 4/12/09.
//  Copyright Craig Spitzkoff 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class mapLinesViewController;

@interface mapLinesAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    mapLinesViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet mapLinesViewController *viewController;

@end

