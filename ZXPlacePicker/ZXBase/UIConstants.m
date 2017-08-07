#import "UIConstants.h"
#import "Lang.h"

@implementation UIConstants

+ (NSArray *)defaultTableViewCellTextLabelFonts {
	static dispatch_once_t onceToken;
	static NSArray *fonts;
	dispatch_once(&onceToken, ^{
		NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
		NSMutableDictionary *dict2 = [NSMutableDictionary dictionary];
		if (YES) {
			UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UITableViewCell class])];
			dict1[@(UITableViewCellStyleDefault)] = [cell.textLabel.font copy];
		}
		if (YES) {
			UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NSStringFromClass([UITableViewCell class])];
			dict1[@(UITableViewCellStyleValue1)] = [cell.textLabel.font copy];
			dict2[@(UITableViewCellStyleValue1)] = [cell.detailTextLabel.font copy];
		}
		if (YES) {
			UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:NSStringFromClass([UITableViewCell class])];
			dict1[@(UITableViewCellStyleValue2)] = [cell.textLabel.font copy];
			dict2[@(UITableViewCellStyleValue2)] = [cell.detailTextLabel.font copy];
		}
		if (YES) {
			UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:NSStringFromClass([UITableViewCell class])];
			dict1[@(UITableViewCellStyleSubtitle)] = [cell.textLabel.font copy];
			dict2[@(UITableViewCellStyleSubtitle)] = [cell.detailTextLabel.font copy];
		}
		fonts = [[NSArray alloc] initWithObjects:[NSDictionary dictionaryWithDictionary:dict1], [NSDictionary dictionaryWithDictionary:dict2], nil];
	});
	return fonts;
}

+ (CGFloat)defaultStatusBarHeight {
	return 20;
}

+ (CGFloat)defaultLabelHeight {
	return 21;
}

+ (CGFloat)defaultButtonHeight {
	return 30;
}

+ (CGFloat)defaultSwitchHeight {
	return 31;
}

+ (CGFloat)defaultStepperHeight {
	return 29;
}

+ (CGFloat)defaultSliderHeight {
	return 30;
}

+ (CGFloat)defaultSegmentedControlHeight {
	return 29;
}

+ (CGFloat)defaultTextFieldHeight {
	return 30;
}

+ (CGFloat)defaultTableViewRowHeight {
	return 44;
}

+ (CGFloat)defaultTableViewSectionHeight:(UITableViewStyle)style {
	if ([SystemUtils isOperatingSystemAtLeastVersion:NSOperatingSystemVersionMake(9, 0, 0)]) {
		if (style == UITableViewStylePlain) {
			return 28;
		} else if (UITableViewStyleGrouped) {
			return 18;
		}
	} else {
		if (style == UITableViewStylePlain) {
			return 22;
		} else if (UITableViewStyleGrouped) {
			return 10;
		}
	}
	return 0;
}

+ (CGFloat)defaultTableViewSeparatorHeight {
	return 1;
}

+ (UIEdgeInsets)defaultTableViewCellLayoutInsets {
	return UIEdgeInsetsMake(5, 15, 5, 15);
}

+ (CGFloat)defaultTableViewCellContentViewWidth:(UITableViewCellAccessoryType)accessoryType {
	CGFloat w = 0;
	switch (accessoryType) {
		case UITableViewCellAccessoryDisclosureIndicator:
			w = 287;

			break;

		case UITableViewCellAccessoryDetailDisclosureButton:
			w = 253;

			break;

		case UITableViewCellAccessoryCheckmark:
			w = 281;

			break;

		case UITableViewCellAccessoryDetailButton:
			w = 273;

			break;

		default:
			w = 320;

			break;
	}
	return w;
}

+ (CGFloat)defaultTableViewCellDefaultTextLabelWidth:(UITableViewCellAccessoryType)accessoryType {
	CGFloat w = 0;
	switch (accessoryType) {
		case UITableViewCellAccessoryDisclosureIndicator:
			w = 270;

			break;

		case UITableViewCellAccessoryDetailDisclosureButton:
			w = 238;

			break;

		case UITableViewCellAccessoryCheckmark:
			w = 266;

			break;

		case UITableViewCellAccessoryDetailButton:
			w = 258;

			break;

		default:
			w = 290;

			break;
	}
	return w;
}

+ (CGFloat)defaultTableViewCellValue2DetailTextLabelWidth:(UITableViewCellAccessoryType)accessoryType {
	CGFloat w = 0;
	switch (accessoryType) {
		case UITableViewCellAccessoryDisclosureIndicator:
			w = 173;

			break;

		case UITableViewCellAccessoryDetailDisclosureButton:
			w = 141;

			break;

		case UITableViewCellAccessoryCheckmark:
			w = 169;

			break;

		case UITableViewCellAccessoryDetailButton:
			w = 161;

			break;

		default:
			w = 193;

			break;
	}
	return w;
}

+ (CGFloat)defaultTableViewCellValue2TextLabelWidth {
	return 91;
}

+ (CGFloat)defaultTableViewCellValue2DetailTextLabelMarginLeft {
	return 6;
}

+ (CGFloat)defaultTableViewCellValue2DetailTextLabelPointX {
	return 112;
}

+ (UIFont *)defaultTableViewCellTextLabelFont:(UITableViewCellStyle)style {
	return [self defaultTableViewCellTextLabelFonts].firstObject[@(style)];
}

+ (UIFont *)defaultTableViewCellDetailTextLabelFont:(UITableViewCellStyle)style {
	return [self defaultTableViewCellTextLabelFonts].lastObject[@(style)];
}

+ (CGSize)defaultCollectionViewFlowLayoutItemSize {
	return CGSizeMake(50, 50);
}

+ (CGFloat)defaultCollectionViewFlowLayoutLineSpacing {
	return 10;
}

+ (CGFloat)defaultCollectionViewFlowLayoutInteritemSpacing {
	return 10;
}

+ (CGFloat)defaultDatePickerHeight {
	return 162;
}

+ (CGFloat)defaultPickerViewHeight {
	return 162;
}

+ (CGFloat)defaultNavigationBarHeight {
	return 44;
}

+ (CGFloat)defaultTabBarHeight {
	return 44;
}

+ (CGFloat)defaultToolbarHeight {
	return 44;
}

@end
