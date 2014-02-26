//
//  AddUserInforView.h
//  TestCoreData
//
//  Created by iMac02 on 9/8/2012.
//  Copyright (c) 2012 iMac02. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "UserInfor.h"

@class AddUserInforView;
@protocol AddUserInforViewDelegate <NSObject>
- (void) addUserInforView:(AddUserInforView *)controller withInfor:(UserInfor*) userInfor;
@end

@interface AddUserInforView : UIViewController <UITextFieldDelegate, UITextViewDelegate>
{
    IBOutlet UITextView *_txvAddress;
    IBOutlet UITextField *_txfAge;
    
    IBOutlet UIDatePicker *_pickerDate;
}
@property (nonatomic, assign) id <AddUserInforViewDelegate> delegate;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) UserInfor *userInfor;

- (IBAction) updatePickerDate:(id) sender;

- (IBAction)save:(id)sender;

@end
