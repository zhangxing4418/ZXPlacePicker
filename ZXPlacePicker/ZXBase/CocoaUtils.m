//
// NSUtils.m
// IvyMedia
//
// Created by iphone development on 8/19/14.
//
//

#import "CocoaUtils.h"

@implementation CocoaUtils

static UIViewController *topMostViewController;
static BOOL alertControllerAnimated = YES;

#pragma mark - Public

+ (NSString *)userName {
	return NSHomeDirectory().pathComponents[2];
}

+ (NSString *)bundleVersion {
	return [NSBundle mainBundle].infoDictionary[@"CFBundleVersion"];
}

+ (NSString *)bundleName {
	return [NSBundle mainBundle].infoDictionary[@"CFBundleName"];
}

+ (NSString *)bundleIdentifier {
	return [NSBundle mainBundle].infoDictionary[@"CFBundleIdentifier"];
}

+ (CLLocationDistance)distanceFromCoordinate:(CLLocationCoordinate2D)fromCoordinate toCoordinate:(CLLocationCoordinate2D)toCoordinate {
	CLLocation *fromLocation = [[CLLocation alloc] initWithLatitude:fromCoordinate.latitude longitude:fromCoordinate.longitude];
	CLLocation *toLocation = [[CLLocation alloc] initWithLatitude:toCoordinate.latitude longitude:toCoordinate.longitude];
	return [fromLocation distanceFromLocation:toLocation];
}

@end
