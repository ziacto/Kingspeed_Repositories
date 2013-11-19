//
//  SMSSendViewController.m
//  SMSSend
//
//  Created by Chakra on 30/06/10.
//  Copyright Chakra Interactive Pvt Ltd 2010. All rights reserved.
//

#import "SMSSendViewController.h"

@implementation SMSSendViewController
@synthesize SMS;



/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	UIButton *smsButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	smsButton.frame = CGRectMake(97.0, 301.0, 125.0, 37.0);
	smsButton.adjustsImageWhenDisabled = YES;
	
	[smsButton setTitle:@"SMS Send" forState:UIControlStateNormal];
	[smsButton setTitleColor:[UIColor colorWithWhite:0.000 alpha:1.000] forState:UIControlStateNormal];
	[smsButton setTitleShadowColor:[UIColor colorWithWhite:0.000 alpha:1.000] forState:UIControlStateNormal]; 
	[smsButton addTarget:self action:@selector(ComposerSheet) forControlEvents:UIControlEventTouchUpInside];
	
	SMS = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 360.0, 280.0, 29.0)];
	SMS.frame = CGRectMake(20.0, 360.0, 280.0, 29.0);
	SMS.adjustsFontSizeToFitWidth = YES;
	SMS.hidden = YES;
	SMS.text = @"";
	SMS.userInteractionEnabled = NO;
	
	[self.view addSubview:smsButton];  
	[self.view addSubview:SMS];  
   }



-(void)ComposerSheet 
{
	MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
	picker.messageComposeDelegate = self;
	
	picker.recipients = [NSArray arrayWithObject:@"84986343983"];
	picker.body = @"iPhone OS4";
	
	if(picker)[self presentModalViewController:picker animated:YES];
	[picker release];
	
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
	SMS.hidden = NO;
	switch (result)
	{
		case MessageComposeResultCancelled:
			SMS.text = @"Result: canceled";
			NSLog(@"Result: canceled");
			break;
		case MessageComposeResultSent:
			SMS.text = @"Result: sent";
			NSLog(@"Result: sent");
			break;
		case MessageComposeResultFailed:
			SMS.text = @"Result: failed";
			NSLog(@"Result: failed");
			break;
		default:
			SMS.text = @"Result: not sent";
			NSLog(@"Result: not sent");
			break;
	}
	
	[self dismissModalViewControllerAnimated:YES];
	
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end
