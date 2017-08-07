//
// ArrayUtils.h
// LiveProject
//
// Created by haibara on 9/15/15.
//
//

@import Foundation;

@interface ArrayUtils : NSObject
+ (NSArray *)removeElements:(NSArray *)array values:(id)firstValue, ...NS_REQUIRES_NIL_TERMINATION;
+ (NSArray *)remove:(NSArray *)array element:(id)element;
+ (NSArray *)add:(NSArray *)array index:(NSUInteger)index element:(id)element;
@end
