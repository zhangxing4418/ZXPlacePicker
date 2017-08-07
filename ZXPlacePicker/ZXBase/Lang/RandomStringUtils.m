//
// RandomStringUtils.m
// LiveProject
//
// Created by haibara on 8/11/15.
//
//

#import "RandomStringUtils.h"

@implementation RandomStringUtils

+ (NSString *)randomAlphanumeric:(NSUInteger)count {
	NSString *chars = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXZY0123456789";
	NSMutableString *string = [NSMutableString stringWithCapacity:count];
	for (NSUInteger i = 0; i < count; i++) {
		[string appendFormat:@"%C", [chars characterAtIndex:arc4random_uniform((u_int32_t)chars.length)]];
	}
	return [NSString stringWithString:string];
}

+ (NSString *)randomAlphabetic:(NSUInteger)count {
	NSString *chars = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXZY";
	NSMutableString *string = [NSMutableString stringWithCapacity:count];
	for (NSUInteger i = 0; i < count; i++) {
		[string appendFormat:@"%C", [chars characterAtIndex:arc4random_uniform((u_int32_t)chars.length)]];
	}
	return [NSString stringWithString:string];
}

+ (NSString *)randomNumeric:(NSUInteger)count {
	NSMutableString *string = [NSMutableString stringWithCapacity:count];
	for (NSUInteger i = 0; i < count; i++) {
		[string appendFormat:@"%d", arc4random_uniform(10)];
	}
	return [NSString stringWithString:string];
}

@end
