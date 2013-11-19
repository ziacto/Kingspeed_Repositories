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

#import "LocationManager.h"
#import <CoreLocation/CoreLocation.h>
#define DELAY_TIME      0.01

#define LocationAccuracy        kCLLocationAccuracyBestForNavigation

@interface LocationManager ()
{
    BOOL _isUpdating;
}

- (void) reverseLocationUseGoogleAPI:(CLLocation *)newLocation;

- (void) startReverseGeocoderLocation:(CLLocation *)newLocation;
- (void) delegateFindLocation:(MKPlacemark *)placemark;
- (void) delegateFindError:(NSError *)error;
- (void) alert:(NSString*)message;

@end


static LocationManager* sharedSingleton = nil;

@implementation LocationManager

@synthesize locationManager, delegate = _delegate;
@synthesize reverseType, dataLanguage;
@synthesize locationServicesEnabled;
#pragma mark -
#pragma mark Singleton Object Methods

+ (LocationManager*)sharedInstance
{
    @synchronized(self)
    {
        if (sharedSingleton == nil)
        {
            sharedSingleton = [[self alloc] init];
        }
    }
    return sharedSingleton;
}

- (id)init
{
    self = [super init];
    if (self != nil) {
        _currentLocation = nil;
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        reverseType = ReverseGoogleAPI;
    }
    return self;
}

- (BOOL) locationServicesEnabled
{
    BOOL bFlag = NO;
    // locationServices status
    NSComparisonResult order = [[UIDevice currentDevice].systemVersion compare: @"4.2" options: NSNumericSearch];
    if (order == NSOrderedSame || order == NSOrderedDescending)
    {
        // OS version >= 4.2
        if ([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] == 3) {
            bFlag = YES;
        }
        else {
            bFlag = NO;
        }
    }
    else
    {
        // OS version < 4.2
        bFlag = [CLLocationManager locationServicesEnabled];;
    }
    return bFlag;
}




-(void)alert:(NSString*)message
{
	UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"" 
													  message:message delegate:self cancelButtonTitle:@"OK"
											otherButtonTitles:nil, nil]; 
	[myAlert show];
}

- (void)startUpdateLocation
{
    if (![self locationServicesEnabled]) {
        float iosDevice = [[[UIDevice currentDevice] systemVersion] floatValue];
        if (reverseType == ReverseGoogleAPI || iosDevice >= 6.0) {
            if (_delegate && [_delegate respondsToSelector:@selector(locationReversedGoogleAPIWithAddressStreet:jsonResult:error:)])
                [_delegate locationReversedGoogleAPIWithAddressStreet:nil jsonResult:nil error:[NSError errorWithDomain:@"locationServices is Off\nPlease On Location Services To Use" code:-1 userInfo:nil]];
        }
        else {
            if (_delegate && [_delegate respondsToSelector:@selector(locationManagerdidFindPlacemark:error:)])
                [_delegate locationManagerdidFindPlacemark:nil error:[NSError errorWithDomain:@"locationServices is Off\nPlease On Location Services To Use" code:-1 userInfo:nil]];
        }
        return;
    }
    
//    NSLog(@"Location Updates Starting...");
    
    if (locationManager == nil) {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
    }
    NSAssert(locationManager != nil, @"Failed to allocate CLLocation manage");
    
    
    // You have some options here, though higher accuracy takes longer to resolve.
//    locationManager.desiredAccuracy = LocationAccuracy;
    
    _isUpdating = YES;
    [locationManager startUpdatingLocation];
}

