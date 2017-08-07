@import Foundation;
@import UIKit;

@interface UIConstants : NSObject

+ (CGFloat)defaultStatusBarHeight;
+ (CGFloat)defaultLabelHeight;
+ (CGFloat)defaultButtonHeight;
+ (CGFloat)defaultSwitchHeight;
+ (CGFloat)defaultStepperHeight;
+ (CGFloat)defaultSliderHeight;
+ (CGFloat)defaultSegmentedControlHeight;
+ (CGFloat)defaultTextFieldHeight;
+ (CGFloat)defaultTableViewRowHeight;
+ (CGFloat)defaultTableViewSectionHeight:(UITableViewStyle)style;
+ (CGFloat)defaultTableViewSeparatorHeight;
+ (UIEdgeInsets)defaultTableViewCellLayoutInsets;
+ (CGFloat)defaultTableViewCellContentViewWidth:(UITableViewCellAccessoryType)accessoryType;
+ (CGFloat)defaultTableViewCellDefaultTextLabelWidth:(UITableViewCellAccessoryType)accessoryType;
+ (CGFloat)defaultTableViewCellValue2TextLabelWidth;
+ (CGFloat)defaultTableViewCellValue2DetailTextLabelWidth:(UITableViewCellAccessoryType)accessoryType;
+ (CGFloat)defaultTableViewCellValue2DetailTextLabelMarginLeft;
+ (CGFloat)defaultTableViewCellValue2DetailTextLabelPointX;
+ (UIFont *)defaultTableViewCellTextLabelFont:(UITableViewCellStyle)style;
+ (UIFont *)defaultTableViewCellDetailTextLabelFont:(UITableViewCellStyle)style;
+ (CGSize)defaultCollectionViewFlowLayoutItemSize;
+ (CGFloat)defaultCollectionViewFlowLayoutLineSpacing;
+ (CGFloat)defaultCollectionViewFlowLayoutInteritemSpacing;
+ (CGFloat)defaultDatePickerHeight;
+ (CGFloat)defaultPickerViewHeight;
+ (CGFloat)defaultNavigationBarHeight;
+ (CGFloat)defaultTabBarHeight;
+ (CGFloat)defaultToolbarHeight;

@end
