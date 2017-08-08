//
// NSUtils.h
// IvyMedia
//
// Created by iphone development on 8/19/14.
//
//

@import Foundation;
@import UIKit;
@import CoreLocation;

@interface CocoaUtils : NSObject

+ (NSString *)userName;
+ (NSString *)bundleVersion;
+ (NSString *)bundleName;
+ (NSString *)bundleIdentifier;
+ (CLLocationDistance)distanceFromCoordinate:(CLLocationCoordinate2D)fromCoordinate toCoordinate:(CLLocationCoordinate2D)toCoordinate;

@end
