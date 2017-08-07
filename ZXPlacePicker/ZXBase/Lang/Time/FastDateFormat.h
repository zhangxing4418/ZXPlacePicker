//
// FastDateFormat.h
// GoToBus
//
// Created by haibara on 12/10/14.
//
//

@import Foundation;

@interface NSDateFormatter (FastDateFormat)
- (NSString *)format:(NSDate *)date;
- (NSDate *)parse:(NSString *)string;
@end
