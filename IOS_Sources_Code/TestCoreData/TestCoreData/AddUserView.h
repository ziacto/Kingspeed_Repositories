//
//  AddRoleTVC.h
//  Staff Manager
//
//  Created by Tim Roadley on 9/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddUserInforView.h"
#import "User.h"

@interface AddUserView : UIViewController <UITextFieldDelegate, AddUserInforViewDelegate>
{
    IBOutlet UITextField *txFName;
    IBOutlet UITextField *txFUserName;
    IBOutlet UITextField *txFPass;
    IBOutlet UITextField *txFEmail;
}

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (retain, nonatomic) User *addUser;

- (IBAction)addMoreInfor:(id)sender;
- (IBAction)save:(id)sender;

@end
