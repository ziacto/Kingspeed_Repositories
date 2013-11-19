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

#define  YAHOO_WEATHER_API   @"http://weather.yahooapis.com/forecastrss?w=1236594&u=c"
#define  YAHOO_WOEID_API     @"http://where.yahooapis.com/geocode?location=37.42,-122.12&flags=J&gflags=R&appid=zHgnBS4m"

// hoang ngan: http://weather.yahooapis.com/forecastrss?w=1236594&u=c

#import "WeatherAPIData.h"
#import "XMLDictionary.h"

@implementation WeatherAPIData

+(void)getWeatherYahooWithLatitude:(double)latitude longitude:(double)longitude completion:(WeatherAPIDataCompletionHandler)completion
{
    [self getWoeidYahooWithLatitude:latitude longitude:longitude completion:completion];
}

+(void)getWeatherYahooWithWoeid:(NSInteger)woeid__ trueWoeid:(BOOL)trueWoeid completion:(WeatherAPIDataCompletionHandler)completion
{
    if (trueWoeid) {
        NSString *stRequest = [NSString stringWithFormat:@"http://weather.yahooapis.com/forecastrss?w=%i&u=c",woeid__];
        NSLog(@"___________ %@", stRequest);
        dispatch_async(dispatch_get_global_queue(0,0), ^{
            /********************************************/
            NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:stRequest] encoding:NSUTF8StringEncoding error:nil];
            
            NSDictionary *dict = [NSDictionary dictionaryWithXMLString:result];
            
            /********************************************/
            dispatch_async(dispatch_get_main_queue(), ^{
                /********************************************/
                if (dict) {
                    completion(result, [[dict objectForKey:@"channel"] objectForKey:@"item"]);
                }
                else {
                    completion(result ,nil);
                }
                /********************************************/
            });
            /********************************************/
        });
    }
    else {
        completion(nil,nil);
    }
}


+(void)getWoeidYahooWithLatitude:(double)latitude longitude:(double)longitude completion:(WeatherAPIDataCompletionHandler)completion
{
    NSString *stRequest = [NSString stringWithFormat:@"http://where.yahooapis.com/geocode?location=%f,%f&flags=J&gflags=R&appid=zHgnBS4m",latitude,longitude];
 
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        /********************************************/
        NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:stRequest] encoding:NSUTF8StringEncoding error:nil];
        NSDictionary *jsonDict = [result objectFromJSONString];
        /********************************************/
        dispatch_async(dispatch_get_main_queue(), ^{
            /********************************************/
            if (jsonDict != nil)
            {
                NSInteger woeid__ = [[[[[jsonDict objectForKey:@"ResultSet"] objectForKey:@"Results"] objectAtIndex:0] objectForKey:@"woeid"] integerValue];
                [self getWeatherYahooWithWoeid:woeid__ trueWoeid:YES completion:completion];
            }
            else {
                [self getWeatherYahooWithWoeid:0 trueWoeid:NO completion:completion];
            }
            /********************************************/
        });
        /********************************************/
    });
}

@end
