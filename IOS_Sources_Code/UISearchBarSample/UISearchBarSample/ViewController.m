//
//  ViewController.m
//  UISearchBarSample
//
//  Created by Carmine on 26/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"


@implementation ViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        NSArray *group1 = [[NSArray alloc] initWithObjects:@"Napoli", @"Juventus", @"Inter", @"Milan", @"Lazio", nil];
        NSArray *group2 = [[NSArray alloc] initWithObjects:@"Real Madrid", @"Barcelona", @"Villareal", @"Valencia", @"Deportivo", nil];
        NSArray *group3 = [[NSArray alloc] initWithObjects:@"Manchester City", @"Manchester United", @"Chelsea", @"Arsenal", @"Liverpool", nil];
        
        originalData = [[NSArray alloc] initWithObjects:group1, group2, group3, nil];
        
        searchData = [[NSMutableArray alloc] init];
 
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];
    searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    
    searchDisplayController.delegate = self;
    searchDisplayController.searchResultsDataSource = self;
    
    self.tableView.tableHeaderView = searchBar;

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    int sections = 0;
    // Return the number of sections.
    
    if (tableView == self.tableView) {
        sections = [originalData count];
    }
    if(tableView == self.searchDisplayController.searchResultsTableView){
        sections = [searchData count];
    }
    return sections;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rows = 0;
    // Return the number of rows in the section.
    
    if (tableView == self.tableView) {
        rows = [[originalData objectAtIndex:section] count];
    }
    if(tableView == self.searchDisplayController.searchResultsTableView){
        rows = [[searchData objectAtIndex:section] count];
    }
    
    return rows;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"Serie A";
            break;
        case 1:
            return @"Liga";
            break;
        case 2:
            return @"Premiere League";
            break;
            
        default:
            return @"";
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    if (tableView == self.tableView) {
        cell.textLabel.text = [[originalData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }
    if(tableView == self.searchDisplayController.searchResultsTableView){
        cell.textLabel.text = [[searchData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }
    
    return cell;
}

#pragma mark - searchDisplayControllerDelegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [searchData removeAllObjects];
    
    NSArray *group;
    
    for(group in originalData)
    {
        NSMutableArray *newGroup = [[NSMutableArray alloc] init];
        NSString *element;
        
        for(element in group)
        {
            NSRange range = [element rangeOfString:searchString options:NSCaseInsensitiveSearch];
            
            if (range.length > 0) {
                [newGroup addObject:element];
            }
        }
        
        if ([newGroup count] > 0) {
            [searchData addObject:newGroup];
        }
        
        [newGroup release];
    }
    
    return YES;
}

#pragma mark - other methods

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
