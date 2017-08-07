//
// SystemUtils.h
// MyProject
//
// Created by haibara on 6/25/15.
//
//

@import Foundation;
@import UIKit;
@import CoreLocation;

@interface SystemUtils : NSObject
+ (BOOL)isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion)version;
@end

#pragma mark - Founction

CGSize CGRectGetSize(CGRect rect);
CGPoint CGRectGetOrigin(CGRect rect);
CGRect CGRectSetWidth(CGRect rect, CGFloat width);
CGRect CGRectSetHeight(CGRect rect, CGFloat height);
CGRect CGRectSetX(CGRect rect, CGFloat x);
CGRect CGRectSetY(CGRect rect, CGFloat y);
CGRect CGRectSetSize(CGRect rect, CGSize size);
CGRect CGRectSetOrigin(CGRect rect, CGPoint origin);

CGRect CGRectZeroMakeSize(CGSize size);
CGRect CGRectInsetSize(CGSize size, CGFloat dx, CGFloat dy);

BOOL CLLocationCoordinate2DEqualToCoordinate(CLLocationCoordinate2D coord1, CLLocationCoordinate2D coord2);
NSString *NSStringFromCLLocationCoordinate2D(CLLocationCoordinate2D coord);

NSOperatingSystemVersion NSOperatingSystemVersionMake(NSInteger majorVersion, NSInteger minorVersion, NSInteger patchVersion);
