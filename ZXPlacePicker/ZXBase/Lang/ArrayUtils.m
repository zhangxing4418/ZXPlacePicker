//
// ArrayUtils.m
// LiveProject
//
// Created by haibara on 9/15/15.
//
//

#import "ArrayUtils.h"

@implementation ArrayUtils

+ (NSArray *)removeElements:(NSArray *)array values:(id)firstValue, ...{
	NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:array];
	va_list args;
	va_start(args, firstValue);

	for (id obj = firstValue; obj != nil; obj = va_arg(args, id)) {
		[mutableArray removeObject:obj];
	}

	va_end(args);
	return [NSArray arrayWithArray:mutableArray];
}

+ (NSArray *)remove:(NSArray *)array element:(id)element {
	NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:array];
	[mutableArray removeObject:element];
	return [NSArray arrayWithArray:mutableArray];
}

+ (NSArray *)add:(NSArray *)array index:(NSUInteger)index element:(id)element {
	NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:array];
	[mutableArray insertObject:element atIndex:index];
	return [NSArray arrayWithArray:mutableArray];
}

@end
