//
// DrawUtils.h
// GotoBus
//
// Created by haibara on 2/12/15.
//
//

@import Foundation;
@import UIKit;
#import <FontAwesomeKit/FontAwesomeKit.h>

@interface DrawUtils : NSObject

+ (NSAttributedString *)attributedStringWithFAKIcon:(FAKIcon *)icon fillColor:(UIColor *)fillColor;
+ (UIImage *)imageWithFAKIcon:(FAKIcon *)icon fillColor:(UIColor *)fillColor;

@end
