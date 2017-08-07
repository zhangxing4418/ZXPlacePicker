//
// GoogleNearbySearchResultJsonMapper.m
// ZXPlacePicker
//
// Created by ziv on 2017/7/31.
// Copyright © 2017年 ziv. All rights reserved.
//

#import "GoogleNearbySearchResultJsonMapper.h"
#import "GoogleNearbySearchResult.h"
#import <RestKit/RKObjectMappingOperationDataSource.h>

@implementation GoogleNearbySearchResultJsonMapper

- (instancetype)init {
	if (self = [super init]) {
		RKObjectMapping *searchResultMapping = [[RKObjectMapping alloc] initWithClass:[GoogleNearbySearchResult class]];
		[searchResultMapping addAttributeMappingsFromDictionary:@{@"geometry.location.lat" : @"latitude", @"geometry.location.lng" : @"longitude", @"name" : @"name", @"place_id" : @"placeId", @"vicinity" : @"vicinity"}];

		RKObjectMapping *responseMapping = [[RKObjectMapping alloc] initWithClass:[GoogleNearbySearchResponse class]];
		[responseMapping addAttributeMappingsFromArray:@[@"next_page_token", @"status"]];
		[responseMapping addRelationshipMappingWithSourceKeyPath:@"results" mapping:searchResultMapping];

		self.objectMapping = responseMapping;
	}
	return self;
}

- (NSError *)parseWithJSONObject:(id)jsonObject {
	self.response = [[GoogleNearbySearchResponse alloc] init];

	RKMappingOperation *mappingOperation = [[RKMappingOperation alloc] initWithSourceObject:jsonObject destinationObject:self.response mapping:self.objectMapping];
	RKObjectMappingOperationDataSource *mappingOperationDataSource = [[RKObjectMappingOperationDataSource alloc] init];
	mappingOperation.dataSource = mappingOperationDataSource;

	NSError *error = nil;
	if ([mappingOperation performMapping:&error]) {
		if (self.response.results.count > 0) {
			NSMutableArray *array = [NSMutableArray arrayWithArray:self.response.results];
			[array removeObjectAtIndex:0];
			self.response.results = [NSArray arrayWithArray:array];
		}
	}
	return error;
}

@end
