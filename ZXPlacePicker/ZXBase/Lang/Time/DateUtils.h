//
// DateUtils.h
// GoToBus
//
// Created by haibara on 12/5/14.
//
//

@import Foundation;
@import UIKit;

typedef NS_ENUM (NSInteger, DayOfWeek) {
	DayOfWeekSunday = 1,
	DayOfWeekMonday = 2,
	DayOfWeekTuesday = 3,
	DayOfWeekWednesday = 4,
	DayOfWeekThursday = 5,
	DayOfWeekFriday = 6,
	DayOfWeekSaturday = 7,
};

@interface DateUtils : NSObject

+ (NSDate *)add:(NSDate *)date unit:(NSCalendarUnit)unit amount:(NSInteger)amount;
+ (NSDate *)addYears:(NSDate *)date amount:(NSInteger)amount;
+ (NSDate *)addMonths:(NSDate *)date amount:(NSInteger)amount;
+ (NSDate *)addDays:(NSDate *)date amount:(NSInteger)amount;
+ (NSDate *)addHours:(NSDate *)date amount:(NSInteger)amount;
+ (NSDate *)addMinutes:(NSDate *)date amount:(NSInteger)amount;
+ (NSDate *)addSeconds:(NSDate *)date amount:(NSInteger)amount;

+ (NSDate *)parseDate:(NSString *)str parsePatterns:(NSString *)firstParsePattern, ...NS_REQUIRES_NIL_TERMINATION;
+ (NSDate *)parseDate:(NSString *)str locale:(NSLocale *)locale parsePatterns:(NSString *)firstParsePattern, ...NS_REQUIRES_NIL_TERMINATION;

+ (NSInteger)getFragment:(NSDate *)date unit:(NSCalendarUnit)unit;

+ (NSDate *)truncate:(NSDate *)date unit:(NSCalendarUnit)unit;
+ (NSComparisonResult)truncated:(NSDate *)date1 compareTo:(NSDate *)date2 unit:(NSCalendarUnit)unit;
+ (BOOL)truncated:(NSDate *)date1 equals:(NSDate *)date2 unit:(NSCalendarUnit)unit;
+ (BOOL)isSame:(NSDate *)date1 day:(NSDate *)date2;

+ (NSDictionary *)mappingCalendarUnitToDateComponentProperty;

@end
