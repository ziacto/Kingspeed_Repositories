//
//  
//  
//
//  Created by Andrea Finollo on 26/09/12.
//  Copyright (c) 2012 Andrea Finollo. All rights reserved.
//


/*
 Modified by DatNM 4/6/2013 for Non ARC project.
 */

#import "DLRouteDirections.h"
#import <MapKit/MapKit.h>

#define DL_RELEASE(object) \
if(object)[object release]; object = nil;

@interface DLRouteDirections ()

//DATA FOR ROUTING
@property (retain, nonatomic) NSDictionary * duration;
@property (retain, nonatomic) NSDictionary * distance;
@property (retain, nonatomic) NSMutableArray * routes;
@property (copy, nonatomic) NSString * overviewPolyLine;
@property (retain, nonatomic) NSMutableArray * polylinePointsLocations;
@property (retain, nonatomic) NSMutableArray * legs;
@property (retain, nonatomic) NSMutableArray * steps;
@property (retain, nonatomic) CLLocation * startPoint;
@property (retain, nonatomic) CLLocation * endPoint;
@property (retain, nonatomic) NSMutableArray * directions;
@property (retain, nonatomic) MKPolyline * line;

//DATA FOR ADDRESS VALIDATION
@property (retain, nonatomic) NSMutableArray * formattedAddresses;
@property (retain, nonatomic) NSMutableArray * addressesGPSLocations;


@property (copy, nonatomic) DLRouteDirectionsWeakSelfWithResponse callBackBlock;
@property (copy, nonatomic) DLAddressValidationObjectWeakSelfWithResponse validationCallBackBlock;


- (NSError*) createData:(NSDictionary *)response;
- (NSURL*)generateURL:(NSString*)serviceURL params:(NSDictionary*)params;
- (NSMutableArray *)decodePolyLine:(NSString *)encodedStr;
- (MKPolyline *) createMKPolylineAnnotation;

@end

@implementation DLRouteDirections
@synthesize duration = _duration;
@synthesize distance = _distance;
@synthesize routes = _routes;
@synthesize overviewPolyLine = _overviewPolyLine;
@synthesize polylinePointsLocations = _polylinePointsLocations;
@synthesize legs = _legs;
@synthesize steps = _steps;
@synthesize endPoint = _endPoint;
@synthesize startPoint = _startPoint;
@synthesize directions = _directions;
@synthesize line = _line;

@synthesize addressesGPSLocations = _addressesGPSLocations;
@synthesize formattedAddresses = _formattedAddresses;

@synthesize callBackBlock = _callBackBlock;
@synthesize validationCallBackBlock = _validationCallBackBlock;


- (void) createDirectionRequestWithStartPoint:(NSString*)aStartPoint andEndPoint:(NSString*)anEndPoint  withCallBackBlock:(DLRouteDirectionsWeakSelfWithResponse)aBlock{

    self.callBackBlock = aBlock;
    DLRouteDirections *weakSelf = self;
    
    NSMutableString * string = [NSMutableString stringWithFormat: @"http://maps.googleapis.com/maps/api/directions/json"];
    NSMutableDictionary *parameters = [[[NSMutableDictionary alloc] init] autorelease];
    [parameters setObject:[NSString stringWithFormat:@"%@", aStartPoint] forKey:@"origin"];
    [parameters setObject:[NSString stringWithFormat:@"%@", anEndPoint] forKey:@"destination"];
    [parameters setObject:@"true" forKey:@"sensor"];
    [parameters setObject:([[[NSLocale preferredLanguages]objectAtIndex:0] isEqualToString:@"it"] ? @"it" : @"en") forKey:@"language"];
    [parameters setObject:@"driving" forKey:@"mode"];
    
    NSURL * requestURL = [self generateURL:string params:parameters];

    NSURLRequest * req = [[[NSURLRequest alloc]initWithURL:requestURL] autorelease];
    
    [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * response, NSData * data, NSError * error) {
        if (weakSelf && weakSelf.callBackBlock) {
            if (error) {
                weakSelf.callBackBlock(error, nil, nil, nil, nil, nil, nil, nil, nil);
                return ;
            }
            id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            if (error) {
                weakSelf.callBackBlock(error, nil, nil, nil, nil, nil, nil, nil, nil);
                return ;
            }
            NSError *error__ = [weakSelf createData:object];
            if (error__ ) {
                if (error__.code == 300){
                    
                    weakSelf.callBackBlock(nil, self.distance, self.duration, nil, self.routes, self.steps, self.startPoint, self.endPoint, self.directions);
                    return;
                }
                else{
                    weakSelf.callBackBlock(error__, nil, nil, nil, nil, nil, nil, nil, nil);
                    return ;
                }
            }
            weakSelf.callBackBlock(nil, self.distance, self.duration, self.line, self.routes, self.steps, self.startPoint, self.endPoint, self.directions);
        }
        else {
            
        }
    }];
}


