//
//  SMSSendViewController.h
//  SMSSend
//
//  Created by Chakra on 30/06/10.
//  Copyright Chakra Interactive Pvt Ltd 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>

@interface SMSSendViewController : UIViewController <MFMessageComposeViewControllerDelegate> {
	
	UILabel *SMS;
}

@property (nonatomic,retain) UILabel *SMS;

-(void)ComposerSheet;

@end

