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

#import <Foundation/Foundation.h>
#import "JSONKit.h"

typedef void(^WeatherAPIDataCompletionHandler)(NSString*xmlWeather, NSDictionary* dictData);

@interface WeatherAPIData : NSObject

+(void)getWeatherYahooWithLatitude:(double)latitude longitude:(double)longitude completion:(WeatherAPIDataCompletionHandler)completion;

@end
