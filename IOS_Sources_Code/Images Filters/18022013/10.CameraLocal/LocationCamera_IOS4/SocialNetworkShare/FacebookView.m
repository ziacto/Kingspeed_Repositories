/***********************************************************************
 *	File name:	SocialSharingClass.h
 *	Project:	Facebook+Twitter
 *	Description:
 *  Author:		Dat Nguyen Mau
 *  Created:    on 8/11/2012.
 *	Device:		Iphone vs IPad
 *  Company:	__MyCompanyName__
 *  Copyright:	2012 . All rights reserved.
 ***********************************************************************/

#import "FacebookView.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@interface FacebookView () <FBLoginViewDelegate>
{
    IBOutlet UIBarButtonItem *_btnPost;
    IBOutlet UIBarButtonItem *_btnBack;
    
    IBOutlet UILabel *_labelUserName;
    IBOutlet FBProfilePictureView *_profilePicture;
    id<FBGraphUser> _loggedInUser;
    
    NSInteger _indexPosted;
    
    IBOutlet UIImageView *_imgVPost;
}

- (IBAction) backActionClick;
- (IBAction) postToFacebookClick;

@end

@implementation FacebookView

@synthesize imagesPathForPost = _imagesPathForPost;

+ (FacebookView*)shareInstanceWithXib
{
    if ([[UIScreen mainScreen] bounds].size.height >= 568.) {
        return [[self alloc] initWithNibName:@"FacebookView_568" bundle:nil];
    }
    else {
        return [[self alloc] initWithNibName:@"FacebookView" bundle:nil];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

# pragma mark textField delegate
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[_txvContentPost resignFirstResponder];
}

- (IBAction) backActionClick
{
    [self dismissModalViewControllerAnimated:YES];
}


#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _txvContentPost.delegate = self;
    _btnPost.enabled = NO;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [UIApplication sharedApplication].statusBarHidden = YES;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillAppear:(BOOL)animated 
{    
	[super viewWillAppear:animated];
    
    self.navigationController.toolbarHidden = YES;
    
    _txvContentPost.layer.cornerRadius = 10;
    _txvContentPost.layer.borderColor = [[UIColor colorWithRed:160./255. green:160./255. blue:160./255. alpha:1.] CGColor];
    _txvContentPost.layer.borderWidth = 2.5;
    
    if (![AppDelegate shareApp].facebookLoginView) {
        [AppDelegate shareApp].facebookLoginView = [[FBLoginView alloc] init];
    }
    
    [AppDelegate shareApp].facebookLoginView.frame = CGRectOffset([AppDelegate shareApp].facebookLoginView.frame, 5, 5);
    [AppDelegate shareApp].facebookLoginView.delegate = self;
    
    [self.view addSubview:[AppDelegate shareApp].facebookLoginView];
    
//    [[AppDelegate shareApp].facebookLoginView sizeToFit];
    [AppDelegate shareApp].facebookLoginView.center = CGPointMake(_profilePicture.center.x, CGRectGetMaxY(_profilePicture.frame) + [AppDelegate shareApp].facebookLoginView.frame.size.height/2 + 15);
    
    for (id v in [AppDelegate shareApp].facebookLoginView.subviews) {
        if ([v isKindOfClass:[UILabel class]]) {
            UILabel *lbl = (UILabel*)v;
            lbl.center = CGPointMake(55, 15);
            lbl.frame = CGRectMake(lbl.frame.origin.x-3, lbl.frame.origin.y, lbl.frame.size.width + 20, lbl.frame.size.height);
            lbl.font = [UIFont boldSystemFontOfSize:14];
        }
    }
    
    if (_imagesPathForPost.count > 0) {
        UIImage *imagePost = nil;
        id object = [_imagesPathForPost objectAtIndex:0];
        if ([object isKindOfClass:[UIImage class]]) {
            imagePost = (UIImage*)object;
        }
        else if ([object isKindOfClass:[NSString class]]) {
            imagePost = [UIImage imageWithContentsOfFile:(NSString*)object];
        }
        else {
            
        }
        
        _imgVPost.image = imagePost;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Create Login View so that the app will be granted "status_update" permission.
}

-(void)viewDidDisappear:(BOOL)animated 
{
    [super viewDidDisappear:animated];
}

#pragma mark - FBLoginViewDelegate

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    // first get the buttons set for login mode
    _btnPost.enabled = YES;
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    // here we use helper properties of FBGraphUser to dot-through to first_name and
    // id properties of the json response from the server; alternatively we could use
    // NSDictionary methods such as objectForKey to get values from the my json object
    _labelUserName.text = [NSString stringWithFormat:@"%@!", user.first_name];
    // setting the profileID property of the FBProfilePictureView instance
    // causes the control to fetch and display the profile picture for the user
    _profilePicture.profileID = user.id;
    _loggedInUser = user;
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    [FBNativeDialogs canPresentShareDialogWithSession:nil];
    [FBSession.activeSession closeAndClearTokenInformation];
    _btnPost.enabled = NO;
    
    _profilePicture.profileID = nil;
    _labelUserName.text = nil;
    _loggedInUser = nil;
}


//click post this
#pragma mark -
#pragma mark Button Post Click________________________________________________________________________
- (IBAction) postToFacebookClick
{
    [_txvContentPost resignFirstResponder];
    
    if (_imagesPathForPost.count == 1) {
        [MBProgressHUD showHUDAddedToWindowWithTitle:@"Posting..." animated:YES];
        [self postStatus:_txvContentPost.text photoPath:[_imagesPathForPost objectAtIndex:0]];
    }
    else if (_imagesPathForPost.count > 1) {
        [MBProgressHUD showHUDAddedToWindowWithTitle:@"Posting..." animated:YES];
        [self postMultiPhotosWithStatus:_txvContentPost.text];
    }
}


#pragma mark -
#pragma mark post methods ______________________________________________________________________________
- (void) postMultiPhotosWithStatus:(NSString*) status
{
    UIImage *imagePost = nil;
    id object = [_imagesPathForPost objectAtIndex:_indexPosted];
    if ([object isKindOfClass:[UIImage class]]) {
        imagePost = (UIImage*)object;
    }
    else if ([object isKindOfClass:[NSString class]]) {
        imagePost = [UIImage imageWithContentsOfFile:(NSString*)object];
    }
    else {
        
    }
    
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    status, @"message",
                                    imagePost, @"picture",
                                    nil];
    
    [self performPublishAction:^{
        [FBRequestConnection startWithGraphPath:@"me/photos"
                                     parameters:params
                                     HTTPMethod:@"POST"
                              completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                  if (error) {
                                      _btnPost.enabled = YES;
                                      [MBProgressHUD hideAllHUDForWindowAnimated:YES];
                                      NSString *_alertTitle = [NSString stringWithFormat:@"Posted:%i/%i",_indexPosted,_imagesPathForPost.count];
                                      
                                      UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:_alertTitle
                                                                                          message:@"There was error, your post stop"
                                                                                         delegate:self
                                                                                cancelButtonTitle:@"OK"
                                                                                otherButtonTitles:nil];
                                      [alertView show];
                                      
                                      return;
                                  }
                                  _indexPosted += 1;
                                  if (_indexPosted >= _imagesPathForPost.count) {
                                      [MBProgressHUD hideAllHUDForWindowAnimated:YES];
                                      [self showAlert:@"Multi Photo Post" result:result error:error];
                                      _btnPost.enabled = YES;
                                  }
                                  else {
                                      [self postMultiPhotosWithStatus:status];
                                  }
                              }];
        _btnPost.enabled = NO;
    }];
}

