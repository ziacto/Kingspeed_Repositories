//
//  AddUserInforView.m
//  TestCoreData
//
//  Created by iMac02 on 9/8/2012.
//  Copyright (c) 2012 iMac02. All rights reserved.
//

#import "AddUserInforView.h"

@interface AddUserInforView ()

@end

@implementation AddUserInforView
@synthesize delegate = _delegate;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize userInfor = _userInfor;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _pickerDate.date = [NSDate date];
    _txfAge.inputView = _pickerDate;
    
    if (_userInfor) {
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        
        [_txfAge setText:[dateFormatter stringFromDate:_userInfor.age]];
        [_txvAddress setText:_userInfor.address];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction) updatePickerDate:(id) sender
{
    NSDate *date = [_pickerDate date];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    
    [_txfAge setText:[dateFormatter stringFromDate:date]];
}


- (IBAction)save:(id)sender
{
    if (!__managedObjectContext) return;
    if (!_userInfor) _userInfor = [NSEntityDescription insertNewObjectForEntityForName:@"UserInfor" inManagedObjectContext:self.managedObjectContext];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSDate* date = [dateFormatter dateFromString:_txfAge.text];
    
    _userInfor.address = _txvAddress.text;
    _userInfor.age = date;
    
    [self.managedObjectContext save:nil];  // write to database
    
    if (_delegate && [_delegate respondsToSelector:@selector(addUserInforView:withInfor:)]) {
        [_delegate addUserInforView:self withInfor:_userInfor];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
//    _currentTextField = textField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_txfAge resignFirstResponder];
    [_txvAddress resignFirstResponder];
}

@end
