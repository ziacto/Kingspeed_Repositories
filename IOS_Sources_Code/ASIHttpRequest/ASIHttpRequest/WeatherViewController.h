//
//  WeatherViewController.h
//  ASIHttpRequest
//
//  Created by himawari on 8/6/13.
//  Copyright (c) 2013 Himawari. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"

@class ASIHTTPRequest;

@interface WeatherViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, ASIHTTPRequestDelegate>
{
    ASIHTTPRequest *request;
}

//- (IBAction)getDataUrl:(id)sender;

@end
