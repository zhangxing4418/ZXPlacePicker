//
// DateUtils.m
// GoToBus
//
// Created by haibara on 12/5/14.
//
//

#import "DateUtils.h"

@implementation DateUtils

#pragma mark - Public

+ (NSDate *)add:(NSDate *)date unit:(NSCalendarUnit)unit amount:(NSInteger)amount {
	NSCalendar *calendar = [NSCalendar currentCalendar];
	if ([calendar respondsToSelector:@selector(dateByAddingUnit:value:toDate:options:)]) {
		return [calendar dateByAddingUnit:unit value:amount toDate:date options:0];
	}
	NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
	if ([dateComponents respondsToSelector:@selector(setValue:forComponent:)]) {
		[dateComponents setValue:amount forComponent:unit];
	} else {
		NSString *property = [DateUtils mappingCalendarUnitToDateComponentProperty][@(unit)];
		if (!property) {
			return nil;
		}
		[dateComponents setValue:@(amount) forKey:property];
	}
	return [calendar dateByAddingComponents:dateComponents toDate:date options:0];
}

+ (NSDate *)addYears:(NSDate *)date amount:(NSInteger)amount {
	return [DateUtils add:date unit:NSCalendarUnitYear amount:amount];
}

+ (NSDate *)addMonths:(NSDate *)date amount:(NSInteger)amount {
	return [DateUtils add:date unit:NSCalendarUnitMonth amount:amount];
}

+ (NSDate *)addDays:(NSDate *)date amount:(NSInteger)amount {
	return [DateUtils add:date unit:NSCalendarUnitDay amount:amount];
}

+ (NSDate *)addHours:(NSDate *)date amount:(NSInteger)amount {
	return [DateUtils add:date unit:NSCalendarUnitHour amount:amount];
}

+ (NSDate *)addMinutes:(NSDate *)date amount:(NSInteger)amount {
	return [DateUtils add:date unit:NSCalendarUnitMinute amount:amount];
}

+ (NSDate *)addSeconds:(NSDate *)date amount:(NSInteger)amount {
	return [DateUtils add:date unit:NSCalendarUnitSecond amount:amount];
}

+ (NSDate *)parseDate:(NSString *)str parsePatterns:(NSString *)firstParsePattern, ...{
	NSDate *date = nil;
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	va_list args;
	va_start(args, firstParsePattern);
	for (NSString *parsePattern = firstParsePattern; parsePattern != nil; parsePattern = va_arg(args, NSString *)) {
		dateFormatter.dateFormat = parsePattern;
		date = [dateFormatter dateFromString:str];
		if (date != nil) {
			break;
		}
	}
	va_end(args);
	return date;
}

+ (NSDate *)parseDate:(NSString *)str locale:(NSLocale *)locale parsePatterns:(NSString *)firstParsePattern, ...{
	NSDate *date = nil;
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	va_list args;
	va_start(args, firstParsePattern);
	for (NSString *parsePattern = firstParsePattern; parsePattern != nil; parsePattern = va_arg(args, NSString *)) {
		dateFormatter.dateFormat = parsePattern;
		dateFormatter.locale = locale;
		date = [dateFormatter dateFromString:str];
		if (date != nil) {
			break;
		}
	}
	va_end(args);
	return date;
}

+ (NSInteger)getFragment:(NSDate *)date unit:(NSCalendarUnit)unit {
	NSCalendar *calendar = [NSCalendar currentCalendar];
	if ([calendar respondsToSelector:@selector(component:fromDate:)]) {
		return [calendar component:unit fromDate:date];
	}
	NSDateComponents *dateComponents = [calendar components:unit fromDate:date];
	if ([dateComponents respondsToSelector:@selector(valueForComponent:)]) {
		return [dateComponents valueForComponent:unit];
	}
	NSString *property = [DateUtils mappingCalendarUnitToDateComponentProperty][@(unit)];
	if (property) {
		return [[dateComponents valueForKey:property] integerValue];
	}
	return 0;
}

+ (NSDate *)truncate:(NSDate *)date unit:(NSCalendarUnit)unit {
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *dateComponents = [calendar components:unit fromDate:date];
	return [calendar dateFromComponents:dateComponents];
}

+ (NSComparisonResult)truncated:(NSDate *)date1 compareTo:(NSDate *)date2 unit:(NSCalendarUnit)unit {
	NSCalendar *calendar = [NSCalendar currentCalendar];
	if ([calendar respondsToSelector:@selector(compareDate:toDate:toUnitGranularity:)]) {
		return [calendar compareDate:date1 toDate:date2 toUnitGranularity:unit];
	}
	return [[self truncate:date1 unit:unit] compare:[self truncate:date2 unit:unit]];
}

+ (BOOL)truncated:(NSDate *)date1 equals:(NSDate *)date2 unit:(NSCalendarUnit)unit {
	NSCalendar *calendar = [NSCalendar currentCalendar];
	if ([calendar respondsToSelector:@selector(isDate:equalToDate:toUnitGranularity:)]) {
		return [calendar isDate:date1 equalToDate:date2 toUnitGranularity:unit];
	}
	return [[self truncate:date1 unit:unit] isEqual:[self truncate:date2 unit:unit]];
}

+ (BOOL)isSame:(NSDate *)date1 day:(NSDate *)date2 {
	NSCalendar *calendar = [NSCalendar currentCalendar];
	if ([calendar respondsToSelector:@selector(isDate:inSameDayAsDate:)]) {
		return [calendar isDate:date1 inSameDayAsDate:date2];
	}
	return [self truncated:date1 equals:date2 unit:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay];
}

+ (NSDictionary *)mappingCalendarUnitToDateComponentProperty {
	return @{ @(NSCalendarUnitEra) : @"era", @(NSCalendarUnitYear) : @"year", @(NSCalendarUnitMonth) : @"month", @(NSCalendarUnitDay) : @"day", @(NSCalendarUnitHour) : @"hour", @(NSCalendarUnitMinute) : @"minute", @(NSCalendarUnitSecond) : @"second", @(NSCalendarUnitNanosecond) : @"nanosecond", @(NSCalendarUnitWeekday) : @"weekday", @(NSCalendarUnitWeekdayOrdinal) : @"weekdayOrdinal", @(NSCalendarUnitQuarter) : @"quarter", @(NSCalendarUnitWeekOfMonth) : @"weekOfMonth", @(NSCalendarUnitWeekOfYear) : @"weekOfYear", @(NSCalendarUnitYearForWeekOfYear) : @"yearForWeekOfYear" };
}

@end
