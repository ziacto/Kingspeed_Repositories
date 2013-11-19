//
//  SMSSendAppDelegate.h
//  SMSSend
//
//  Created by Chakra on 30/06/10.
//  Copyright Chakra Interactive Pvt Ltd 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SMSSendViewController;

@interface SMSSendAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    SMSSendViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet SMSSendViewController *viewController;

@end

