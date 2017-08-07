//
// GoogleNearbySearchResult.h
// ZXPlacePicker
//
// Created by ziv on 2017/7/31.
// Copyright © 2017年 ziv. All rights reserved.
//

@import Foundation;
@import UIKit;

@interface GoogleNearbySearchResult : NSObject
@property (nonatomic, assign) CGFloat latitude;
@property (nonatomic, assign) CGFloat longitude;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *placeId;
@property (nonatomic, strong) NSString *vicinity;
@end