- (void) stopUpdateLocation
{
//    NSLog(@"stopUpdatingLocation");
    
    _isUpdating = NO;
    [locationManager stopUpdatingLocation];
    [locationManager stopMonitoringSignificantLocationChanges];
    locationManager.delegate = nil;
    [locationManager dismissHeadingCalibrationDisplay];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    switch (error.code) {
        case kCLErrorLocationUnknown:                       // location is currently unknown, but CL will keep trying
            
            break;
            
        case kCLErrorDenied:                                // CL access has been denied (eg, user declined }location use)
            break;
        case kCLErrorNetwork:                               // general, network-related error
            
            break;
            
        case kCLErrorHeadingFailure:                        // heading could not be determined
            
            break;
            
        case kCLErrorRegionMonitoringDenied:                // Location region monitoring has been denied by the user
            break;
            
        case kCLErrorRegionMonitoringFailure:               // A registered region cannot be monitored
            
            break;
        case kCLErrorRegionMonitoringSetupDelayed:          // CL could not immediately initialize region monitoring
            
            break;
            
        case kCLErrorRegionMonitoringResponseDelayed:       // While events for this fence will be delivered, delivery will not occur immediately
            
            break;
            
        case kCLErrorGeocodeFoundNoResult:                  // A geocode request yielded no result
            
            break;
            
        case kCLErrorGeocodeFoundPartialResult:             // A geocode request yielded a partial result
            
            break;
            
        case kCLErrorGeocodeCanceled:                       // A geocode request was cancelled
            
            break;
            
        default:
            break;
    }
    
    [locationManager stopUpdatingLocation];
    
    if (_isUpdating) {
        _isUpdating = NO;
        
        float iosDevice = [[[UIDevice currentDevice] systemVersion] floatValue];
        if (reverseType == ReverseGoogleAPI || iosDevice >= 6.0) {
            if (_delegate && [_delegate respondsToSelector:@selector(locationReversedGoogleAPIWithAddressStreet:jsonResult:error:)])
                [_delegate locationReversedGoogleAPIWithAddressStreet:nil jsonResult:nil error:error];
        }
        else {
            if (_delegate && [_delegate respondsToSelector:@selector(locationManagerdidFindPlacemark:error:)])
                [_delegate locationManagerdidFindPlacemark:nil error:error];
        }
    }
}

- (void) locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (_delegate && [_delegate respondsToSelector:@selector(locationManagerDNM:didChangeAuthorizationStatus:)]) {
        [_delegate locationManagerDNM:self didChangeAuthorizationStatus:status];
    }
}

// Delegate method from the CLLocationManagerDelegate protocol.
- (void)locationManager:(CLLocationManager *)manage didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if (!_isUpdating) return;
    _isUpdating = NO;
    
    [locationManager stopUpdatingLocation];
    
    // let our delegate know we're done
    if (_delegate && [_delegate respondsToSelector:@selector(locationManagerDidUpdateToLocation:fromLocation:)]) [_delegate locationManagerDidUpdateToLocation:newLocation fromLocation:oldLocation];
    
    CLLocation *location = nil;
#if DEBUG_LOCATION
        //    名護 (naha): 26.59154650/127.97731620                    137
        //    宮崎 (Miyazaki) 31.90767360/131.42024110           128
    
            CLLocationCoordinate2D testJapan;
            testJapan.latitude = 33.159600;
            testJapan.longitude = 139.859500;
    location = [[CLLocation alloc] initWithLatitude:33.159600 longitude:139.859500];
#else
    location = [[CLLocation alloc] initWithCoordinate:newLocation.coordinate altitude:newLocation.altitude horizontalAccuracy:newLocation.horizontalAccuracy verticalAccuracy:newLocation.verticalAccuracy timestamp:newLocation.timestamp];
    
    _currentLocation = location;
    
#endif
    float iosDevice = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    if (reverseType == ReverseGoogleAPI || iosDevice >= 6.0)
    {
        [self performSelector:@selector(reverseLocationUseGoogleAPI:) withObject:location afterDelay:DELAY_TIME];
    }
    else {
        [self performSelector:@selector(startReverseGeocoderLocation:) withObject:location afterDelay:DELAY_TIME];
    }
}

