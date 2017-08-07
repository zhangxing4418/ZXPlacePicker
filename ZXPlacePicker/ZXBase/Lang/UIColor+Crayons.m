//
// IMColor.m
// IvyMedia
//
// Created by haibara on 11/13/14.
//
//

#import "UIColor+Crayons.h"

@implementation UIColor (Crayons)

+ (UIColor *)colorWithRGBs:(NSUInteger)colors {
	return [UIColor crayons_colorWithRed:((colors & 0xFF0000) >> 16) / 255.0 green:((colors & 0x00FF00) >> 8) / 255.0 blue:((colors & 0x0000FF) >> 0) / 255.0 alpha:1];
}

+ (UIColor *)crayons_colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {
#if defined __IPHONE_10_0 && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
	if ([UIColor respondsToSelector:@selector(colorWithDisplayP3Red:green:blue:alpha:)]) {
		return [UIColor colorWithDisplayP3Red:red green:green blue:blue alpha:alpha];
	}
#endif
	return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (UIColor *)aluminumColor {
	return [UIColor crayons_colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0];
}

+ (UIColor *)aquaColor {
	return [UIColor crayons_colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0];
}

+ (UIColor *)asparagusColor {
	return [UIColor crayons_colorWithRed:0.5 green:0.5 blue:0.0 alpha:1.0];
}

+ (UIColor *)bananaColor {
	return [UIColor crayons_colorWithRed:1.0 green:1.0 blue:0.4 alpha:1.0];
}

+ (UIColor *)blueberryColor {
	return [UIColor crayons_colorWithRed:0.0 green:0.0 blue:1.0 alpha:1.0];
}

+ (UIColor *)bubblegumColor {
	return [UIColor crayons_colorWithRed:1.0 green:0.4 blue:1.0 alpha:1.0];
}

+ (UIColor *)carnationColor {
	return [UIColor crayons_colorWithRed:1.0 green:111 / 255.0f blue:207 / 255.0f alpha:1.0];
}

+ (UIColor *)cantalopeColor {
	return [UIColor crayons_colorWithRed:1.0 green:0.8 blue:0.4 alpha:1.0];
}

+ (UIColor *)cayenneColor {
	return [UIColor crayons_colorWithRed:0.5 green:0.0 blue:0.0 alpha:1.0];
}

+ (UIColor *)cloverColor {
	return [UIColor crayons_colorWithRed:0.0 green:0.5 blue:0.0 alpha:1.0];
}

+ (UIColor *)eggplantColor {
	return [UIColor crayons_colorWithRed:0.25 green:0.0 blue:0.5 alpha:1.0];
}

+ (UIColor *)fernColor {
	return [UIColor crayons_colorWithRed:0.25 green:0.5 blue:0.0 alpha:1.0];
}

+ (UIColor *)floraColor {
	return [UIColor crayons_colorWithRed:0.4 green:1.0 blue:0.4 alpha:1.0];
}

+ (UIColor *)grapeColor {
	return [UIColor crayons_colorWithRed:0.5 green:0.0 blue:1.0 alpha:1.0];
}

+ (UIColor *)honeydewColor {
	return [UIColor crayons_colorWithRed:0.8 green:1.0 blue:0.4 alpha:1.0];
}

+ (UIColor *)iceColor {
	return [UIColor crayons_colorWithRed:0.4 green:1.0 blue:1.0 alpha:1.0];
}

+ (UIColor *)ironColor {
	return [UIColor crayons_colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0];
}

+ (UIColor *)lavenderColor {
	return [UIColor crayons_colorWithRed:0.8 green:0.4 blue:1.0 alpha:1.0];
}

+ (UIColor *)leadColor {
	return [UIColor crayons_colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.0];
}

+ (UIColor *)lemonColor {
	return [UIColor crayons_colorWithRed:1.0 green:1.0 blue:0.0 alpha:1.0];
}

+ (UIColor *)licoriceColor {
	return [UIColor crayons_colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
}

+ (UIColor *)limeColor {
	return [UIColor crayons_colorWithRed:0.5 green:1.0 blue:0.0 alpha:1.0];
}

+ (UIColor *)magnesiumColor {
	return [UIColor crayons_colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0];
}

+ (UIColor *)maraschinoColor {
	return [UIColor crayons_colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
}

+ (UIColor *)maroonColor {
	return [UIColor crayons_colorWithRed:0.5 green:0.0 blue:0.25 alpha:1.0];
}

+ (UIColor *)mercuryColor {
	return [UIColor crayons_colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
}

+ (UIColor *)midnightColor {
	return [UIColor crayons_colorWithRed:0.0 green:0.0 blue:0.5 alpha:1.0];
}

+ (UIColor *)mochaColor {
	return [UIColor crayons_colorWithRed:0.5 green:0.25 blue:0.0 alpha:1.0];
}

+ (UIColor *)mossColor {
	return [UIColor crayons_colorWithRed:0.0 green:0.5 blue:0.25 alpha:1.0];
}

+ (UIColor *)nickelColor {
	return [UIColor crayons_colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
}

+ (UIColor *)oceanColor {
	return [UIColor crayons_colorWithRed:0.0 green:0.25 blue:0.5 alpha:1.0];
}

+ (UIColor *)orchidColor {
	return [UIColor crayons_colorWithRed:0.4 green:0.4 blue:1.0 alpha:1.0];
}

+ (UIColor *)plumColor {
	return [UIColor crayons_colorWithRed:0.5 green:0.0 blue:0.5 alpha:1.0];
}

+ (UIColor *)salmonColor {
	return [UIColor crayons_colorWithRed:1.0 green:0.4 blue:0.4 alpha:1.0];
}

+ (UIColor *)seafoamColor {
	return [UIColor crayons_colorWithRed:0.0 green:1.0 blue:0.5 alpha:1.0];
}

+ (UIColor *)silverColor {
	return [UIColor crayons_colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
}

+ (UIColor *)skyColor {
	return [UIColor crayons_colorWithRed:0.4 green:0.8 blue:1.0 alpha:1.0];
}

+ (UIColor *)snowColor {
	return [UIColor crayons_colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
}

+ (UIColor *)spindriftColor {
	return [UIColor crayons_colorWithRed:0.4 green:1.0 blue:0.8 alpha:1.0];
}

+ (UIColor *)springColor {
	return [UIColor crayons_colorWithRed:0.0 green:1.0 blue:0.0 alpha:1.0];
}

+ (UIColor *)steelColor {
	return [UIColor crayons_colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0];
}

+ (UIColor *)strawberryColor {
	return [UIColor crayons_colorWithRed:1.0 green:0.0 blue:0.5 alpha:1.0];
}

+ (UIColor *)tangerineColor {
	return [UIColor crayons_colorWithRed:1.0 green:0.5 blue:0.0 alpha:1.0];
}

+ (UIColor *)tealColor {
	return [UIColor crayons_colorWithRed:0.0 green:0.5 blue:0.5 alpha:1.0];
}

+ (UIColor *)tinColor {
	return [UIColor crayons_colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
}

+ (UIColor *)tungstenColor {
	return [UIColor crayons_colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
}

+ (UIColor *)turquoiseColor {
	return [UIColor crayons_colorWithRed:0.0 green:1.0 blue:1.0 alpha:1.0];
}

@end
