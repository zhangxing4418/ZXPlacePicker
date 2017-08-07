//
// StringUtils.m
// IvyMedia
//
// Created by haibara on 9/2/14.
//
//

#import "StringUtils.h"

@implementation StringUtils

+ (NSString *)capitalize:(NSString *)str {
	if ([self isEmpty:str]) {
		return str;
	}
	if ([[NSCharacterSet uppercaseLetterCharacterSet] characterIsMember:[str characterAtIndex:0]]) {
		return str;
	}
	return [[str substringToIndex:1].uppercaseString stringByAppendingString:[str substringFromIndex:1]];
}

+ (NSString *)uncapitalize:(NSString *)str {
	if ([self isEmpty:str]) {
		return str;
	}
	if ([[NSCharacterSet lowercaseLetterCharacterSet] characterIsMember:[str characterAtIndex:0]]) {
		return str;
	}
	return [[str substringToIndex:1].lowercaseString stringByAppendingString:[str substringFromIndex:1]];
}

+ (NSString *)substringBeforeLast:(NSString *)str separator:(NSString *)separator {
	if ([self isEmpty:str] || [self isEmpty:separator]) {
		return str;
	}
	NSInteger pos = [str rangeOfString:separator options:NSBackwardsSearch].location;
	if (pos == NSNotFound) {
		return str;
	}
	return [str substringToIndex:pos];
}

+ (BOOL)isEmpty:(NSString *)string {
	return !string || ![string isKindOfClass:[NSString class]] || string.length == 0;
}

+ (BOOL)isBlank:(NSString *)string {
	if ([self isEmpty:string]) {
		return YES;
	}
	return [string rangeOfCharacterFromSet:[[NSCharacterSet whitespaceCharacterSet] invertedSet]].location == NSNotFound;
}

+ (BOOL)isNumeric:(NSString *)string {
	if ([self isEmpty:string]) {
		return NO;
	}
	return [string rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location == NSNotFound;
}

+ (NSArray *)split:(NSString *)str separator:(NSString *)separator {
	return [[str componentsSeparatedByString:separator] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"length > 0"]];
}

+ (NSString *)join:(NSString *)firstString, ...NS_REQUIRES_NIL_TERMINATION {
	NSMutableArray *array = [NSMutableArray array];
	va_list args;
	va_start(args, firstString);
	for (NSString *string = firstString; string != nil; string = va_arg(args, NSString *)) {
		[array addObject:string];
	}
	va_end(args);
	return [array componentsJoinedByString:@""];
}

@end
