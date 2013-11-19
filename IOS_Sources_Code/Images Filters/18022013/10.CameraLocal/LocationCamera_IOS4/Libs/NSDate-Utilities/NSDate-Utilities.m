/***********************************************************************
 *	File name:	NSDate-Utilities.m
 *	Project:	
 *	Description:
 *  Author:		Dat Nguyen Mau
 *  Created:    on 8/4/12.
 *	Device:		Iphone vs IPad
 *  Company:	__MyCompanyName__
 *  Copyright:	2012 . All rights reserved.
 ***********************************************************************/


#import "NSDate-Utilities.h"

@implementation NSDate (Utilities)

#pragma mark Relative Dates
- (NSString*) timestampString
{
    return [NSString stringWithFormat:@"%i%i%i%i%i%i",self.day,self.month,self.year,self.hour,self.minute,self.seconds];
}

+ (NSDate *) dateWithDaysFromNow: (NSUInteger) days
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_DAY * days;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;	
}

+ (NSDate *) dateWithDaysBeforeNow: (NSUInteger) days
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_DAY * days;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;	
}

+ (NSDate *) dateToday
{
    return [NSDate date];
}

+ (NSDate *) dateTomorrow
{
	return [NSDate dateWithDaysFromNow:1];
}

+ (NSDate *) dateYesterday
{
	return [NSDate dateWithDaysBeforeNow:1];
}

+ (NSDate *) dateWithHoursFromNow: (NSUInteger) dHours
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_HOUR * dHours;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;	
}

+ (NSDate *) dateWithHoursBeforeNow: (NSUInteger) dHours
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_HOUR * dHours;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;	
}

+ (NSDate *) dateWithMinutesFromNow: (NSUInteger) dMinutes
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_MINUTE * dMinutes;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;		
}

+ (NSDate *) dateWithMinutesBeforeNow: (NSUInteger) dMinutes
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_MINUTE * dMinutes;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;		
}

#pragma mark Comparing Dates
- (BOOL) isEqualToDateIgnoringTimeAndDay: (NSDate *) aDate
{
	NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate];
	return (([components1 year] == [components2 year]) &&
			([components1 month] == [components2 month]));
}

- (BOOL) isEqualToDateIgnoringTime: (NSDate *) aDate
{
	NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate];
	return (([components1 year] == [components2 year]) &&
			([components1 month] == [components2 month]) && 
			([components1 day] == [components2 day]));
}

- (BOOL) isTheSameDate:(NSDate *) dateCmp
{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    NSDateComponents *componentsCmp = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:dateCmp];
    
    if ([components year] == [componentsCmp year] && [components month] == [componentsCmp month] && [components day] == [componentsCmp day])
    {
        if ([components hour] == [componentsCmp hour] && [components minute] == [componentsCmp minute] && [components second] == [componentsCmp second])
        {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL) isToday
{
	return [self isEqualToDateIgnoringTime:[NSDate date]];
}

- (BOOL) isTomorrow
{
	return [self isEqualToDateIgnoringTime:[NSDate dateTomorrow]];
}

- (BOOL) isYesterday
{
	return [self isEqualToDateIgnoringTime:[NSDate dateYesterday]];
}

// This hard codes the assumption that a week is 7 days
- (BOOL) isSameWeekAsDate: (NSDate *) aDate
{
	NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate];
	
	// Must be same week. 12/31 and 1/1 will both be week "1" if they are in the same week
	if ([components1 week] != [components2 week]) return NO;
	
	// Must have a time interval under 1 week. Thanks @aclark
	return (abs([self timeIntervalSinceDate:aDate]) < D_WEEK);
}

- (BOOL) isThisWeek
{
	return [self isSameWeekAsDate:[NSDate date]];
}

- (BOOL) isNextWeek
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_WEEK;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return [self isSameYearAsDate:newDate];
}

- (BOOL) isLastWeek
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_WEEK;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return [self isSameYearAsDate:newDate];
}

- (BOOL) isSameYearAsDate: (NSDate *) aDate
{
	NSDateComponents *components1 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:self];
	NSDateComponents *components2 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:aDate];
	return ([components1 year] == [components2 year]);
}

