/***********************************************************************
 *	File name:	NSDate-Utilities.h
 *	Project:	DLBaseClassFramework
 *	Description:
 *  Author:		Dat Nguyen Mau
 *  Created:    on 8/4/12.
 *	Device:		Iphone vs IPad
 *  Company:	__MyCompanyName__
 *  Copyright:	2012 . All rights reserved.
 ***********************************************************************/


#import <Foundation/Foundation.h>
#import <DLBaseClassAdditions/TimeFormatters.h>

#define DATE_COMPONENTS (NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit)
#define GREGORIAN_CALENDAR [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease]


#define D_MINUTE	60.
#define D_HOUR		3600.
#define D_DAY		86400.
#define D_WEEK		604800.
#define D_YEAR		31556926.

#define DAY_STRING          @"dd"
#define MONTH_STRING        @"MM"
#define YEAR_STRING         @"yyyy"
#define HOUR_STRING12       @"hh"
#define HOUR_STRING24       @"HH"
#define MINUTE_STRING       @"mm"
#define SECOND_STRING       @"ss"
#define WEEK_OF_YEAR        @"w"
#define DAY_OF_WEEK         @"EEE"
#define STRING_FROM_DATE    @"yyyy-MM-dd HH:mm:ss"
#define STRING_FROM_DATE_TIMEZONE    @"yyyy-MM-dd HH:mm:ss z"
#define DATE_STRING         @"yyyy-MM-dd"
#define TIME_STRING         @"HH:mm:ss"


@interface NSDate (DLDate)

// Relative dates from the current date
- (NSString*) timestampString;
+ (NSDate *) dateToday;
+ (NSDate *) dateTomorrow;
+ (NSDate *) dateYesterday;
+ (NSDate *) dateWithDaysFromNow: (NSUInteger) days;
+ (NSDate *) dateWithDaysBeforeNow: (NSUInteger) days;
+ (NSDate *) dateWithHoursFromNow: (NSUInteger) dHours;
+ (NSDate *) dateWithHoursBeforeNow: (NSUInteger) dHours;
+ (NSDate *) dateWithMinutesFromNow: (NSUInteger) dMinutes;
+ (NSDate *) dateWithMinutesBeforeNow: (NSUInteger) dMinutes;

// Comparing dates
- (BOOL) isEqualToDateIgnoringTimeAndDay: (NSDate *) aDate;
- (BOOL) isEqualToDateIgnoringTime: (NSDate *) aDate;
- (BOOL) isTheSameDate:(NSDate *) dateCmp;
- (BOOL) isToday;
- (BOOL) isTomorrow;
- (BOOL) isYesterday;
- (BOOL) isSameWeekAsDate: (NSDate *) aDate;
- (BOOL) isThisWeek;
- (BOOL) isNextWeek;
- (BOOL) isLastWeek;
- (BOOL) isSameYearAsDate: (NSDate *) aDate;
- (BOOL) isThisYear;
- (BOOL) isNextYear;
- (BOOL) isLastYear;
- (BOOL) isEarlierThanDate: (NSDate *) aDate;
- (BOOL) isLaterThanDate: (NSDate *) aDate;

// Adjusting dates
- (NSDate *) dateByAddDays:(NSInteger)dayAdds;
- (NSDate *) dateByAddingDays: (NSUInteger) dDays;
- (NSDate *) dateBySubtractingDays: (NSUInteger) dDays;
- (NSDate *) dateByAddingHours: (NSUInteger) dHours;
- (NSDate *) dateBySubtractingHours: (NSUInteger) dHours;
- (NSDate *) dateByAddingMinutes: (NSUInteger) dMinutes;
- (NSDate *) dateBySubtractingMinutes: (NSUInteger) dMinutes;
- (NSDate *) dateAtStartOfDay;

// Retrieving intervals
- (NSInteger) minutesAfterDate: (NSDate *) aDate;
- (NSInteger) minutesBeforeDate: (NSDate *) aDate;
- (NSInteger) hoursAfterDate: (NSDate *) aDate;
- (NSInteger) hoursBeforeDate: (NSDate *) aDate;
- (NSInteger) daysAfterDate: (NSDate *) aDate;
- (NSInteger) daysBeforeDate: (NSDate *) aDate;

- (NSInteger) daysDistanceWithDate:(NSDate*)withDate;
//******************************************************************//
//      Write By: DatNM
//******************************************************************//
+ (BOOL)yearIsLeap:(NSInteger)year;
- (BOOL)isLeapYear;

+ (NSDate*)nextMonthFromDate:(NSDate*)fromDate;
+ (NSDate*)prevMonthFromDate:(NSDate*)fromDate;
+ (NSDate*)nextYearFromDate:(NSDate*)fromDate;
+ (NSDate*)prevYearFromDate:(NSDate*)fromDate;

- (NSDate*)nextMonthFromSelf;
- (NSDate*)prevMonthFromSelf;
- (NSDate*)nextYearFromSelf;
- (NSDate*)prevYearFromSelf;

- (NSString*)dayOfWeekStringVi;
- (NSString*)dayOfWeekStringJP;
- (NSString*)dayOfWeekStringEN;