#pragma mark -
#pragma mark DELEGATE METHODS FOR REVERSE ADDRESS USE GoogleAPI
//======================================================================
//======================================================================
- (void) reverseLocationUseGoogleAPI:(CLLocation *)newLocation
{
    // Show network activity Indicator (no need really as its very quick)
//    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    // Use Google Service
    // OK the code is verbose to illustrate step by step process
    
    //  Get lat/long from address:
    //    http://maps.google.com/maps/api/geocode/json?address=abcd&sensor=false
    // Form the string to make the call, passing in lat long &language=ja
    NSString *urlString = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&sensor=true", newLocation.coordinate.latitude,newLocation.coordinate.longitude];
    if (dataLanguage == Japanese) {
        urlString = [urlString stringByAppendingString:@"&language=ja"];
    }
    // Turn it into a URL
    NSURL *urlFromURLString = [NSURL URLWithString:urlString];
    
    // Use UTF8 encoding
    NSStringEncoding encodingType = NSUTF8StringEncoding;
    
    // reverseGeoString is what comes back with the goodies
    
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        /********************************************/
        NSString *reverseGeoString = [NSString stringWithContentsOfURL:urlFromURLString encoding:encodingType error:nil];
        
        /********************************************/
        dispatch_async(dispatch_get_main_queue(), ^{
            /********************************************/
            if (reverseGeoString != nil)
            {
                NSDictionary *jsonDict = [reverseGeoString objectFromJSONString];
                NSError *error = nil;
                NSMutableArray *street = nil;
                if ([[jsonDict objectForKey:LOCATION_STATUS] isEqualToString:@"OK"]) {
                    street = [[[jsonDict objectForKey:LOCATION_RESULTS] objectAtIndex:0] objectForKey:@"address_components"];
                }
                else {
                    // Fail
                    error = [[NSError alloc] initWithDomain:@"Location Manager" code:-1 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"ZERO_RESULTS FOR ADDRESS FROM LOCATION",@"MESSAGE", nil]];
                }
                
                if (_delegate && [_delegate respondsToSelector:@selector(locationReversedGoogleAPIWithAddressStreet:jsonResult:error:)])
                    [_delegate locationReversedGoogleAPIWithAddressStreet:street jsonResult:[jsonDict objectForKey:LOCATION_RESULTS] error:error];
            }
            else {
                if (_delegate && [_delegate respondsToSelector:@selector(locationReversedGoogleAPIWithAddressStreet:jsonResult:error:)])
                    [_delegate locationReversedGoogleAPIWithAddressStreet:nil jsonResult:nil error:[NSError errorWithDomain:@"GoogleApI" code:104 userInfo:nil]];
            }
            /********************************************/
        });
        /********************************************/
    });
    
    // If it fails it returns nil
    
}

#pragma mark -
#pragma mark DELEGATE METHODS FOR REVERSE ADDRESS USE MKReverseGeocoder
//======================================================================
//======================================================================
- (void) startReverseGeocoderLocation:(CLLocation *)newLocation
{
//    NSLog(@"__________ %f | %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    float iosDevice = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (iosDevice < 6.0) {
        _geocoder = [[MKReverseGeocoder alloc] initWithCoordinate:newLocation.coordinate];
        [_geocoder setDelegate:self];
        [_geocoder start];
    }
    else {
        CLGeocoder *_clgeocoder = [[CLGeocoder alloc] init];
        [_clgeocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
            for (id sub in placemarks) {
//                NSLog(@"______________ IOS6: %@", sub);
            }
        }];
    }
}

//============================================================
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark
{
    [self performSelector:@selector(delegateFindLocation:) withObject:placemark afterDelay:DELAY_TIME];
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error
{
	[self performSelector:@selector(delegateFindError:) withObject:error afterDelay:DELAY_TIME];
}

- (void) delegateFindLocation:(MKPlacemark *)placemark
{
    if (_delegate && [_delegate respondsToSelector:@selector(locationManagerdidFindPlacemark:error:)])
        [_delegate locationManagerdidFindPlacemark:placemark error:nil];
}
- (void) delegateFindError:(NSError *)error
{
    if (_delegate && [_delegate respondsToSelector:@selector(locationManagerdidFindPlacemark:error:)])
        [_delegate locationManagerdidFindPlacemark:nil error:error];
}
//======================================================================
//======================================================================


@end




@implementation NSString (DNM)

- (BOOL) containsString:(NSString*) _strSearch
{
    NSRange range = [self rangeOfString:_strSearch];
    if (range.location != NSNotFound) {
        return YES;
    }
    return NO;
}

@end



