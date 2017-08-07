//
// DateFormatUtils.h
// GoToBus
//
// Created by haibara on 12/5/14.
//
//

@import Foundation;

@interface DateFormatUtils : NSObject

+ (NSString *)format:(NSDate *)date pattern:(NSString *)pattern;
+ (NSString *)format:(NSDate *)date pattern:(NSString *)pattern locale:(NSLocale *)locale;
+ (NSString *)format:(NSDate *)date pattern:(NSString *)pattern timeZone:(NSTimeZone *)timeZone;
+ (NSString *)format:(NSDate *)date pattern:(NSString *)pattern timeZone:(NSTimeZone *)timeZone locale:(NSLocale *)locale;

+ (NSDateFormatter *)ISO_DATE_FORMAT;
+ (NSDateFormatter *)ISO_DATETIME_FORMAT;

@end