- (BOOL) isThisYear
{
	return [self isSameWeekAsDate:[NSDate date]];
}

- (BOOL) isNextYear
{
	NSDateComponents *components1 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:self];
	NSDateComponents *components2 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:[NSDate date]];
	
	return ([components1 year] == ([components2 year] + 1));
}

- (BOOL) isLastYear
{
	NSDateComponents *components1 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:self];
	NSDateComponents *components2 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:[NSDate date]];
	
	return ([components1 year] == ([components2 year] - 1));
}

- (BOOL) isEarlierThanDate: (NSDate *) aDate
{
	return ([self earlierDate:aDate] == self);
}

- (BOOL) isLaterThanDate: (NSDate *) aDate
{
	return ([self laterDate:aDate] == self);
}


#pragma mark Adjusting Dates

- (NSDate *) dateByAddDays:(NSInteger)dayAdds
{
    return [self dateByAddingTimeInterval:(D_DAY * dayAdds)];
}

- (NSDate *) dateByAddingDays: (NSUInteger) dDays
{
	NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_DAY * dDays;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;		
}

- (NSDate *) dateBySubtractingDays: (NSUInteger) dDays
{
	return [self dateByAddingDays: (dDays * -1)];
}

- (NSDate *) dateByAddingHours: (NSUInteger) dHours
{
	NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_HOUR * dHours;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;		
}

- (NSDate *) dateBySubtractingHours: (NSUInteger) dHours
{
	return [self dateByAddingHours: (dHours * -1)];
}

- (NSDate *) dateByAddingMinutes: (NSUInteger) dMinutes
{
	NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_MINUTE * dMinutes;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;			
}

- (NSDate *) dateBySubtractingMinutes: (NSUInteger) dMinutes
{
	return [self dateByAddingMinutes: (dMinutes * -1)];
}

- (NSDate *) dateAtStartOfDay
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	[components setHour:0];
	[components setMinute:0];
	[components setSecond:0];
	return [CURRENT_CALENDAR dateFromComponents:components];
}

- (NSDateComponents *) componentsWithOffsetFromDate: (NSDate *) aDate
{
	NSDateComponents *dTime = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate toDate:self options:0];
	return dTime;
}

#pragma mark Retrieving Intervals

- (NSInteger) minutesAfterDate: (NSDate *) aDate
{
	NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
	return (NSInteger) (ti / D_MINUTE);
}

- (NSInteger) minutesBeforeDate: (NSDate *) aDate
{
	NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
	return (NSInteger) (ti / D_MINUTE);
}

- (NSInteger) hoursAfterDate: (NSDate *) aDate
{
	NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
	return (NSInteger) (ti / D_HOUR);
}

- (NSInteger) hoursBeforeDate: (NSDate *) aDate
{
	NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
	return (NSInteger) (ti / D_HOUR);
}

- (NSInteger) daysAfterDate: (NSDate *) aDate
{
	NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
	return (NSInteger) (ti / D_DAY);
}

- (NSInteger) daysBeforeDate: (NSDate *) aDate
{
	NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
	return (NSInteger) (ti / D_DAY);
}

#pragma mark Decomposing Dates

- (NSInteger) nearestHour
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_MINUTE * 30;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	NSDateComponents *components = [CURRENT_CALENDAR components:NSHourCalendarUnit fromDate:newDate];
	return [components hour];
}

- (NSInteger) hour
{
//    NSCalendar *calendar = CURRENT_CALENDAR;
//    [calendar setTimeZone:[NSTimeZone timeZoneForHoursFromGMT:9]];
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    
	return [components hour];
}

- (NSInteger) minute
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return [components minute];
}

- (NSInteger) seconds
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return [components second];
}

- (NSInteger) day
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return [components day];
}

- (NSInteger) month
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return [components month];
}

- (NSInteger) week
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return [components week];
}

- (NSInteger) weekday
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return [components weekday];
}

- (NSInteger) nthWeekday // e.g. 2nd Tuesday of the month is 2
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return [components weekdayOrdinal];
}
- (NSInteger) year
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    
	return [components year];
}

//- (NSUInteger) timeZoneOffset
//{
////    NSUInteger timeZoneOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate] / 3600;
//}

