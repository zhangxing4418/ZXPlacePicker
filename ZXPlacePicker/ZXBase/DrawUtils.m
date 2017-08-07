//
// DrawUtils.m
// GotoBus
//
// Created by haibara on 2/12/15.
//
//

#import "DrawUtils.h"
@import QuartzCore;

@implementation DrawUtils

+ (NSAttributedString *)attributedStringWithFAKIcon:(FAKIcon *)icon fillColor:(UIColor *)fillColor {
	[icon addAttribute:NSForegroundColorAttributeName value:fillColor];
	return icon.attributedString;
}

+ (UIImage *)imageWithFAKIcon:(FAKIcon *)icon fillColor:(UIColor *)fillColor {
	[icon addAttribute:NSForegroundColorAttributeName value:fillColor];
	return [icon imageWithSize:CGSizeMake(icon.iconFontSize, icon.iconFontSize)];
}

@end
