//
// RandomStringUtils.h
// LiveProject
//
// Created by haibara on 8/11/15.
//
//

@import Foundation;

@interface RandomStringUtils : NSObject
+ (NSString *)randomAlphanumeric:(NSUInteger)count;
+ (NSString *)randomAlphabetic:(NSUInteger)count;
+ (NSString *)randomNumeric:(NSUInteger)count;
@end
