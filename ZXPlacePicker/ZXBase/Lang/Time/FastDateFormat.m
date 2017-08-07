//
// FastDateFormat.m
// GoToBus
//
// Created by haibara on 12/10/14.
//
//

#import "FastDateFormat.h"

@implementation NSDateFormatter (FastDateFormat)

- (NSString *)format:(NSDate *)date {
	return [self stringFromDate:date];
}

- (NSDate *)parse:(NSString *)string {
	return [self dateFromString:string];
}

@end
