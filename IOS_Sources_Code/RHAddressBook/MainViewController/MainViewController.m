/***********************************************************************
 *	File name:	fasdg.h
 *	Project:	Universal
 *	Description:
 *  Author:		Dat Nguyen Mau
 *  Created:    on 3/1/12.
 *	Device:		Iphone vs IPad
 *  Company:	__MyCompanyName__
 *  Copyright:	2012 . All rights reserved.
 ***********************************************************************/

#import "MainViewController.h"
#import "AppDelegate.h"
#import "PersonCell.h"

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
//        self.dlWantsFullScreenLayout = YES;
    }
    
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - View lifecycle
#pragma mark -
/*************************************************************/
/*************************************************************/
#pragma mark DEALLOC
- (void) dealloc
{
    [super dealloc];
}

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView
 {
 }
 */


#pragma mark -
#pragma mark VIEW DIDLOAD
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"All Contacts";

    self.searchDisplayController.searchResultsDataSource = self;
    self.searchDisplayController.searchResultsDelegate = self;
    
    if ([DLDevice isIOS7OrLater]) {
        self.searchDisplayController.displaysSearchBarInNavigationBar = YES;
    }
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonAction:)] autorelease];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Groups" style:UIBarButtonItemStylePlain target:self action:@selector(groupsButtonAction:)] autorelease];
}

