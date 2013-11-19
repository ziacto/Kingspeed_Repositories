//
//  ViewController.m
//  TestOverlayOnMap
//
//  Created by Andrea Finollo on 26/09/12.
//  Copyright (c) 2012 Andrea Finollo. All rights reserved.
//

#import "ViewController.h"
#import "DLRouteDirections.h"

@interface ViewController ()

@property (retain, nonatomic) DLRouteDirections *routeObject;
@end



@implementation ViewController

@synthesize routeObject = _routeObject;


- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.mappa.showsUserLocation = YES;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _routeObject = [[DLRouteDirections alloc] init];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mapViewDidStopLocatingUser:(MKMapView *)mapView
{
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(self.mappa.userLocation.coordinate, 1000, 1000);
    MKCoordinateRegion adjustedRegion = [self.mappa regionThatFits:viewRegion];
    [self.mappa setRegion:adjustedRegion animated:NO];
    NSString *_start = [NSString stringWithFormat:@"%f,%f",self.mappa.userLocation.coordinate.latitude,self.mappa.userLocation.coordinate.longitude];
    
    [self.routeObject createDirectionRequestWithStartPoint:_start andEndPoint:@"Tran Duy Hung, Ha Noi" withCallBackBlock:^(NSError *error,  NSDictionary *routeDistance, NSDictionary *routeDuration, MKPolyline *routePolyline, NSArray *routes, NSArray *steps, CLLocation * startPoint,  CLLocation * endPoint, NSArray * directions ) {
        NSLog(@"_________________________ %@ / %@", routePolyline, error);
        if (routePolyline) [self.mappa addOverlay:routePolyline];
    }];
    
    [self.routeObject validateViaAddress:@"Hoang Ngan, Cau Giay, Ha Noi" withCallBackBlock:^(NSError *error,  NSString *addressStatus, NSArray *formattedAddresses, NSArray *addressesGPS) {
        for (id object in formattedAddresses) 
            NSLog(@"________ validateAddress:%@",object);
    }];
}

- (IBAction)clickRoute:(id)sender
{
    [self.routeObject createDirectionRequestWithStartPoint:@"Hoan kiem, Ha Noi" andEndPoint:@"Tran Duy Hung, Ha Noi" withCallBackBlock:^(NSError *error,  NSDictionary *routeDistance, NSDictionary *routeDuration, MKPolyline *routePolyline, NSArray *routes, NSArray *steps, CLLocation * startPoint,  CLLocation * endPoint, NSArray * directions ) {
        [self.mappa removeOverlays:self.mappa.overlays];
        [self.mappa addOverlay:routePolyline];
    }];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    if (userLocation.coordinate.latitude == 0 && userLocation.coordinate.longitude == 0) {
        return;
    }
    self.mappa.showsUserLocation = NO;
}


- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
    MKPolylineView *polylineView = [[[MKPolylineView alloc] initWithPolyline:overlay] autorelease];
    polylineView.strokeColor = [UIColor blueColor];
    polylineView.lineWidth = 10.0;
    polylineView.fillColor = [UIColor yellowColor];
    
    return polylineView;
}
@end
