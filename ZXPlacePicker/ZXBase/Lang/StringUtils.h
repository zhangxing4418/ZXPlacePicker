//
// StringUtils.h
// IvyMedia
//
// Created by haibara on 9/2/14.
//
//

@import Foundation;

@interface StringUtils : NSObject

+ (NSString *)capitalize:(NSString *)str;
+ (NSString *)uncapitalize:(NSString *)str;
+ (NSString *)substringBeforeLast:(NSString *)str separator:(NSString *)separator;

+ (BOOL)isEmpty:(NSString *)string;
+ (BOOL)isBlank:(NSString *)string;
+ (BOOL)isNumeric:(NSString *)string;

+ (NSArray *)split:(NSString *)str separator:(NSString *)separator;
+ (NSString *)join:(NSString *)firstString, ...NS_REQUIRES_NIL_TERMINATION;

@end

@interface NSString (SuppressWarnings)
- (NSString *)im_stringByAppendingString:(NSString *)aString;
@end

@interface NSMutableString (SuppressWarnings)
+ (NSString *)im_stringWithString:(NSString *)aString;
- (void)im_appendString:(NSString *)aString;
@end

@interface NSAttributedString (SuppressWarnings)
- (instancetype)im_initWithString:(NSString *)aString;
- (instancetype)im_initWithString:(NSString *)aString attributes:(NSDictionary *)attributes;
@end