- (NSUInteger) numberOfDaysInMonth;
+ (NSString *) dayOfWeekString:(NSDate *) fromDate;
- (NSString*) stringFromDateWithFormat:(NSString*) formatStr andTimeZone:(NSTimeZone *) timeZone;
- (NSUInteger) dayOfYear;
- (NSDate *) dateToTimeZoneFromCurrentTimeZone:(NSTimeZone *) toTimeZone;

// if year, month, day, hour, min, second input < 0, the date will be current date,
+ (NSDate*)dateWithHour:(int)hour min:(int)min second:(int)second;
+ (NSDate*) dateWithYear:(NSInteger) _year month:(NSInteger) _month day:(NSInteger) _day;
+ (NSDate*) dateWithYear:(NSInteger) _year month:(NSInteger) _month day:(NSInteger) _day hour:(NSInteger) _hour minute:(NSInteger) _min second:(NSInteger) _sec;

+ (NSDate*) dateFromHourString:(NSString*)stringHour withTimeZone:(NSTimeZone*)timeZone;
//******************************************************************//
//******************************************************************//
- (void) LogDateWithFormat:(NSString*)_frmt andTimeZone:(NSTimeZone*)timeZone;
+ (NSDate*) dateFromMonthAndDayString:(NSString*) monthDay withSeparated:(NSString*) _separated;
// Decomposing dates
@property (readonly) NSInteger nearestHour;
@property (readonly) NSInteger hour;
@property (readonly) NSInteger minute;
@property (readonly) NSInteger seconds;
@property (readonly) NSInteger day;
@property (readonly) NSInteger month;
@property (readonly) NSInteger week;
@property (readonly) NSInteger weekday;
@property (readonly) NSInteger nthWeekday; // e.g. 2nd Tuesday of the month == 2
@property (readonly) NSInteger year;

@end



//******************************************************************//
//      Write By: DatNM
//******************************************************************//
@interface NSTimeZone (DLTimeZone)

+(NSTimeZone*)timeZoneForHoursFromGMT:(NSInteger)hours;

@end




//NSDate format string in Objective C
//
//The following format strings can be use to format your date using NSDateFormatter:
//
//a:    AM/PM
//A:    0~86399999 (Millisecond of Day)
//
//c/cc:    1~7 (Day of Week)
//ccc:    Sun/Mon/Tue/Wed/Thu/Fri/Sat
//cccc:    Sunday/Monday/Tuesday/Wednesday/Thursday/Friday/Saturday
//
//d:    1~31 (0 padded Day of Month)
//D:    1~366 (0 padded Day of Year)
//
//e:    1~7 (0 padded Day of Week)
//E~EEE:    Sun/Mon/Tue/Wed/Thu/Fri/Sat
//EEEE:    Sunday/Monday/Tuesday/Wednesday/Thursday/Friday/Saturday
//
//F:    1~5 (0 padded Week of Month, first day of week = Monday)
//
//g:    Julian Day Number (number of days since 4713 BC January 1)
//G~GGG:    BC/AD (Era Designator Abbreviated)
//GGGG:    Before Christ/Anno Domini
//
//h:    1~12 (0 padded Hour (12hr))
//H:    0~23 (0 padded Hour (24hr))
//
//k:    1~24 (0 padded Hour (24hr)
//            K:    0~11 (0 padded Hour (12hr))
//            
//            L/LL:    1~12 (0 padded Month)
//            LLL:    Jan/Feb/Mar/Apr/May/Jun/Jul/Aug/Sep/Oct/Nov/Dec
//            LLLL:    January/February/March/April/May/June/July/August/September/October/November/December
//            
//            m:    0~59 (0 padded Minute)
//            M/MM:    1~12 (0 padded Month)
//            MMM:    Jan/Feb/Mar/Apr/May/Jun/Jul/Aug/Sep/Oct/Nov/Dec
//            MMMM:    January/February/March/April/May/June/July/August/September/October/November/December
//            
//            q/qq:    1~4 (0 padded Quarter)
//            qqq:    Q1/Q2/Q3/Q4
//            qqqq:    1st quarter/2nd quarter/3rd quarter/4th quarter
//            Q/QQ:    1~4 (0 padded Quarter)
//            QQQ:    Q1/Q2/Q3/Q4
//            QQQQ:    1st quarter/2nd quarter/3rd quarter/4th quarter
//            
//            s:    0~59 (0 padded Second)
//            S:    (rounded Sub-Second)
//            
//            u:    (0 padded Year)
//            
//            v~vvv:    (General GMT Timezone Abbreviation)
//            vvvv:    (General GMT Timezone Name)
//            
//            w:    1~53 (0 padded Week of Year, 1st day of week = Sunday, NB: 1st week of year starts from the last Sunday of last year)
//            W:    1~5 (0 padded Week of Month, 1st day of week = Sunday)
//            
//            y/yyyy:    (Full Year)
//            yy/yyy:    (2 Digits Year)
//            Y/YYYY:    (Full Year, starting from the Sunday of the 1st week of year)
//            YY/YYY:    (2 Digits Year, starting from the Sunday of the 1st week of year)
//            
//            z~zzz:    (Specific GMT Timezone Abbreviation)
//            zzzz:    (Specific GMT Timezone Name)
//            Z:    +0000 (RFC 822 Timezone)

