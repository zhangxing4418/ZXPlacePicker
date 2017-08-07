//
// SystemUtils.m
// MyProject
//
// Created by haibara on 6/25/15.
//
//

#import "SystemUtils.h"
@import UIKit;

@implementation SystemUtils

#pragma mark - Public

+ (BOOL)isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion)version {
	NSProcessInfo *processInfo = [NSProcessInfo processInfo];
	if ([processInfo respondsToSelector:@selector(isOperatingSystemAtLeastVersion:)]) {
		return [processInfo isOperatingSystemAtLeastVersion:version];
	} else {
		return [[UIDevice currentDevice].systemVersion compare:[self stringWithOperatingSystemVersion:version] options:NSNumericSearch] != NSOrderedAscending;
	}
}

#pragma mark - Private

+ (NSOperatingSystemVersion)operatingSystemVersionWithString:(NSString *)string {
	NSOperatingSystemVersion version = { 0, 0, 0 };
	NSArray *array = [string componentsSeparatedByString:@"."];
	if (array.count > 0) {
		version.majorVersion = [array[0] integerValue];
	}
	if (array.count > 1) {
		version.minorVersion = [array[1] integerValue];
	}
	if (array.count > 2) {
		version.patchVersion = [array[2] integerValue];
	}
	return version;
}

+ (NSString *)stringWithOperatingSystemVersion:(NSOperatingSystemVersion)version {
	NSMutableArray *array = [NSMutableArray array];
	if (version.majorVersion > 0) {
		[array addObject:@(version.majorVersion)];
	}
	if (version.minorVersion > 0) {
		[array addObject:@(version.minorVersion)];
	}
	if (version.patchVersion > 0) {
		[array addObject:@(version.patchVersion)];
	}
	return [array componentsJoinedByString:@"."];
}

+ (BOOL)isVersion:(NSOperatingSystemVersion)version atLeastVersion:(NSOperatingSystemVersion)requiredVersion {
	if (version.majorVersion < requiredVersion.majorVersion) {
		return NO;
	}
	if (version.minorVersion < requiredVersion.minorVersion) {
		return NO;
	}
	if (version.patchVersion < requiredVersion.patchVersion) {
		return NO;
	}
	return YES;
}

@end

#pragma mark Founction

CGRect CGRectSetWidth(CGRect rect, CGFloat width) {
	return CGRectMake(rect.origin.x, rect.origin.y, width, rect.size.height);
}

CGRect CGRectSetHeight(CGRect rect, CGFloat height) {
	return CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, height);
}

CGRect CGRectSetSize(CGRect rect, CGSize size) {
	return CGRectMake(rect.origin.x, rect.origin.y, size.width, size.height);
}

CGRect CGRectSetX(CGRect rect, CGFloat x) {
	return CGRectMake(x, rect.origin.y, rect.size.width, rect.size.height);
}

CGRect CGRectSetY(CGRect rect, CGFloat y) {
	return CGRectMake(rect.origin.x, y, rect.size.width, rect.size.height);
}

CGRect CGRectSetOrigin(CGRect rect, CGPoint origin) {
	return CGRectMake(origin.x, origin.y, rect.size.width, rect.size.height);
}

CGRect CGRectZeroMakeSize(CGSize size) {
	return CGRectMake(0, 0, size.width, size.height);
}

CGRect CGRectInsetSize(CGSize size, CGFloat dx, CGFloat dy) {
	return CGRectInset(CGRectZeroMakeSize(size), dx, dy);
}

BOOL CLLocationCoordinate2DEqualToCoordinate(CLLocationCoordinate2D coord1, CLLocationCoordinate2D coord2) {
	return coord1.latitude == coord2.latitude && coord1.longitude == coord2.longitude;
}

NSString *NSStringFromCLLocationCoordinate2D(CLLocationCoordinate2D coord) {
	return NSStringFromCGPoint(CGPointMake(coord.latitude, coord.longitude));
}

NSOperatingSystemVersion NSOperatingSystemVersionMake(NSInteger majorVersion, NSInteger minorVersion, NSInteger patchVersion) {
	NSOperatingSystemVersion operatingSystemVersion;
	operatingSystemVersion.majorVersion = majorVersion;
	operatingSystemVersion.minorVersion = minorVersion;
	operatingSystemVersion.patchVersion = patchVersion;
	return operatingSystemVersion;
}
