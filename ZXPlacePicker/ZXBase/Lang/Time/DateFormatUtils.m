//
// DateFormatUtils.m
// GoToBus
//
// Created by haibara on 12/5/14.
//
//

#import "DateFormatUtils.h"

@implementation DateFormatUtils

+ (NSString *)format:(NSDate *)date pattern:(NSString *)pattern {
	return [DateFormatUtils format:date pattern:pattern timeZone:nil locale:nil];
}

+ (NSString *)format:(NSDate *)date pattern:(NSString *)pattern locale:(NSLocale *)locale {
	return [DateFormatUtils format:date pattern:pattern timeZone:nil locale:locale];
}

+ (NSString *)format:(NSDate *)date pattern:(NSString *)pattern timeZone:(NSTimeZone *)timeZone {
	return [DateFormatUtils format:date pattern:pattern timeZone:timeZone locale:nil];
}

+ (NSString *)format:(NSDate *)date pattern:(NSString *)pattern timeZone:(NSTimeZone *)timeZone locale:(NSLocale *)locale {
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	dateFormatter.dateFormat = pattern;
	dateFormatter.locale = locale;
	dateFormatter.timeZone = timeZone;
	return [dateFormatter stringFromDate:date];
}

+ (NSDateFormatter *)ISO_DATE_FORMAT {
	static NSDateFormatter *dateFormatter;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		dateFormatter = [[NSDateFormatter alloc] init];
		dateFormatter.dateFormat = @"yyyy-MM-dd";
	});
	return dateFormatter;
}

+ (NSDateFormatter *)ISO_DATETIME_FORMAT {
	static NSDateFormatter *dateFormatter;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		dateFormatter = [[NSDateFormatter alloc] init];
		dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
	});
	return dateFormatter;
}

@end
