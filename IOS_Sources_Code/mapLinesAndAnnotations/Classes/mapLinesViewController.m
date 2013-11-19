//
//  mapLinesViewController.m
//  mapLines
//
//  Created by Craig on 4/12/09.
//  Copyright Craig Spitzkoff 2009. All rights reserved.
//

#import "mapLinesViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "CSMapRouteLayerView.h"
#import "CSMapAnnotation.h"
#import "CSImageAnnotationView.h"

@implementation mapLinesViewController
@synthesize routeView = _routeView;
@synthesize mapView   = _mapView;

- (void)viewDidLoad {
    [super viewDidLoad];
	
	//
	// load the points from our local resource
	//
	NSString* filePath = [[NSBundle mainBundle] pathForResource:@"route" ofType:@"csv"];
	NSString* fileContents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
	NSArray* pointStrings = [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
	NSMutableArray* arrPoints = [[NSMutableArray alloc] initWithCapacity:pointStrings.count];
	
	for(int idx = 0; idx < pointStrings.count; idx++)
	{
		// break the string down even further to latitude and longitude fields. 
		NSString* currentPointString = [pointStrings objectAtIndex:idx];
		NSArray* latLonArr = [currentPointString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
		
		CLLocationDegrees latitude  = [[latLonArr objectAtIndex:0] doubleValue];
		CLLocationDegrees longitude = [[latLonArr objectAtIndex:1] doubleValue];
		
		CLLocation* currentLocation = [[[CLLocation alloc] initWithLatitude:latitude longitude:longitude] autorelease];
		[arrPoints addObject:currentLocation];
	}
	
	//
	// Create our map view and add it as as subview. 
	//
	_mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
	[self.view addSubview:_mapView];
	[_mapView setDelegate:self];

	
	// CREATE THE ANNOTATIONS AND ADD THEM TO THE MAP
	CSMapAnnotation* annotation = nil;
	
	// create the start annotation and add it to the array
	annotation = [[[CSMapAnnotation alloc] initWithCoordinate:[[arrPoints objectAtIndex:0] coordinate]
											   annotationType:CSMapAnnotationTypeStart
														title:@"Start Point"] autorelease];
	[_mapView addAnnotation:annotation];
	
	
	// create the end annotation and add it to the array
	annotation = [[[CSMapAnnotation alloc] initWithCoordinate:[[arrPoints objectAtIndex:arrPoints.count - 1] coordinate]
											   annotationType:CSMapAnnotationTypeEnd
														title:@"End Point"] autorelease];
	[_mapView addAnnotation:annotation];
	
	// create the image annotation
//	annotation = [[[CSMapAnnotation alloc] initWithCoordinate:[[points objectAtIndex:points.count / 2] coordinate]
//											   annotationType:CSMapAnnotationTypeImage
//														title:@"Cleveland Circle"] autorelease];
//	[annotation setUserData:@"cc.jpg"];
//	[annotation setUrl:nil];
//	
//	[_mapView addAnnotation:annotation];

	
	// create our route layer view, and initialize it with the map on which it will be rendered. 
	_routeView = [[CSMapRouteLayerView alloc] initWithRoute:arrPoints mapView:_mapView];
	
	[arrPoints release];
}

- (void)viewDidUnload {
	self.mapView   = nil;
	self.routeView = nil;
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}




#pragma mark mapView delegate functions
- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
	// turn off the view of the route as the map is chaning regions. This prevents
	// the line from being displayed at an incorrect positoin on the map during the
	// transition. 
	_routeView.hidden = YES;
}
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
	// re-enable and re-poosition the route display. 
	_routeView.hidden = NO;
	[_routeView setNeedsDisplay];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
	MKAnnotationView* annotationView = nil;
	
	// determine the type of annotation, and produce the correct type of annotation view for it.
	CSMapAnnotation* csAnnotation = (CSMapAnnotation*)annotation;
	if(csAnnotation.annotationType == CSMapAnnotationTypeStart || 
	   csAnnotation.annotationType == CSMapAnnotationTypeEnd)
	{
		NSString* identifier = @"Pin";
		MKPinAnnotationView* pin = (MKPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
		
		if(nil == pin)
		{
			pin = [[[MKPinAnnotationView alloc] initWithAnnotation:csAnnotation reuseIdentifier:identifier] autorelease];
		}
		
		[pin setPinColor:(csAnnotation.annotationType == CSMapAnnotationTypeEnd) ? MKPinAnnotationColorRed : MKPinAnnotationColorGreen];
		
		annotationView = pin;
	}
	else if(csAnnotation.annotationType == CSMapAnnotationTypeImage)
	{
		NSString* identifier = @"Image";
		
		CSImageAnnotationView* imageAnnotationView = (CSImageAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
		if(nil == imageAnnotationView)
		{
			imageAnnotationView = [[[CSImageAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier] autorelease];	
			imageAnnotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
		}
        
		annotationView = imageAnnotationView;
	}
	
	[annotationView setEnabled:YES];
	[annotationView setCanShowCallout:YES];
	
	return annotationView;
}


- (void)dealloc {	
    [_mapView release];
	[_routeView release];
	[_detailsVC release];
    
	[super dealloc];
}

@end
