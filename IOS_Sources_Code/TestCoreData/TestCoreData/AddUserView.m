//
//  AddRoleTVC.m
//  Staff Manager
//
//  Created by Tim Roadley on 9/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddUserView.h"

@interface AddUserView ()
{
    UITextField *_currentTextField;
}

@end

@implementation AddUserView

@synthesize managedObjectContext = __managedObjectContext;
@synthesize addUser = _addUser;

- (void)viewDidUnload
{
    txFName = nil;
    txFUserName = nil;
    txFPass = nil;
    txFEmail = nil;
    [super viewDidUnload];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    if(_addUser) {
        txFName.text = _addUser.name;
        txFUserName.text = _addUser.userName;
        txFPass.text = _addUser.password;
        txFEmail.text = _addUser.email;
    }
}

- (IBAction)addMoreInfor:(id)sender
{
    AppDelegate *appDelegate = [AppDelegate shareAppdelegate];
    AddUserInforView *userInforView = [[AddUserInforView alloc] initWithNibName:NSStringFromClass([AddUserInforView class]) bundle:nil];
    userInforView.managedObjectContext = appDelegate.dataController.managedObjectContext;
    if (_addUser) userInforView.userInfor = _addUser.userinfor;
    userInforView.delegate = self;
    [self.navigationController pushViewController:userInforView animated:YES];
}

- (void) addUserInforView:(AddUserInforView *)controller withInfor:(UserInfor *)userInfor
{
    _addUser.userinfor = userInfor;
}

- (IBAction)save:(id)sender
{
    if (!__managedObjectContext) return;
    if (!_addUser)  _addUser = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.managedObjectContext];
    _addUser.name = txFName.text;
    _addUser.userName = txFUserName.text;
    _addUser.password = txFPass.text;
    _addUser.email = txFEmail.text;
    
    [_addUser.managedObjectContext save:nil];  // write to database
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _currentTextField = textField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_currentTextField) {
        [_currentTextField resignFirstResponder];
    }
}

@end


