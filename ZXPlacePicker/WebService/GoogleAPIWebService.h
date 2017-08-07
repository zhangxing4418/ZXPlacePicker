//
// GoogleAPIWebService.h
// ZXPlacePicker
//
// Created by ziv on 2017/7/31.
// Copyright © 2017年 ziv. All rights reserved.
//

@import Foundation;
@import UIKit;

@interface GoogleAPIWebService : NSObject
@property (nonatomic, strong) NSString *url;
- (NSDictionary *)parameters;
@end

@interface GoogleNearbySearch : GoogleAPIWebService
@property (nonatomic, assign) CGFloat latitude;
@property (nonatomic, assign) CGFloat longitude;
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, strong) NSString *googleApiKey;
@end

@interface GoogleNearbySearchResponse : NSObject
@property (nonatomic, assign) BOOL status;
@property (nonatomic, strong) NSString *next_page_token;
@property (nonatomic, strong) NSArray *results;
@end