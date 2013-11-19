//
//  ViewController.h
//  MapRouteV3
//
//  Created by Nguyen Mau Dat on 6/4/13.
//  Copyright (c) 2013 Nguyen Mau Dat. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <MKMapViewDelegate>
@property (retain, nonatomic) IBOutlet MKMapView *mappa;

- (IBAction)clickRoute:(id)sender;

@end