#pragma mark -
#pragma mark VIEW APPEAR
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.dlToolbarHidden = YES;
    self.title = @"All Contacts";
    if (self.searchDisplayController.searchBar.showsCancelButton) {
        [self loadDataSearch];
    }
    else {
        [self loadDataAddress];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark -
#pragma mark VIEW DISAPPEAR
- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.title = @"Back";
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}
/*************************************************************/
- (void)loadDataAddress
{
    if ([RHAddressBook authorizationStatus] == RHAuthorizationStatusNotDetermined) {
        [[AppDelegate shareApp].addressBook requestAuthorizationWithCompletion:^(bool granted, NSError *error) {
            if (granted) {
                _listAddressBook = [[[AppDelegate shareApp].addressBook peopleOrderedBySortOrderingAndSectioned] retain];
                [_tableAddress performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
            }
            else {
                // error
            }
        }];
    }
    else {
        if ([RHAddressBook authorizationStatus] == RHAuthorizationStatusAuthorized) {
            _listAddressBook = [[[AppDelegate shareApp].addressBook peopleOrderedBySortOrderingAndSectioned] retain];
            [_tableAddress reloadData];
        }
        else {
            // error
        }
    }
}

- (void)addButtonAction:(id)sender
{
    ABNewPersonViewController *_newPersonView = [[ABNewPersonViewController alloc] init];
    _newPersonView.newPersonViewDelegate = self;
    _newPersonView.addressBook = [AppDelegate shareApp].addressBook.addressBookRef;
    DLNavigationControllerRotate *_navigationNewPerson = [[DLNavigationControllerRotate alloc] initWithRootViewController:_newPersonView];
    if (![DLDevice isIOS7OrLater])
        _navigationNewPerson.navigationBar.barStyle = UIBarStyleBlack;
    else
        _navigationNewPerson.dlNavigationBar.dlBackgroundImage = [UIImage imageNamed:@"header_IOS7.png"];
    
    [self presentViewController:_navigationNewPerson animated:YES completion:^{
        
    }];
}
- (void)groupsButtonAction:(id)sender
{
    
}

- (void)newPersonViewController:(ABNewPersonViewController *)newPersonView didCompleteWithNewPerson:(ABRecordRef)person
{
    [self dismissModalViewControllerAnimated:YES];
}
/*************************************************************/
#pragma mark -
#pragma mark FUNCTIONS FOR LOAD
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return tableView == _tableAddress ? _listAddressBook.count : 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tableView == _tableAddress ? [[_listAddressBook objectAtIndex:section] count] - 1 : _listSearchResult.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.f;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return tableView == _tableAddress ? [[_listAddressBook objectAtIndex:section] objectAtIndex:0] : nil;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableAddress) {
        static NSString *cellIdentifier = @"List Person";
        PersonCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[PersonCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        }
        
        [cell setBackgroundImageWith:tableView forIndexPath:indexPath];
        
        RHPerson *person = [[_listAddressBook objectAtIndex:indexPath.section] objectAtIndex:indexPath.row + 1];
        if ([DLDevice iosVersion] >= 6.0f) {
            if (!person.nameCompositeName) {
                cell.textLabel.text = person.nameCompositeName;
            }
            else {
                UIFont *boldFont = [UIFont boldSystemFontOfSize:cell.textLabel.font.pointSize];
                
                // Create the attributes
                NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys: boldFont, NSFontAttributeName, nil];
                
                NSRange range = NSMakeRange(0,person.nameCompositeName.length); // range of " 2012/10/14 ". Ideally this should not be hardcoded
                if (person.firstName && person.lastName) {
                    if ([person.firstName isEqualToString:person.lastName]) {
                        // ????
                    }
                    else {
                        range = [person.nameCompositeName rangeOfString:person.nameSortOrdering];
                    }
                }
                
                // Create the attributed string (text + attributes)
                NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:person.nameCompositeName];
                [attributedText setAttributes:attrs range:range];
                
                // Set it in our UILabel and we are done!
                [cell.textLabel setAttributedText:attributedText];
            }
        }
        else {
            cell.textLabel.text = person.nameCompositeName;
        }
        
        //    cell.detailTextLabel.text = [person.phoneNumbers valuesStringWithSeparator:@","];
        
        return cell;
    }
    else {
        static NSString *cellIdentifier = @"List Person Search";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        RHPerson *person = [_listSearchResult objectAtIndex:indexPath.row];
        if ([DLDevice iosVersion] >= 6.0f) {
            if (!person.nameCompositeName) {
                cell.textLabel.text = person.nameCompositeName;
            }
            else {
                UIFont *boldFont = [UIFont boldSystemFontOfSize:cell.textLabel.font.pointSize];
                
                // Create the attributes
                NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys: boldFont, NSFontAttributeName, nil];
                
                NSRange range = NSMakeRange(0,person.nameCompositeName.length); // range of " 2012/10/14 ". Ideally this should not be hardcoded
                if (person.firstName && person.lastName) {
                    if ([person.firstName isEqualToString:person.lastName]) {
                        // ????
                    }
                    else {
                        range = [person.nameCompositeName rangeOfString:person.nameSortOrdering];
                    }
                }
                
                // Create the attributed string (text + attributes)
                NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:person.nameCompositeName];
                [attributedText setAttributes:attrs range:range];
                
                // Set it in our UILabel and we are done!
                [cell.textLabel setAttributedText:attributedText];
            }
        }
        else {
            cell.textLabel.text = person.nameCompositeName;
        }
        
        //    cell.detailTextLabel.text = [person.phoneNumbers valuesStringWithSeparator:@","];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    RHPerson *person = nil;
    
    if (tableView == _tableAddress) {
        person = [[_listAddressBook objectAtIndex:indexPath.section] objectAtIndex:indexPath.row + 1];
    }
    else {
        [self.searchDisplayController.searchBar resignFirstResponder];
        person = [_listSearchResult objectAtIndex:indexPath.row];
    }
    
    ABPersonViewController *personView = [[ABPersonViewController alloc] init];
    personView.addressBook = [AppDelegate shareApp].addressBook.addressBookRef;
    personView.displayedPerson = person.recordRef;
    personView.allowsEditing = YES;
    personView.allowsActions = YES;
    personView.shouldShowLinkedPeople = YES;
    [self.navigationController pushViewController:personView animated:YES];
    [personView release];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RHPerson *person = nil;
    
    if (tableView == _tableAddress) {
        person = [[_listAddressBook objectAtIndex:indexPath.section] objectAtIndex:indexPath.row + 1];
    }
    else {
        [self.searchDisplayController.searchBar resignFirstResponder];
        person = [_listSearchResult objectAtIndex:indexPath.row];
    }
    
    NSArray *arrPhones = person.phoneNumbers.values;
    
    if (arrPhones.count < 1) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        return;
    }
    
    if (arrPhones.count == 1) {
        // call
        
        return;
    }
    
    _selectedIndexPath = [indexPath retain];
    
    UIActionSheet *_actionSheet = [[UIActionSheet alloc] initWithTitle:@"Phones Action" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    for (NSString *number in arrPhones) {
        [_actionSheet addButtonWithTitle:number];
    }
    [_actionSheet addButtonWithTitle:@"Cancel"];
    
    [_actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (!_selectedIndexPath) {
        return;
    }
    
    if (self.searchDisplayController.searchBar.showsCancelButton) {
        [self.searchDisplayController.searchResultsTableView deselectRowAtIndexPath:_selectedIndexPath animated:NO];
    }
    else {
        [_tableAddress deselectRowAtIndexPath:_selectedIndexPath animated:NO];
    }
    
    [_selectedIndexPath release];
    _selectedIndexPath = nil;
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
}
/*************************************************************/
/*************************************************************/
#pragma mark -
#pragma mark FUNCTIONS FOR EVENTS HANDLE
- (IBAction)pushSubView:(id)sender
{
    SubViewController *_subView = [[SubViewController alloc] initWithNibName:@"SubViewController" bundle:nil];
    [self.navigationController pushViewController:_subView animated:YES];
    [_subView release];
}
/*************************************************************/
- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    [controller.searchBar setShowsCancelButton:YES animated:YES];
}

- (void) searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller
{
    
}
//- (void) searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller;
- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    [controller.searchBar setShowsCancelButton:NO animated:YES];
}

// called when the table is created destroyed, shown or hidden. configure as necessary.
//- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView;
//- (void)searchDisplayController:(UISearchDisplayController *)controller willUnloadSearchResultsTableView:(UITableView *)tableView;
//
//// called when table is shown/hidden
//- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView;
//- (void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView;
//- (void)searchDisplayController:(UISearchDisplayController *)controller willHideSearchResultsTableView:(UITableView *)tableView;
//- (void)searchDisplayController:(UISearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView;
//
//// return YES to reload table. called when search string/option changes. convenience methods on top UISearchBar delegate methods
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    return YES;
}
//- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption;


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self loadDataSearch];
}

- (void)loadDataSearch
{
    if (_listSearchResult) {
        [_listSearchResult release];
        _listSearchResult = nil;
    }
    
    _listSearchResult = [[[AppDelegate shareApp].addressBook peopleWithName:self.searchDisplayController.searchBar.text] retain];
    [self.searchDisplayController.searchResultsTableView reloadData];
}

@end
