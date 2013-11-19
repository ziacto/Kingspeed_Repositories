/***********************************************************************
 *	File name:	TimeFormatters.h
 *	Project:	
 *	Description:
 *  Author:		Dat Nguyen Mau
 *  Created:    on 8/4/12.
 *	Device:		Iphone vs IPad
 *  Company:	__MyCompanyName__
 *  Copyright:	2012 . All rights reserved.
 ***********************************************************************/


#import <Foundation/Foundation.h>


typedef enum IntervalFormatterStyle {
    kIntervalFormatterDecimalStyle,
    kIntervalFormatterShortStyle,
    kIntervalFormatterMediumStyle,
    kIntervalFormatterAbbrLongStyle,
    kIntervalFormatterLongStyle
} IntervalFormatterStyle;


@interface IntervalFormatter : NSFormatter {
    IntervalFormatterStyle style;
}
@property (nonatomic, assign) IntervalFormatterStyle style;
@end


@interface DateComponentsFormatter : NSFormatter {
    NSDateFormatter *formatter;
    NSDateFormatterStyle dateStyle;
    NSDateFormatterStyle timeStyle;
}
@property (nonatomic, assign) NSDateFormatterStyle dateStyle;
@property (nonatomic, assign) NSDateFormatterStyle timeStyle;
@end


@interface IntervalComponentsFormatter : NSFormatter {
    IntervalFormatterStyle style;
}
@property (nonatomic, assign) IntervalFormatterStyle style;
@end


@interface MinutesFormatter : NSFormatter {
    IntervalFormatterStyle style;
}
@property (nonatomic, assign) IntervalFormatterStyle style;
@end


@interface HoursFormatter : NSFormatter {
    IntervalFormatterStyle style;
}
@property (nonatomic, assign) IntervalFormatterStyle style;
@end


@interface DaysFormatter : NSFormatter {
    IntervalFormatterStyle style;
}
@property (nonatomic, assign) IntervalFormatterStyle style;
@end

