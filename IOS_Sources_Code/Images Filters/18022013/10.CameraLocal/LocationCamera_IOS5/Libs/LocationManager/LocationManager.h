/***********************************************************************
 *	File name:	_______________.h
 *	Project:	Location Camera
 *	Description:
 *  Author:		Dat Nguyen Mau
 *  Created:    on 18/02/2013.
 *	Device:		Iphone vs IPad
 *  Company:	__MyCompanyName__
 *  Copyright:	2012 . All rights reserved.
 ***********************************************************************/

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "JSONKit.h"

typedef enum {
    ReverseGoogleAPI = 0,                   // default.
    ReverseGeocoder,
} ReverseAddressType;

typedef enum {
    English = 0,                   // default.
    Japanese,
} DataLanguage;


#define LOCATION_RESULTS     @"results"
#define LOCATION_STATUS      @"status"
#define LOCATION_ADDRESS_COMPONENTS  @"address_components"
#define DEBUG_LOCATION      0

@class LocationManager;
@protocol LocationManagerDelegate <NSObject>
@optional
// locationManagerDidUpdateToLocation
- (void) locationManagerDidUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation;

// Reverse Address Use MKReverseGeocoder 
- (void) locationManagerdidFindPlacemark:(MKPlacemark *)placemark error:(NSError *)error;
// reverse Address Use GoogleAPI or Japan Yahoo
- (void) locationReversedGoogleAPIWithAddressStreet:(NSMutableArray*)address jsonResult:(NSMutableArray *)jsonResult error:(NSError *)error;
- (void) locationManagerDNM:(LocationManager*)locationMng didChangeAuthorizationStatus:(CLAuthorizationStatus)status;

@end

@interface LocationManager : NSObject <CLLocationManagerDelegate, MKReverseGeocoderDelegate> {
    CLLocationManager *locationManager;
    MKReverseGeocoder *_geocoder;
    id _delegate;
    
    ReverseAddressType reverseType;
    DataLanguage dataLanguage;
}
@property (nonatomic , strong) id delegate;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign) ReverseAddressType reverseType;           // default: GoogleAPI
@property (nonatomic, assign) DataLanguage dataLanguage;          // default: receive data with english
+ (LocationManager*)sharedInstance; // Singleton method

- (void) startUpdateLocation;
- (void) stopUpdateLocation;

@property (nonatomic, readonly) BOOL locationServicesEnabled;

@property (nonatomic, strong) CLLocation *currentLocation;

@end




@interface NSString (DNM)
- (BOOL) containsString:(NSString*) _strSearch;
@end






























// API boi toan:

//NSURL *urlFromURLString = [NSURL URLWithString:@"http://api.joshicale.info/fortune/fortune.php?format=json"];
//// Use UTF8 encoding
//NSStringEncoding encodingType = NSUTF8StringEncoding;
//// reverseGeoString is what comes back with the goodies
//NSString *results = [NSString stringWithContentsOfURL:urlFromURLString encoding:encodingType error:nil];
//
//NSDictionary *jsonFFF = [[results objectFromJSONString] retain];
//
//for (NSDictionary *dict in [jsonFFF objectForKey:@"contents"])
//{
//    if ([[dict objectForKey:@"cluster_num"] intValue] == 1) {
//        NSLog(@"==> %@", [dict objectForKey:@"comment"]);
//        NSLog(@"==> %@", [[[dict objectForKey:@"elements"] objectAtIndex:0] objectForKey:@"category"]);
//    }
//}