- (void)postStatus:(NSString*)status photoPath:(id)photoPath
{
    UIImage *imagePost;
    
    if ([photoPath isKindOfClass:[UIImage class]]) {
        imagePost = (UIImage*)photoPath;
    }
    else if ([photoPath isKindOfClass:[NSString class]]) {
        imagePost = [UIImage imageWithContentsOfFile:(NSString*)photoPath];
    }
    else {
        
    }

    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    status, @"message",
                                    imagePost, @"picture",
                                    nil];
    
    BOOL displayedNativeDialog = [FBNativeDialogs presentShareDialogModallyFrom:self
                                                                    initialText:status
                                                                          image:imagePost
                                                                            url:nil
                                                                        handler:nil];
    if (!displayedNativeDialog) {
        [self performPublishAction:^{
            [FBRequestConnection startWithGraphPath:@"me/photos"
                                         parameters:params
                                         HTTPMethod:@"POST"
                                  completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                      [MBProgressHUD hideAllHUDForWindowAnimated:YES];
                                      [self showAlert:@"Photo Post" result:result error:error];
                                      _btnPost.enabled = YES;
                                  }];
            _btnPost.enabled = NO;
        }];
    }
    else {
    }
}

// Post Status Update button handler; will attempt to invoke the native
// share dialog and, if that's unavailable, will post directly
- (void)postStatusUpdate:(NSString *)status
{
    // Post a status update to the user's feed via the Graph API, and display an alert view
    // with the results or an error.
//    NSString *name = _loggedInUser.first_name;
//    NSString *message = [NSString stringWithFormat:@"Updating status for %@ at %@",
//                         name != nil ? name : @"me" , [NSDate date]];
    
    // if it is available to us, we will post using the native dialog
    BOOL displayedNativeDialog = [FBNativeDialogs presentShareDialogModallyFrom:self
                                                                    initialText:nil
                                                                          image:nil
                                                                            url:nil
                                                                        handler:nil];
    if (!displayedNativeDialog) {
        
        [self performPublishAction:^{
            // otherwise fall back on a request for permissions and a direct post
            [FBRequestConnection startForPostStatusUpdate:status
                                        completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                            [MBProgressHUD hideAllHUDForWindowAnimated:YES];
                                            [self showAlert:status result:result error:error];
                                            _btnPost.enabled = YES;
                                        }];
            
            _btnPost.enabled = NO;
        }];
    }
}