- (NSInteger) daysDistanceWithDate:(NSDate*)withDate
{
    NSTimeInterval time = [self timeIntervalSinceDate:withDate];
    return ((abs(time) / (60.0 * 60.0 * 24.0)) + 0.5);
}
//******************************************************************//
//      Write By: DatNM
//******************************************************************//
+ (NSDate*)nextMonthFromDate:(NSDate*)fromDate
{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:fromDate];
	
    int month = components.month + 1;
    int year = components.year;
    
    [components setDay:15];
    
    if (month > 12) {
        month = 1;
        year = year + 1;
    }
    
    [components setYear:year];
    [components setMonth:month];
    
	return [CURRENT_CALENDAR dateFromComponents:components];
}
+ (NSDate*)prevMonthFromDate:(NSDate*)fromDate
{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:fromDate];
	
    int month = components.month - 1;
    int year = components.year;
    
    [components setDay:15];
    
    if (month < 1) {
        month = 12;
        year = year - 1;
    }
    
    [components setYear:year];
    [components setMonth:month];
    
	return [CURRENT_CALENDAR dateFromComponents:components];
}

+ (NSDate*)nextYearFromDate:(NSDate*)fromDate
{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:fromDate];
	
    int year = components.year + 1;
    
    [components setDay:15];
    
    [components setYear:year];
    
	return [CURRENT_CALENDAR dateFromComponents:components];
}
+ (NSDate*)prevYearFromDate:(NSDate*)fromDate
{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:fromDate];
	
    int year = components.year - 1;
    
    [components setDay:15];
    
    [components setYear:year];
    
	return [CURRENT_CALENDAR dateFromComponents:components];
}

- (NSDate*)nextMonthFromSelf
{
    return [NSDate nextMonthFromDate:self];
}
- (NSDate*)prevMonthFromSelf
{
    return [NSDate prevMonthFromDate:self];
}
- (NSDate*)nextYearFromSelf
{
    return [NSDate nextYearFromDate:self];
}
- (NSDate*)prevYearFromSelf
{
    return [NSDate prevYearFromDate:self];
}

- (NSUInteger) numberOfDaysInMonth
{
    return [CURRENT_CALENDAR rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:self].length;
}

