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

#import "ProjectXcode_4_1ViewController.h"

@implementation ProjectXcode_4_1ViewController

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
    
    appDelegate = [[UIApplication sharedApplication] delegate];
}

#pragma mark -
#pragma mark VIEW APPEAR
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

#pragma mark -
#pragma mark VIEW DISAPPEAR
- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}
/*************************************************************/
/*************************************************************/
#pragma mark -
#pragma mark FUNCTIONS FOR LOAD
/*************************************************************/
/*************************************************************/
#pragma mark -
#pragma mark FUNCTIONS FOR EVENTS HANDLE

- (void) loadAlbumsForLauncher
{
    [[self appControllers] setObject:[ObjectViewController class] forKey:@"ObjectViewController"];
	
	if(![self hasSavedLauncherItems])
	{
        NSUInteger pagesCount = appDelegate.arrDataOnPages.count;
        
        NSMutableArray *arrayPages = [[NSMutableArray alloc] initWithCapacity:pagesCount];
        
        NSUInteger targetTitleNumber = 0;
        
        for (int i = 0; i < pagesCount; i++) {
            NSMutableArray *arrAlbumsOnePage = [[appDelegate.arrDataOnPages objectAtIndex:i] arrAlbumsOnPage];
            NSMutableArray *arrOnePage = [[NSMutableArray alloc] initWithCapacity:[arrAlbumsOnePage count]];
            for (int j = 0; j < [arrAlbumsOnePage count]; j++) {
                targetTitleNumber += 1;
                int status = [[arrAlbumsOnePage objectAtIndex:j] status];
                NSString *imageViewPass = @"";
                UIImage *imageBackgr = nil;
                
                if(status > 0)
                {
                    if(j == 0) imageViewPass = @"album B_01.png";
                    if(j == 1) imageViewPass = @"album B_02.png";
                    if(j == 2) imageViewPass = @"album B_03.png";
                    if(j == 3) imageViewPass = @"album B_04.png";
                    if(j == 4) imageViewPass = @"album B_05.png";
                    if(j == 5) imageViewPass = @"album B_06.png";
                    if(j == 6) imageViewPass = @"album B_07.png";
                    if(j == 7) imageViewPass = @"album B_08.png";
                    if(j == 8) imageViewPass = @"album B_09.png";
                }
                else
                {
                    if(j == 0) imageViewPass = @"album A_01.png";
                    if(j == 1) imageViewPass = @"album A_02.png";
                    if(j == 2) imageViewPass = @"album A_03.png";
                    if(j == 3) imageViewPass = @"album A_04.png";
                    if(j == 4) imageViewPass = @"album A_05.png";
                    if(j == 5) imageViewPass = @"album A_06.png";
                    if(j == 6) imageViewPass = @"album A_07.png";
                    if(j == 7) imageViewPass = @"album A_08.png";
                    if(j == 8) imageViewPass = @"album A_09.png";
                    
                    imageBackgr = [appDelegate loadImage:[[arrAlbumsOnePage objectAtIndex:j] name] :[[arrAlbumsOnePage objectAtIndex:j] labelPath] :[[arrAlbumsOnePage objectAtIndex:j] typeimage]];
                    
                    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 5.0)
                    {               
                        int orientation = [[arrAlbumsOnePage objectAtIndex:j] orientation];
                        if(orientation == 1)
                        {                  
                            imageBackgr = [[[UIImage alloc] initWithCGImage: imageBackgr.CGImage
                                                                      scale: 1.0
                                                                orientation: UIImageOrientationDown] autorelease];
                        }
                        else if(orientation == 3)
                        {                  
                            imageBackgr = [[[UIImage alloc] initWithCGImage: imageBackgr.CGImage
                                                                      scale: 1.0
                                                                orientation: UIImageOrientationRight] autorelease];
                        }
                        else if(orientation == 2)
                        {                  
                            imageBackgr = [[[UIImage alloc] initWithCGImage: imageBackgr.CGImage
                                                                      scale: 1.0
                                                                orientation: UIImageOrientationLeft] autorelease];
                        }           
                    }
                }
                
                NSString *targetTitleStr = [NSString stringWithFormat:@"Item %i View",targetTitleNumber];
                
                OneFolderAlbum *oneAlbum = [[OneFolderAlbum alloc] initWithTitle:[appDelegate cutString:[[arrAlbumsOnePage objectAtIndex:j] name] :6]
                                                                     iPhoneImage:imageViewPass
                                                                       iPadImage:nil
                                                                     backgrImage:imageBackgr
                                                                          target:@"AlbumViewController"
                                                                     targetTitle:targetTitleStr
                                                                       deletable:NO];
                
                oneAlbum.tag = [[arrAlbumsOnePage objectAtIndex:j] albumID];
                [arrOnePage addObject:oneAlbum];
            }
            
            [arrayPages addObject:arrOnePage];
        }
        
        [self.launcherView setPages:arrayPages animated:NO];
        
        // Set number of immovable items below; only set it when you are setting the pages as the 
        // user may still be able to delete these items and setting this then will cause movable 
        // items to become immovable.
        // [self.launcherView setNumberOfImmovableItems:1];
        
        // Or uncomment the line below to disable editing (moving/deleting) completely!
        // [self.launcherView setEditingAllowed:NO];
	}
    
    // Set badge text for a OneFolderAlbum using it's setBadgeText: method
    //    [(OneFolderAlbum *)[[[self.launcherView pages] objectAtIndex:0] objectAtIndex:0] setBadgeText:@"4"];
    
    // Alternatively, you can import CustomBadge.h as above and setCustomBadge: as below.
    // This will allow you to change colors, set scale, and remove the shine and/or frame.
    //    [(OneFolderAlbum *)[[[self.launcherView pages] objectAtIndex:0] objectAtIndex:1] setCustomBadge:[CustomBadge customBadgeWithString:@"2" withStringColor:[UIColor blackColor] withInsetColor:[UIColor whiteColor] withBadgeFrame:YES withBadgeFrameColor:[UIColor blackColor] withScale:0.8 withShining:NO]];
}

-(void)launcherViewItemSelected:(OneFolderAlbum*)item
{
    // show content folder album
    // here: go to album
    NSLog(@"Go to Album");
    
    [self goToAlbum:item];
}


-(void)launcherViewDidBeginEditing:(FolderAlbumsView*)sender
{
    // begin hold long on Album and can drag.
    NSLog(@"Begin Drag Drop Albums");
}

-(void)launcherViewDidEndEditing:(FolderAlbumsView*)sender
{
    // end editing folders (move, change pages)
    // save pages here
    NSLog(@"Save Database");
    
    [self updateDataBase:sender];
}

/*************************************************************/
/*************************************************************/
@end