// Post Photo button handler; will attempt to invoke the native
// share dialog and, if that's unavailable, will post directly
- (void)postPhoto:(NSString*)photoPath
{
    // Just use the icon image from the application itself.  A real app would have a more
    // useful way to get an image.
    
    // if it is available to us, we will post using the native dialog
    BOOL displayedNativeDialog = [FBNativeDialogs presentShareDialogModallyFrom:self
                                                                    initialText:_txvContentPost.text
                                                                          image:[UIImage imageWithContentsOfFile:photoPath]
                                                                            url:nil
                                                                        handler:nil];
    if (!displayedNativeDialog) {
        [self performPublishAction:^{
            
            [FBRequestConnection startForUploadPhoto:[UIImage imageWithContentsOfFile:photoPath]
                                   completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                       [MBProgressHUD hideAllHUDForWindowAnimated:YES];
                                       [self showAlert:@"Photo Post" result:result error:error];
                                       _btnPost.enabled = YES;
                                   }];
            
            _btnPost.enabled = NO;
        }];
    }
}


// Convenience method to perform some action that requires the "publish_actions" permissions.
- (void) performPublishAction:(void (^)(void)) action {
    // we defer request for permission to post to the moment of post, then we check for the permission
    if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound) {
        // if we don't already have the permission, then we request it now
        [FBSession.activeSession reauthorizeWithPublishPermissions:[NSArray arrayWithObject:@"publish_actions"]
                                                   defaultAudience:FBSessionDefaultAudienceFriends
                                                 completionHandler:^(FBSession *session, NSError *error) {
                                                     if (!error) {
                                                         action();
                                                     }
                                                     else {
                                                         //For this example, ignore errors (such as if user cancels).
                                                         NSLog(@"_____________________ Cancel");
                                                         [MBProgressHUD hideAllHUDForWindowAnimated:YES];
                                                     }
                                                 }];
    } else {
        action();
    }
    
}
/**************************************************************************/
/**************************************************************************/
/**************************************************************************/
// Pick Friends button handler
- (IBAction)pickFriendsClick:(UIButton *)sender {
    FBFriendPickerViewController *friendPickerController = [[FBFriendPickerViewController alloc] init];
    friendPickerController.title = @"Pick Friends";
    [friendPickerController loadData];
    
    // Use the modal wrapper method to display the picker.
    [friendPickerController presentModallyFromViewController:self animated:YES handler:
     ^(FBViewController *sender, BOOL donePressed) {
         if (!donePressed) {
             return;
         }
         NSString *message;
         
         if (friendPickerController.selection.count == 0) {
             message = @"<No Friends Selected>";
         } else {
             
             NSMutableString *text = [[NSMutableString alloc] init];
             
             // we pick up the users from the selection, and create a string that we use to update the text view
             // at the bottom of the display; note that self.selection is a property inherited from our base class
             for (id<FBGraphUser> user in friendPickerController.selection) {
                 if ([text length]) {
                     [text appendString:@", "];
                 }
                 [text appendString:user.name];
             }
             message = text;
         }
         
         [[[UIAlertView alloc] initWithTitle:@"You Picked:"
                                     message:message
                                    delegate:nil
                           cancelButtonTitle:@"OK"
                           otherButtonTitles:nil]
          show];
     }];
}

// Pick Place button handler
- (IBAction)pickPlaceClick:(UIButton *)sender {
    FBPlacePickerViewController *placePickerController = [[FBPlacePickerViewController alloc] init];
    placePickerController.title = @"Pick a Seattle Place";
    placePickerController.locationCoordinate = CLLocationCoordinate2DMake(47.6097, -122.3331);
    [placePickerController loadData];
    
    // Use the modal wrapper method to display the picker.
    [placePickerController presentModallyFromViewController:self animated:YES handler:
     ^(FBViewController *sender, BOOL donePressed) {
         if (!donePressed) {
             return;
         }
         
         NSString *placeName = placePickerController.selection.name;
         if (!placeName) {
             placeName = @"<No Place Selected>";
         }
         
         [[[UIAlertView alloc] initWithTitle:@"You Picked:"
                                     message:placeName
                                    delegate:nil
                           cancelButtonTitle:@"OK"
                           otherButtonTitles:nil]
          show];
     }];
}
/**************************************************************************/
/**************************************************************************/
/**************************************************************************/

// UIAlertView helper for post buttons
- (void)showAlert:(NSString *)message
           result:(id)result
            error:(NSError *)error {
    
    NSString *alertMsg;
    NSString *alertTitle;
    if (error) {
        alertMsg = @"Post Fail!"; //error.localizedDescription;
        alertTitle = @"Error";
    } else {
//        NSDictionary *resultDict = (NSDictionary *)result;
//        alertMsg = [NSString stringWithFormat:@"Successfully posted '%@'.\nPost ID: %@",
//                    message, [resultDict valueForKey:@"id"]];
        alertMsg = @"Posted successfull!";
        alertTitle = @"Success";
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
                                                        message:alertMsg
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self dismissModalViewControllerAnimated:YES];
}


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

- (BOOL) shouldAutorotate
{
    return NO;
}


@end
