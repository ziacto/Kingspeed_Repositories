//
//  WeatherViewController.m
//  ASIHttpRequest
//
//  Created by himawari on 8/6/13.
//  Copyright (c) 2013 Himawari. All rights reserved.
//

#import "WeatherViewController.h"
#import "ASIHTTPRequest.h"
#import "JSONKit.h"

@interface WeatherViewController ()

@end

@implementation WeatherViewController
{
    NSArray *jsonData;
    NSInteger numberOfRow;
    NSMutableArray *city;
    NSMutableArray *todayWeather;
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    /// get data from URL
    NSURL *url = [NSURL URLWithString:@"http://weatherlink.tenki-yoho.com/api2.php?id=softbankmiphone_201204&pw=m1dhdnrd&jcode=utf8&format=JSON&mode=weather"];
    request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request startSynchronous];
    
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *dataRequested = [request responseString];
    jsonData = [dataRequested objectFromJSONString];

    NSInteger countJsonData = [jsonData count];
    NSDictionary *lastDictionary = [jsonData objectAtIndex:countJsonData-1];
//    NSLog(@"dddd: %@", lastDictionary);
//    NSLog(@"dddd: %@", [lastDictionary objectForKey:@"city"]);
    // get number of cities
    numberOfRow = [[lastDictionary objectForKey:@"city"] integerValue];
    
    NSLog(@"_____________ %@", jsonData);
    
    // get name of cities and store into mutable array
    city = [[NSMutableArray alloc]init];
    for (int i = 1; i <= numberOfRow; i++) {
        NSDictionary *dictAtIndex = [jsonData objectAtIndex:(i-1)*8];
        NSString *cityAtIndex = [dictAtIndex objectForKey:@"city"];
        [city addObject:cityAtIndex];
    }
    
    // get current date
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc]init];
    [dateFormater setDateFormat:@"MM/dd"];
    NSString *todayDateStr = [dateFormater stringFromDate:today];
//    NSLog(@"jjj:%@", todayDateStr);
    todayWeather = [[NSMutableArray alloc]init];
    // get information about temparature min, max and amount of rain in today
    for (int i = 0; i < countJsonData; i++) {
        NSDictionary *dictAtIndex = [jsonData objectAtIndex:i];
        NSString *dateAtIndex = [dictAtIndex objectForKey:@"date"];
        if ([dateAtIndex isEqualToString:todayDateStr]) {
            NSString *weatherDetail = [NSString stringWithFormat:@" %@: %@%@C - %@%@C, %@%%",dateAtIndex, [dictAtIndex objectForKey:@"min"], @"\u00B0", [dictAtIndex objectForKey:@"max"], @"\u00B0",[dictAtIndex objectForKey:@"rain"]];
            // add information into a mutableArray
            [todayWeather addObject:weatherDetail];
        }
    }
    NSLog(@"jjj:%@", todayWeather);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
        return numberOfRow;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell.textLabel.text = [NSString stringWithFormat:@"city %@",[city objectAtIndex:indexPath.row]];
    cell.detailTextLabel.text = [todayWeather objectAtIndex:indexPath.row];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end
