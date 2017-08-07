//
// GoogleAPIWebService.m
// ZXPlacePicker
//
// Created by ziv on 2017/7/31.
// Copyright © 2017年 ziv. All rights reserved.
//

#import "GoogleAPIWebService.h"
#import <objc/runtime.h>

@implementation GoogleAPIWebService

- (NSString *)url {
	return nil;
}

- (NSDictionary *)parameters {
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	unsigned int count;
	objc_property_t *propertyList = class_copyPropertyList([self class], &count);
	for (unsigned int i = 0; i < count; i++) {
		const char *propertyCharName = property_getName(propertyList[i]);
		NSString *propertyName = [NSString stringWithUTF8String:propertyCharName];
		[dict setValue:[self valueForKeyPath:propertyName] forKey:propertyName];
	}
	return [NSDictionary dictionaryWithDictionary:dict];
}

@end

@implementation GoogleNearbySearch

- (NSString *)url {
	return @"https://maps.googleapis.com/maps/api/place/nearbysearch/json";
}

- (NSDictionary *)parameters {
	return @{@"location" : [NSString stringWithFormat:@"%lf,%lf", self.latitude, self.longitude], @"radius" : @(self.radius), @"key" : self.googleApiKey};
}

@end

@implementation GoogleNearbySearchResponse
@end
