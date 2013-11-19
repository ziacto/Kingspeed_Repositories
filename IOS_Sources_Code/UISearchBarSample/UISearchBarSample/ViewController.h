//
//  ViewController.h
//  UISearchBarSample
//
//  Created by Carmine on 26/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate>
{
    NSArray *originalData;
    NSMutableArray *searchData;
    
    UISearchBar *searchBar;
    UISearchDisplayController *searchDisplayController;
}

@end