+ (NSString *) dayOfWeekString:(NSDate *) fromDate
{
    NSDateFormatter *weekDay = [[NSDateFormatter alloc] init];
    [weekDay setDateFormat:@"EEE"];
    
    NSString *appLang =[[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleDevelopmentRegion"];
    NSLocale *jaLocale = [[NSLocale alloc] initWithLocaleIdentifier:appLang];
    [weekDay setLocale:jaLocale];
    
    return [weekDay stringFromDate:fromDate];
}

- (NSString*)dayOfWeekStringVi
{
    if (self.weekday == 1) return @"Chủ nhật";
    if (self.weekday == 2) return @"Thứ hai";
    if (self.weekday == 3) return @"Thứ ba";
    if (self.weekday == 4) return @"Thứ tư";
    if (self.weekday == 5) return @"Thứ năm";
    if (self.weekday == 6) return @"Thứ sáu";
    if (self.weekday == 7) return @"Thứ bảy";
    
    return @"UnKnow";
}

- (NSString*) stringFromDateWithFormat:(NSString*) formatStr andTimeZone:(NSTimeZone *) timeZone
{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if (timeZone) [dateFormatter setTimeZone:timeZone];
    else [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
	if (formatStr) [dateFormatter setDateFormat:formatStr];
    else [dateFormatter setDateFormat:STRING_FROM_DATE];
    
	return [dateFormatter stringFromDate:self];
}

- (NSUInteger) dayOfYear
{	
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents* components = [gregorian components:(NSYearCalendarUnit)
												fromDate:self];
	
	NSDateComponents* startOfYearComponents = [[NSDateComponents alloc] init];
	[startOfYearComponents setYear:[components year]];
	[startOfYearComponents setMonth:1];
	[startOfYearComponents setDay:1];
	NSDate* firstDayOfYear = [gregorian dateFromComponents:startOfYearComponents];
	NSUInteger days = [self daysAfterDate:firstDayOfYear];
	
	return (days + 1);
}

- (NSDate *) dateToTimeZoneFromCurrentTimeZone:(NSTimeZone *) toTimeZone
{
    float hourOffsetFromTimeZone = [[CURRENT_CALENDAR timeZone] secondsFromGMT]/3600;
    float hourOffsetToTimeZone = [toTimeZone secondsFromGMT]/3600;
    
    return [self dateByAddingHours:(hourOffsetToTimeZone - hourOffsetFromTimeZone)];
}

+ (NSDate*) dateWithYear:(NSInteger) _year month:(NSInteger) _month day:(NSInteger) _day
{
    return [self dateWithYear:_year month:_month day:_day hour:-1 minute:-1 second:-1];
}

+ (NSDate*) dateWithYear:(NSInteger) _year month:(NSInteger) _month day:(NSInteger) _day hour:(NSInteger) _hour minute:(NSInteger) _min second:(NSInteger) _sec
{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:[NSDate dateToday]];
    
//    [components setTimeZone:[NSTimeZone timeZoneForHoursFromGMT:7]];
    
	if (_year >= 0)  [components setYear:_year];
    if (_month > 0) [components setMonth:_month];
    if (_day > 0)   [components setDay:_day];
    if (_hour >= 0)  [components setHour:_hour];
	if (_min >= 0)   [components setMinute:_min];
	if (_sec >= 0)   [components setSecond:_sec];
	return [CURRENT_CALENDAR dateFromComponents:components];
}

+ (NSDate*) dateFromHourString:(NSString*)stringHour withTimeZone:(NSTimeZone*)timeZone
{
    NSDate *today = [NSDate dateToday];
    
    NSString *strDate = [NSString stringWithFormat:@"%i/%i/%i-%@",today.year,today.month,today.day,stringHour];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
	[dateFormatter setDateFormat:@"yyyy/MM/dd-HH:mm:ss"];
    if (!timeZone)
        [dateFormatter setTimeZone:[CURRENT_CALENDAR timeZone]];
    else
        [dateFormatter setTimeZone:timeZone];
    // Convert NSString to NSDate
    NSDate *firstDate = [dateFormatter dateFromString:strDate];
    
    return firstDate;
}

//******************************************************************//
//******************************************************************//
- (void) LogDateWithFormat:(NSString*)_frmt andTimeZone:(NSTimeZone*)timeZone
{
    if (_frmt) {
        NSLog(@"%@: %@ GMT+%i",_frmt,[self stringFromDateWithFormat:STRING_FROM_DATE andTimeZone:timeZone],[timeZone secondsFromGMT]/D_HOUR);
    }
    else {
        NSLog(@"%@ GMT+%i",[self stringFromDateWithFormat:STRING_FROM_DATE andTimeZone:timeZone],[timeZone secondsFromGMT]/D_HOUR);
    }
}
// TuanDV
+ (NSDate*) dateFromMonthAndDayString:(NSString*) monthDay withSeparated:(NSString*) _separated
{
    NSArray *arr = [monthDay componentsSeparatedByString:_separated];
    if (arr.count == 2) {                                                                                          
        return [NSDate dateWithYear:-1 month:[[arr objectAtIndex:0] integerValue] day:[[arr objectAtIndex:1] integerValue] hour:-1 minute:-1 second:-1];
    }
    else {
        return [NSDate dateWithYear:-1 month:-1 day:-1 hour:-1 minute:-1 second:-1];
    }
}

@end




//******************************************************************//
//      Write By: DatNM
//******************************************************************//
@implementation NSTimeZone (Utilities)

+(NSTimeZone*)timeZoneForHoursFromGMT:(NSInteger)hours
{
	return [NSTimeZone timeZoneForSecondsFromGMT:hours*60*60];
}

@end




@implementation NSString (Utilities)

- (NSString *) stringByAppends:(id) first, ... NS_REQUIRES_NIL_TERMINATION
{
    NSMutableString *newContentString = [NSMutableString string];
    [newContentString appendString:first];
    va_list args;
    va_start(args, first);
    NSString * title = nil;
    while((title = va_arg(args,NSString*))) {
        [newContentString appendString:title];
    }
    va_end(args);

    return newContentString;
}

@end