- (void) validateAddress:(NSString*)anAddress withCallBackBlock:(DLAddressValidationObjectWeakSelfWithResponse)aBlock
{
    self.validationCallBackBlock = aBlock;
    DLRouteDirections * weakSelf = self;
    
    NSMutableString * string = [NSMutableString stringWithFormat: @"http://maps.googleapis.com/maps/api/geocode/json"];
    NSMutableDictionary *parameters = [[[NSMutableDictionary alloc] init] autorelease];
    [parameters setObject:[NSString stringWithFormat:@"%@", anAddress] forKey:@"address"];
    [parameters setObject:@"true" forKey:@"sensor"];
    
    NSURL * requestURL = [self generateURL:string params:parameters];

    NSURLRequest * req = [[NSURLRequest alloc]initWithURL:requestURL];
    
    [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * response, NSData * data, NSError * error) {
        if (weakSelf && weakSelf.validationCallBackBlock) {
            if (error) {
                weakSelf.validationCallBackBlock(error, nil, nil, nil);
                return ;
            }
            id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            if (error) {
                weakSelf.validationCallBackBlock(error, nil, nil, nil);
                return ;
            }

            NSString * addressStatus = [object objectForKey:@"status"];
            if (![addressStatus isEqualToString:@"OK"]) {
                NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
                [errorDetail setValue:@"Invalid address" forKey:NSLocalizedDescriptionKey];
                error = [NSError errorWithDomain:@"it.cloudintouch.routedirectionsobject" code:300 userInfo:errorDetail];
                weakSelf.validationCallBackBlock(error, addressStatus, nil, nil);
                return;
            }
            NSArray * results = [object objectForKey:@"results"];
            self.formattedAddresses = [results valueForKeyPath:@"formatted_address"];
            NSArray * geometries = [results valueForKeyPath:@"geometry"];
            
            DL_RELEASE (_addressesGPSLocations);
            _addressesGPSLocations = [[NSMutableArray alloc] initWithCapacity:50];
            
            for (NSDictionary * locationDict in geometries) {
                CLLocation * addressGPS = [[[CLLocation alloc]initWithLatitude: [[locationDict objectForKey:@"lat"]doubleValue] longitude: [[locationDict objectForKey:@"lng"]doubleValue]] autorelease];
                [_addressesGPSLocations addObject:addressGPS];
            }
            
            weakSelf.validationCallBackBlock(nil, addressStatus, self.formattedAddresses, self.addressesGPSLocations);
        }
    }];
}

- (void) validateViaAddress:(NSString*)anAddress withCallBackBlock:(DLAddressValidationObjectWeakSelfWithResponse)aBlock
{
    [self validateAddress:[NSString stringWithFormat:@"Via %@",anAddress] withCallBackBlock:aBlock];
}

//============================================================================
- (NSError*) createData:(NSDictionary *)response
{
    if (_routes) {
        [_routes release];
        _routes = nil;
    }
    
    NSError *anError = nil;
    _routes = [[response objectForKey:@"routes"] retain];
    
    if (![self.routes count]) {
        NSMutableDictionary *errorDetail = [[[NSMutableDictionary alloc] init] autorelease];
        [errorDetail setValue:@"No routes in the response" forKey:NSLocalizedDescriptionKey];
        anError = [[[NSError alloc] initWithDomain:@"it.cloudintouch.routedirectionsobject" code:100 userInfo:errorDetail] autorelease];
        return anError;
    }
    
    self.legs = [[self.routes objectAtIndex:0] valueForKeyPath:@"legs"];
    self.steps = [[self.legs objectAtIndex:0] valueForKeyPath:@"steps"];
    self.duration = [[self.legs valueForKeyPath:@"duration"]lastObject];
    self.distance = [[self.legs valueForKeyPath:@"distance"]lastObject];
    
    NSDictionary * startPointDict = [[self.legs valueForKeyPath:@"start_location"]lastObject];
    NSDictionary * endPointDict = [[self.legs valueForKeyPath:@"end_location"]lastObject];
    
    DL_RELEASE(_startPoint);
    DL_RELEASE(_endPoint);
    _startPoint = [[CLLocation alloc]initWithLatitude:[[startPointDict objectForKey:@"lat" ]doubleValue] longitude:[[startPointDict objectForKey:@"lng" ]doubleValue]];
    _endPoint = [[CLLocation alloc]initWithLatitude:[[endPointDict objectForKey:@"lat" ]doubleValue]  longitude:[[endPointDict objectForKey:@"lng" ]doubleValue]];
    
    NSDictionary *route = [_routes objectAtIndex:0];
    if (route) {
        self.overviewPolyLine = [[[self.routes valueForKeyPath: @"overview_polyline"] valueForKeyPath:@"points"]objectAtIndex:0];
        
        DL_RELEASE(_polylinePointsLocations);
        _polylinePointsLocations = [[self decodePolyLine:_overviewPolyLine] retain];
        
        CLLocation * endPointPoly = [_polylinePointsLocations lastObject];
        float threshold = [self.endPoint distanceFromLocation:endPointPoly];
        if (fabs(threshold) > 1000) {
            NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
            [errorDetail setValue:@"Inconsistent polyline" forKey:NSLocalizedDescriptionKey];
            anError = [[[NSError alloc] initWithDomain:@"it.cloudintouch.routedirectionsobject" code:300 userInfo:errorDetail] autorelease];
        }
        
        self.directions = [self.steps valueForKeyPath:@"html_instructions"];
        DL_RELEASE(_line);
        _line = [[self createMKPolylineAnnotation] retain];
    }
    else{
        NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
        [errorDetail setValue:@"No route in the response" forKey:NSLocalizedDescriptionKey];
        anError = [[[NSError alloc] initWithDomain:@"it.cloudintouch.routedirectionsobject" code:200 userInfo:errorDetail] autorelease];
    }
    
    return anError;
}


