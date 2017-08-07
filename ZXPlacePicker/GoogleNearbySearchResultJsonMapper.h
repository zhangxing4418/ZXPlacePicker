//
// GoogleNearbySearchResultJsonMapper.h
// ZXPlacePicker
//
// Created by ziv on 2017/7/31.
// Copyright © 2017年 ziv. All rights reserved.
//

@import Foundation;
#import <RestKit/RestKit.h>
#import "GoogleAPIWebService.h"

@interface GoogleNearbySearchResultJsonMapper : NSObject

@property (nonatomic, strong) GoogleNearbySearchResponse *response;
@property (nonatomic, strong) RKObjectMapping *objectMapping;

- (NSError *)parseWithJSONObject:(id)jsonObject;

@end