- (MKPolyline *) createMKPolylineAnnotation{
    NSInteger numberOfSteps = [self.polylinePointsLocations count];
    
    CLLocationCoordinate2D coordinates[numberOfSteps];
    for (NSInteger index = 0; index < numberOfSteps; index++) {
        CLLocation *location = [self.polylinePointsLocations objectAtIndex:index];
        CLLocationCoordinate2D coordinate = location.coordinate;
        
        coordinates[index] = coordinate;
    }
    
    return  [MKPolyline polylineWithCoordinates:coordinates count:numberOfSteps];
}

-(NSMutableArray *)decodePolyLine:(NSString *)encodedStr {
    
    NSMutableString *encoded = [[[NSMutableString alloc] initWithCapacity:[encodedStr length]] autorelease];
    [encoded appendString:encodedStr];
    [encoded replaceOccurrencesOfString:@"\\\\" withString:@"\\"
                                options:NSLiteralSearch
                                  range:NSMakeRange(0, [encoded length])];
    NSInteger len = [encoded length];
    NSInteger index = 0;
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSInteger lat=0;
    NSInteger lng=0;
    while (index < len) {
        NSInteger b;
        NSInteger shift = 0;
        NSInteger result = 0;
        do {
            b = [encoded characterAtIndex:index++] - 63;
            result |= (b & 0x1f) << shift;
            shift += 5;
        } while (b >= 0x20);
        NSInteger dlat = ((result & 1) ? ~(result >> 1) : (result >> 1));
        lat += dlat;
        shift = 0;
        result = 0;
        do {
            b = [encoded characterAtIndex:index++] - 63;
            result |= (b & 0x1f) << shift;
            shift += 5;
        } while (b >= 0x20);
        NSInteger dlng = ((result & 1) ? ~(result >> 1) : (result >> 1));
        lng += dlng;
        NSNumber *latitude = [[[NSNumber alloc] initWithFloat:lat * 1e-5] autorelease];
        NSNumber *longitude = [[[NSNumber alloc] initWithFloat:lng * 1e-5] autorelease];
        
        CLLocation *location = [[[CLLocation alloc] initWithLatitude:[latitude floatValue] longitude:[longitude floatValue]] autorelease];
        [array addObject:location];
    }
    
    return [array autorelease];
}


- (NSURL*)generateURL:(NSString*)serviceURL params:(NSDictionary*)params {
    NSString * composedURL = serviceURL;
    if (params) {
        NSMutableArray* pairs = [NSMutableArray array];
        for (NSString* key in params.keyEnumerator) {
            NSString* value = [params objectForKey:key];
            if (!value) {
                continue;
            }
            NSString* escaped_value = (  NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, ( CFStringRef)value, NULL,(CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
            
            [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, escaped_value]];
            CFRelease(escaped_value);
        }
        
        NSString* query = [pairs componentsJoinedByString:@"&"];
        NSString* url = [NSString stringWithFormat:@"%@?%@", composedURL, query];
        
        return [NSURL URLWithString:url];
    } else {
        return [NSURL URLWithString:composedURL];
    }
}


@end
