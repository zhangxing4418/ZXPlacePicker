//
// UIToolkit.m
// GoToBus
//
// Created by haibara on 10/8/14.
//
//

#import "UIToolkit.h"
#import "Lang.h"
#import "UIColor+Crayons.h"
#import "DrawUtils.h"
#import "UIConstants.h"
#import <BlocksKit/BlocksKit.h>
#import <BlocksKit/BlocksKit+UIKit.h>
#import <BlocksKit/A2DynamicDelegate.h>
#import <BlocksKit/NSObject+A2DynamicDelegate.h>

NSInteger const UITextBorderStyleUndef = -1;
NSInteger const NSTextAlignmentUndef = -1;
NSInteger const UITableViewCellAccessoryDisclosureIndicatorDown = 999;
NSInteger const UITableViewCellAccessoryDisclosureIndicatorRight = 998;

@interface UITableViewCell (LayoutGuide)
@property (nonatomic, strong, readonly) UIView *layoutGuideView;
@end

@implementation UITableViewCell (LayoutGuide)

- (UIView *)layoutGuideView {
	UIView *view = [self.contentView viewWithTag:NSStringFromSelector(@selector(layoutGuideView)).hash];
	if (!view) {
		view = [[UIView alloc] init];
		view.tag = NSStringFromSelector(@selector(layoutGuideView)).hash;
		[self.contentView addSubview:view];
	}
	return view;
}

@end

@interface TableViewCellData ()

@property (nonatomic, assign) BOOL needLayoutFittingHeight;
@property (nonatomic, copy) NSString *(^varyingHeightIdentifierBlock) (void);

@property (nonatomic, copy) void (^preInstallBlock) (TableViewCellData *data);

@property (nonatomic, copy) UIImage *(^imageBlock) (void);
@property (nonatomic, copy) UITableViewCellAccessoryType (^accessoryTypeBlock) (void);
@property (nonatomic, copy) UIView *(^accessoryViewBlock) (void);
@property (nonatomic, copy) UIView *(^editingAccessoryViewBlock) (void);
@property (nonatomic, copy) NSString *(^textBlock) (void);
@property (nonatomic, copy) NSString *(^detailTextBlock) (void);
@property (nonatomic, copy) UIColor *(^textColorBlock) (void);
@property (nonatomic, copy) UIColor *(^detailTextColorBlock) (void);
@property (nonatomic, copy) NSAttributedString *(^attributedTextBlock) (void);
@property (nonatomic, copy) NSAttributedString *(^detailAttributedTextBlock) (void);

@property (nonatomic, copy) void (^editingControlPostConfigurationBlock) (id editingControl);
@property (nonatomic, copy) void (^cellPostConfigurationBlock) (UITableView *tableView, NSIndexPath *indexPath, id cell);

@property (nonatomic, copy) id (^valueObservingGetterBlock) (void);
@property (nonatomic, copy) void (^valueObservingSetterBlock) (id value);

@property (nonatomic, copy) void (^valueChangedPostActionBlock) (id sender, UITableView *tableView, NSIndexPath *indexPath);
@property (nonatomic, copy) void (^editingDidEndPostActionBlock) (UITextField *textField, UITableView *tableView, NSIndexPath *indexPath);
@property (nonatomic, copy) BOOL (^shouldSelectBlock) (UITableView *tableView, NSIndexPath *indexPath);
@property (nonatomic, copy) void (^didSelectBlock) (UITableView *tableView, NSIndexPath *indexPath);
@property (nonatomic, copy) void (^didDeselectBlock) (UITableView *tableView, NSIndexPath *indexPath);
@property (nonatomic, copy) void (^didFocusBlock) (UITableView *tableView, NSIndexPath *indexPath);

@property (nonatomic, copy) BOOL (^requiredValidationRuleBlock) (void);
@property (nonatomic, strong) NSMutableArray *integrityValidationRuleBlocks;
@property (nonatomic, copy) NSString *(^requiredValidationMessageBlock) (void);
@property (nonatomic, strong) NSMutableArray *integrityValidationMessageBlocks;

@property (nonatomic, strong, readonly) UIImage *adaptiveImage;
@property (nonatomic, assign, readonly) UITableViewCellAccessoryType adaptiveAccessoryType;
@property (nonatomic, strong, readonly) UIView *adaptiveAccessoryView;
@property (nonatomic, strong, readonly) UIView *adaptiveEditingAccessoryView;
@property (nonatomic, strong, readonly) NSString *adaptiveText;
@property (nonatomic, strong, readonly) NSString *adaptiveDetailText;
@property (nonatomic, strong, readonly) UIColor *adaptiveTextColor;
@property (nonatomic, strong, readonly) UIColor *adaptiveDetailTextColor;
@property (nonatomic, strong, readonly) NSAttributedString *adaptiveAttributedText;
@property (nonatomic, strong, readonly) NSAttributedString *adaptiveDetailAttributedText;

@property (nonatomic, assign, readonly) BOOL isTextLabelNotNull;
@property (nonatomic, assign, readonly) BOOL isDetailTextLabelNotNull;
@property (nonatomic, assign, readonly) BOOL isAccessoryTypeNotNone;

@property (nonatomic, assign, readonly) BOOL needMeasureHeight;
@property (nonatomic, assign, readonly) BOOL needSetupPredefinedViewConstraints;

@property (nonatomic, assign, readonly) BOOL isDataBinding;
@property (nonatomic, strong, readwrite) id bindingData;

@end

@implementation TableViewCellData

- (instancetype)init {
	self = [super init];
	if (self) {
		[self retrievePropertiesToDefault];
	}
	return self;
}

#pragma mark - Protected

- (NSString *)className {
	if (_className) {
		return _className;
	}
	return NSStringFromClass([UITableViewCell class]);
}

- (NSString *)reuseIdentifier {
	if (_reuseIdentifier) {
		return _reuseIdentifier;
	} else {
		NSMutableArray *array = [NSMutableArray array];
		[array addObject:self.className];
		switch (self.style) {
			case UITableViewCellStyleDefault:
				[array addObject:@"Default"];
				break;

			case UITableViewCellStyleValue1:
				[array addObject:@"Value1"];
				break;

			case UITableViewCellStyleValue2:
				[array addObject:@"Value2"];
				break;

			case UITableViewCellStyleSubtitle:
				[array addObject:@"Subtitle"];
				break;

			default:
				break;
		}
		if (self.isTextLabelNotNull) {
			[array addObject:@"TextLabel"];
		}
		if (self.isDetailTextLabelNotNull) {
			[array addObject:@"DetailTextLabel"];
		}
		switch (self.editingType) {
			case TableViewCellEditingTypeTextField:
				[array addObject:@"TextField"];
				break;

			case TableViewCellEditingTypeSegmentedControl:
				[array addObject:@"SegmentedControl"];
				break;

			case TableViewCellEditingTypeSwitch:
				[array addObject:@"Switch"];
				break;

			default:
				break;
		}
		if (self.needSetupPredefinedViewConstraints) {
			[array addObject:@"PredefinedView"];
		}
		if (self.isAccessoryTypeNotNone) {
			[array addObject:@"AccessoryType"];
		}
		return [array componentsJoinedByString:@" "];
	}
}

- (BOOL)isAccessoryTypeNotNone {
	UITableViewCellAccessoryType accessoryType = self.adaptiveAccessoryType;
	if (accessoryType == UITableViewCellAccessoryDisclosureIndicator || accessoryType == UITableViewCellAccessoryDetailDisclosureButton || accessoryType == UITableViewCellAccessoryCheckmark || accessoryType == UITableViewCellAccessoryDetailButton) {
		return YES;
	}
	return NO;
}

- (NSString *)validationMessageCaption {
	if (_validationMessageCaption) {
		return _validationMessageCaption;
	} else if (self.placeholder) {
		return self.placeholder;
	} else if (self.text) {
		return self.text;
	} else if (self.detailText) {
		return self.detailText;
	} else if (self.attributedText) {
		return self.attributedText.string;
	} else if (self.detailAttributedText) {
		return self.detailAttributedText.string;
	}
	return nil;
}

- (BOOL)allowTextLineWrapping {
	if (self.style == UITableViewCellStyleDefault) {
		if (self.editingType == TableViewCellEditingTypeTextField || self.editingType == TableViewCellEditingTypeSegmentedControl) {
			return NO;
		}
	} else if (self.style == UITableViewCellStyleValue1) {
	} else if (self.style == UITableViewCellStyleValue2) {
		if (self.editingType == TableViewCellEditingTypeTextField || self.editingType == TableViewCellEditingTypeSegmentedControl || self.editingType == TableViewCellEditingTypeSwitch) {
			return NO;
		}
	} else if (self.style == UITableViewCellStyleSubtitle) {
		if (self.editingType == TableViewCellEditingTypeTextField) {
			return NO;
		}
	}
	return _allowTextLineWrapping;
}

- (BOOL)allowDetailTextLineWrapping {
	if (self.style == UITableViewCellStyleDefault) {
		return NO;
	}
	if (self.style == UITableViewCellStyleValue1) {
		return NO;
	}
	return _allowDetailTextLineWrapping;
}

- (BOOL)allowDetailTextRequiredFitting {
	if (self.style != UITableViewCellStyleValue1) {
		return NO;
	}
	if (self.editingType == TableViewCellEditingTypeSegmentedControl || self.editingType == TableViewCellEditingTypeSwitch) {
		return YES;
	}
	return _allowDetailTextRequiredFitting;
}

#pragma mark - Public

- (void)empty {
	[self detachPrimitivesToZero];
	[self detachObjectsToNull];
	[self retrievePropertiesToDefault];
}

- (void)setNeedLayoutFittingHeight {
	self.needLayoutFittingHeight = YES;
}

- (void)setRequiredValidationRuleBlock:(BOOL (^) (void))block1 withMessageBlock:(NSString * (^) (void))block2 {
	self.requiredValidationRuleBlock = block1;
	self.requiredValidationMessageBlock = block2;
}

- (void)addIntegrityValidationRuleBlock:(BOOL (^)(void))block {
	[self.integrityValidationRuleBlocks addObject:block ? [block copy] : [NSNull null]];
	[self.integrityValidationMessageBlocks addObject:[NSNull null]];
}

- (void)addIntegrityValidationRuleBlock:(BOOL (^) (void))block1 withMessageBlock:(NSString * (^) (void))block2 {
	[self.integrityValidationRuleBlocks addObject:block1 ? [block1 copy] : [NSNull null]];
	[self.integrityValidationMessageBlocks addObject:block2 ? [block2 copy] : [NSNull null]];
}

- (BOOL)validateRequired {
	if (self.requiredValidationRuleBlock && !self.requiredValidationRuleBlock()) {
		return NO;
	}
	if (self.isEditingRequired) {
		if (self.isDataBinding) {
			if (self.editingType == TableViewCellEditingTypeTextField) {
				if ([StringUtils isBlank:self.bindingData]) {
					return NO;
				}
			} else if (self.editingType == TableViewCellEditingTypeSegmentedControl || self.editingType == TableViewCellEditingTypePickerView) {
				if (!self.bindingData) {
					return NO;
				}
			} else if (self.editingType == TableViewCellEditingTypeDatePicker) {
				if (self.inputDateFormatter) {
					if ([StringUtils isEmpty:self.bindingData]) {
						return NO;
					}
				} else {
					if (!self.bindingData) {
						return NO;
					}
				}
			} else {
				if (!self.bindingData) {
					return NO;
				}
			}
		}
	}
	return YES;
}

- (BOOL)validateIntegrity {
	return [self.integrityValidationRuleBlocks bk_all:^BOOL (id obj) {
		if (obj == [NSNull null]) {
			return YES;
		}
		BOOL (^integrityValidationRuleBlock) (void) = obj;
		return integrityValidationRuleBlock();
	}];
}

- (NSString *)requiredValidationMessage:(BOOL)valid {
	if (self.requiredValidationMessageBlock) {
		return self.requiredValidationMessageBlock();
	}
	if (self.editingType == TableViewCellEditingTypePickerView || self.editingType == TableViewCellEditingTypeDatePicker || self.didSelectBlock) {
		return [NSString stringWithFormat:@"请选择 %@", self.validationMessageCaption.lowercaseString];
	} else if (self.editingType == TableViewCellEditingTypeTextField) {
		return [NSString stringWithFormat:@"请填写 %@", self.validationMessageCaption.lowercaseString];
	} else {
		return [NSString stringWithFormat:@"请完成 %@", self.validationMessageCaption.lowercaseString];
	}
	return nil;
}

- (NSString *)integrityValidationMessage:(BOOL)valid {
	__block NSString *errorMessage = nil;
	[self.integrityValidationRuleBlocks enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		if (obj != [NSNull null]) {
			BOOL (^integrityValidationRuleBlock) (void) = obj;
			if (!integrityValidationRuleBlock()) {
				if (self.integrityValidationMessageBlocks[idx] != [NSNull null]) {
					NSString * (^integrityValidationMessageBlock) (void) = self.integrityValidationMessageBlocks[idx];
					errorMessage = integrityValidationMessageBlock();
				} else {
					errorMessage = [NSString stringWithFormat:@"请在此检查 %@", self.validationMessageCaption.lowercaseString];
				}
			}
		}
		if (errorMessage) {
			*stop = YES;
			return;
		}
	}];
	return errorMessage;
}

#pragma mark - Property

- (BOOL)needLayoutFittingHeight {
	if (_needLayoutFittingHeight) {
		return YES;
	}
	if (self.needMeasureHeight) {
		return YES;
	}
	return NO;
}

- (BOOL)needMeasureHeight {
	if (self.allowTextLineWrapping || self.allowDetailTextLineWrapping) {
		return YES;
	}
	if (self.textLineNumber != 1 || self.detailTextLineNumber != 1) {
		return YES;
	}
	if (self.style == UITableViewCellStyleSubtitle) {
		if (self.editingType == TableViewCellEditingTypeTextField) {
			return YES;
		}
	}
	return NO;
}

- (BOOL)needSetupPredefinedViewConstraints {
	if (self.allowTextLineWrapping || self.allowDetailTextLineWrapping) {
		return YES;
	}
	if (self.allowDetailTextRequiredFitting) {
		return YES;
	}
	if (self.textLineNumber != 1 || self.detailTextLineNumber != 1) {
		return YES;
	}
	if (self.style == UITableViewCellStyleSubtitle) {
		if (self.editingType == TableViewCellEditingTypeTextField) {
			return YES;
		}
	}
	if (self.useAutoLayout) {
		return YES;
	}
	return NO;
}

- (UIImage *)adaptiveImage {
	return self.imageBlock ? self.imageBlock() : self.image;
}

- (UITableViewCellAccessoryType)adaptiveAccessoryType {
	if (self.editingType == TableViewCellEditingTypePickerView || self.editingType == TableViewCellEditingTypeDatePicker) {
		return UITableViewCellAccessoryDisclosureIndicatorDown;
	}
	return self.accessoryTypeBlock ? self.accessoryTypeBlock() : self.accessoryType;
}

- (UIView *)adaptiveAccessoryView {
	return self.accessoryViewBlock ? self.accessoryViewBlock() : nil;
}

- (UIView *)adaptiveEditingAccessoryView {
	return self.editingAccessoryViewBlock ? self.editingAccessoryViewBlock() : nil;
}

- (NSString *)adaptiveText {
	return self.textBlock ? self.textBlock() : self.text;
}

- (NSString *)adaptiveDetailText {
	return self.detailTextBlock ? self.detailTextBlock() : self.detailText;
}

- (UIColor *)adaptiveTextColor {
	return self.textColorBlock ? self.textColorBlock() : self.textColor;
}

- (UIColor *)adaptiveDetailTextColor {
	return self.detailTextColorBlock ? self.detailTextColorBlock() : self.detailTextColor;
}

- (NSAttributedString *)adaptiveAttributedText {
	return self.attributedTextBlock ? self.attributedTextBlock() : self.attributedText;
}

- (NSAttributedString *)adaptiveDetailAttributedText {
	return self.detailAttributedTextBlock ? self.detailAttributedTextBlock() : self.detailAttributedText;
}

- (BOOL)isTextLabelNotNull {
	return self.adaptiveAttributedText || self.adaptiveText;
}

- (BOOL)isDetailTextLabelNotNull {
	return self.adaptiveDetailAttributedText || self.adaptiveDetailText;
}

- (BOOL)isDataBinding {
	return self.observedObject && self.keyPath;
}

- (id)bindingData {
	if ([self.observedObject respondsToSelector:@selector(objectAtIndexedSubscript:)] && [self.keyPath isKindOfClass:[NSNumber class]]) {
		return [self.observedObject objectAtIndexedSubscript:[(NSNumber *) self.keyPath integerValue]];
	} else if ([self.observedObject respondsToSelector:@selector(objectForKeyedSubscript:)] && [self.keyPath conformsToProtocol:@protocol(NSCopying)]) {
		return [self.observedObject objectForKeyedSubscript:self.keyPath];
	} else if ([self.keyPath isKindOfClass:[NSString class]]) {
		return [self.observedObject valueForKeyPath:(NSString *)self.keyPath];
	}
	return nil;
}

- (void)setBindingData:(id)value {
	if ([self.observedObject respondsToSelector:@selector(setObject:atIndexedSubscript:)] && [self.keyPath isKindOfClass:[NSNumber class]]) {
		[self.observedObject setObject:value atIndexedSubscript:[(NSNumber *) self.keyPath integerValue]];
	} else if ([self.observedObject respondsToSelector:@selector(setObject:forKeyedSubscript:)] && [self.keyPath conformsToProtocol:@protocol(NSCopying)]) {
		[self.observedObject setObject:value forKeyedSubscript:self.keyPath];
	} else if ([self.keyPath isKindOfClass:[NSString class]]) {
		[self.observedObject setValue:value forKeyPath:(NSString *)self.keyPath];
	}
}

#pragma mark - Private

- (void)retrievePropertiesToDefault {
	self.style = UITableViewCellStyleDefault;
	self.selectionStyle = UITableViewCellSelectionStyleDefault;
	self.accessoryType = UITableViewCellAccessoryNone;
	self.textAlignment = NSTextAlignmentUndef;
	self.detailTextAlignment = NSTextAlignmentUndef;
	self.textLineNumber = 1;
	self.detailTextLineNumber = 1;
	self.textLineBreakMode = NSLineBreakByTruncatingTail;
	self.detailTextLineBreakMode = NSLineBreakByTruncatingTail;
	self.editingType = TableViewCellEditingTypeUndef;
	self.borderStyle = UITextBorderStyleUndef;
	self.autocapitalizationType = UITextAutocapitalizationTypeNone;
	self.keyboardType = UIKeyboardTypeDefault;
	self.datePickerMode = UIDatePickerModeDate;
	self.inputDateFormatter = [DateFormatUtils ISO_DATE_FORMAT];
	self.integrityValidationRuleBlocks = [NSMutableArray array];
	self.integrityValidationMessageBlocks = [NSMutableArray array];
}

- (void)detachPrimitivesToZero {
	self.tag = 0;
	self.reuseHeight = 0;
	self.useAutomaticDimension = NO;
	self.verticalInset = 0;
	self.allowTextLineWrapping = NO;
	self.allowDetailTextLineWrapping = NO;
	self.useAutoLayout = NO;
	self.adjustTextFontSize = NO;
	self.adjustDetailTextFontSize = NO;
	self.maxLength = 0;
	self.isEditingRequired = NO;
}

- (void)detachObjectsToNull {
	self.identifier = nil;
	self.className = nil;
	self.reuseIdentifier = nil;
	self.stronglyAssociatedObject = nil;
	self.copiedAssociatedObject = nil;
	self.backgroundColor = nil;
	self.selectedBackgroundColor = nil;
	self.image = nil;
	self.text = nil;
	self.detailText = nil;
	self.attributedText = nil;
	self.detailAttributedText = nil;
	self.textColor = nil;
	self.detailTextColor = nil;
	self.textFont = nil;
	self.detailTextFont = nil;
	self.placeholder = nil;
	self.accessoryColor = nil;
	self.keyPath = nil;
	self.leftView = nil;
	self.rightView = nil;
	self.optionValues = nil;
	self.optionTexts = nil;
	self.minimumValue = nil;
	self.maximumValue = nil;
	self.stepValue = nil;
	self.minimumDate = nil;
	self.maximumDate = nil;
	// self.inputDateFormatter = nil;
	self.outputDateFormatter = nil;
	self.validationMessageCaption = nil;
	self.preInstallBlock = nil;
	self.imageBlock = nil;
	self.accessoryTypeBlock = nil;
	self.accessoryViewBlock = nil;
	self.editingAccessoryViewBlock = nil;
	self.textBlock = nil;
	self.detailTextBlock = nil;
	self.textColorBlock = nil;
	self.detailTextColorBlock = nil;
	self.attributedTextBlock = nil;
	self.detailAttributedTextBlock = nil;
	self.editingControlPostConfigurationBlock = nil;
	self.cellPostConfigurationBlock = nil;
	self.valueObservingGetterBlock = nil;
	self.valueObservingSetterBlock = nil;
	self.valueChangedPostActionBlock = nil;
	self.editingDidEndPostActionBlock = nil;
	self.shouldSelectBlock = nil;
	self.didSelectBlock = nil;
	self.didFocusBlock = nil;
	self.requiredValidationRuleBlock = nil;
	self.requiredValidationMessageBlock = nil;
	self.integrityValidationRuleBlocks = nil;
	self.integrityValidationMessageBlocks = nil;
}

@end

@interface TableViewSectionHeaderFooterData ()
@property (nonatomic, assign, readonly) BOOL isTextLabelNotNull;
@property (nonatomic, assign, readonly) BOOL useCustomView;
@end

@implementation TableViewSectionHeaderFooterData

#pragma mark - Public

- (NSString *)reuseIdentifier {
	if (_reuseIdentifier) {
		return _reuseIdentifier;
	} else {
		NSMutableArray *array = [NSMutableArray array];
		[array addObject:@"SectionHeaderFooter"];
		if (self.useCustomView) {
			[array addObject:@"CustomView"];
		}
		return [array componentsJoinedByString:@" "];
	}
}

#pragma mark - Property

- (BOOL)isTextLabelNotNull {
	return self.attributedTitle || self.title;
}

- (BOOL)useCustomView {
	return self.attributedTitle || self.preserveCase;
}

@end

@implementation UIToolkit

+ (NSMutableDictionary *)sharedRowHeightNibs {
	static dispatch_once_t onceToken;
	static NSMutableDictionary *dictionary;
	dispatch_once(&onceToken, ^{
		dictionary = [NSMutableDictionary dictionary];
	});
	return dictionary;
}

+ (NSMutableDictionary *)sharedItemSizeNibs {
	static dispatch_once_t onceToken;
	static NSMutableDictionary *dictionary;
	dispatch_once(&onceToken, ^{
		dictionary = [NSMutableDictionary dictionary];
	});
	return dictionary;
}

+ (NSCache *)sharedRowHeightIdentifierCahce {
	static dispatch_once_t onceToken;
	static NSCache *cache;
	dispatch_once(&onceToken, ^{
		cache = [[NSCache alloc] init];
		cache.countLimit = 1000;
	});
	return cache;
}

#pragma mark - Public

+ (CGFloat)instantiateRowHeightForTableViewCellWithNibName:(NSString *)nibName {
	NSMutableDictionary *dict = [self sharedRowHeightNibs];
	if (!dict[nibName]) {
		NSArray *array = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];
		if (array) {
			UIView *view = array[0];
			dict[nibName] = @(CGRectGetHeight(view.frame));
		}
	}
	return dict[nibName] ? [dict[nibName] floatValue] : [UIConstants defaultTableViewRowHeight];
}

+ (CGSize)instantiateItemSizeForCollectionViewCellWithNibName:(NSString *)nibName {
	NSMutableDictionary *dict = [self sharedItemSizeNibs];
	if (!dict[nibName]) {
		NSArray *array = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];
		if (array) {
			UIView *view = array[0];
			dict[nibName] = [NSValue valueWithCGSize:view.frame.size];
		}
	}
	return dict[nibName] ? [dict[nibName] CGSizeValue] : [UIConstants defaultCollectionViewFlowLayoutItemSize];
}

+ (UITableViewCell *)tableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath cellWithData:(TableViewCellData *)data {
	if (data.preInstallBlock) {
		data.preInstallBlock(data);
	}
	BOOL didSetupConstraints = YES;
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:data.reuseIdentifier];
	if (nil == cell) {
		cell = [[NSClassFromString(data.className) alloc] initWithStyle:data.style reuseIdentifier:data.reuseIdentifier];
		didSetupConstraints = NO;
	}
	cell.selectionStyle = data.selectionStyle;
	cell.backgroundColor = data.backgroundColor ? data.backgroundColor : [UIColor whiteColor];
	cell.selectedBackgroundView = data.selectedBackgroundColor ? [UIView new] : nil;
	cell.selectedBackgroundView.backgroundColor = data.selectedBackgroundColor;
	cell.imageView.image = data.adaptiveImage;
	cell.accessoryType = UITableViewCellAccessoryNone;
	cell.accessoryView = nil;
	if (data.adaptiveAccessoryView) {
		cell.accessoryView = data.adaptiveAccessoryView;
	} else if (data.adaptiveAccessoryType == UITableViewCellAccessoryDisclosureIndicatorDown) {
		UILabel *label = [[UILabel alloc] init];
		label.attributedText = [DrawUtils attributedStringWithFAKIcon:[FAKFontAwesome angleDownIconWithSize:24] fillColor:data.accessoryColor ? data.accessoryColor : [UIColor lightGrayColor]];
		[label sizeToFit];
		cell.accessoryView = label;
	} else if (data.adaptiveAccessoryType == UITableViewCellAccessoryDisclosureIndicatorRight) {
		UILabel *label = [[UILabel alloc] init];
		label.attributedText = [DrawUtils attributedStringWithFAKIcon:[FAKFontAwesome angleRightIconWithSize:24] fillColor:data.accessoryColor ? data.accessoryColor : [UIColor lightGrayColor]];
		[label sizeToFit];
		cell.accessoryView = label;
	} else {
		cell.accessoryType = data.adaptiveAccessoryType;
	}
	if (data.adaptiveEditingAccessoryView) {
		cell.editingAccessoryView = data.adaptiveEditingAccessoryView;
	}
	if (data.textFont) {
		cell.textLabel.font = data.textFont;
	} else {
		cell.textLabel.font = [UIConstants defaultTableViewCellTextLabelFont:data.style];
	}
	if (data.detailTextFont) {
		cell.detailTextLabel.font = data.detailTextFont;
	} else {
		cell.detailTextLabel.font = [UIConstants defaultTableViewCellDetailTextLabelFont:data.style];
	}
	if (data.style == UITableViewCellStyleValue2) {
		if (!data.textColor) {
			data.textColor = tableView.tintColor;
		}
	}
	if (data.adaptiveTextColor) {
		cell.textLabel.textColor = data.adaptiveTextColor;
	} else {
		cell.textLabel.textColor = [UIColor blackColor];
	}
	if (data.adaptiveDetailTextColor) {
		cell.detailTextLabel.textColor = data.adaptiveDetailTextColor;
	} else if (data.style == UITableViewCellStyleValue1) {
		cell.detailTextLabel.textColor = [UIColor colorWithRGBs:0x8e8e93];
	} else {
		cell.detailTextLabel.textColor = [UIColor blackColor];
	}
	cell.textLabel.text = nil;
	cell.textLabel.attributedText = nil;
	cell.detailTextLabel.text = nil;
	cell.detailTextLabel.attributedText = nil;
	if (data.adaptiveAttributedText) {
		cell.textLabel.attributedText = data.adaptiveAttributedText;
	} else if (data.adaptiveText) {
		cell.textLabel.text = data.adaptiveText;
	}
	if (data.adaptiveDetailAttributedText) {
		cell.detailTextLabel.attributedText = data.adaptiveDetailAttributedText;
	} else if (data.adaptiveDetailText) {
		cell.detailTextLabel.text = data.adaptiveDetailText;
	}
	if (data.style == UITableViewCellStyleValue2) {
		cell.textLabel.textAlignment = NSTextAlignmentRight;
	} else if (data.textAlignment != NSTextAlignmentUndef) {
		cell.textLabel.textAlignment = data.textAlignment;
	} else {
		cell.textLabel.textAlignment = NSTextAlignmentLeft;
	}
	if (data.style == UITableViewCellStyleValue1) {
		cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
	} else if (data.detailTextAlignment != NSTextAlignmentUndef) {
		cell.detailTextLabel.textAlignment = data.detailTextAlignment;
	} else {
		cell.detailTextLabel.textAlignment = NSTextAlignmentLeft;
	}
	cell.textLabel.adjustsFontSizeToFitWidth = data.adjustTextFontSize;
	cell.detailTextLabel.adjustsFontSizeToFitWidth = data.adjustDetailTextFontSize;
	cell.textLabel.lineBreakMode = data.textLineBreakMode;
	cell.detailTextLabel.lineBreakMode = data.detailTextLineBreakMode;
	cell.textLabel.numberOfLines = data.textLineNumber;
	cell.detailTextLabel.numberOfLines = data.detailTextLineNumber;
	if (data.style == UITableViewCellStyleDefault) {
		if (data.allowTextLineWrapping) {
			cell.textLabel.numberOfLines = 0;
			cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
		}
		if (data.needSetupPredefinedViewConstraints) {
			if (!didSetupConstraints) {
// [NSLayoutConstraint autoSetIdentifier:@"ImageView|TextLabel(Default)" forConstraints:^{
// [cell.textLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:cell.imageView withOffset:[UIConstants defaultTableViewCellLayoutInsets].left];
// }];
// [NSLayoutConstraint autoSetPriority:UILayoutPriorityRequired - 1 forConstraints:^{
// [cell.textLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:[UIConstants defaultTableViewCellLayoutInsets].left];
// }];
// [NSLayoutConstraint autoSetIdentifier:@"TextLabel(Default)" forConstraints:^{
// [cell.textLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:[UIConstants defaultTableViewCellLayoutInsets].top relation:NSLayoutRelationGreaterThanOrEqual];
// [cell.textLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:data.isAccessoryTypeNotNone ? 0 : [UIConstants defaultTableViewCellLayoutInsets].right];
// [cell.textLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
// }];
			}
		}
	} else if (data.style == UITableViewCellStyleValue1) {
		if (data.allowTextLineWrapping) {
			cell.textLabel.numberOfLines = 0;
			cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
		}
		if (data.allowDetailTextLineWrapping) {
			cell.detailTextLabel.numberOfLines = 0;
			cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
		}
		if (data.needSetupPredefinedViewConstraints) {
			if (!didSetupConstraints) {
// [NSLayoutConstraint autoSetIdentifier:@"ImageView|TextLabel(Value1)" forConstraints:^{
// [cell.textLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:cell.imageView withOffset:[UIConstants defaultTableViewCellLayoutInsets].left];
// }];
// [NSLayoutConstraint autoSetPriority:UILayoutPriorityRequired - 1 forConstraints:^{
// [cell.textLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:[UIConstants defaultTableViewCellLayoutInsets].left];
// }];
// [NSLayoutConstraint autoSetIdentifier:@"TextLabel(Value1)" forConstraints:^{
// [cell.textLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:[UIConstants defaultTableViewCellLayoutInsets].top relation:NSLayoutRelationGreaterThanOrEqual];
// [cell.textLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
// }];
// [NSLayoutConstraint autoSetIdentifier:@"DetailTextLabel(Value1)" forConstraints:^{
// [cell.detailTextLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:data.isAccessoryTypeNotNone ? 0 : [UIConstants defaultTableViewCellLayoutInsets].right];
// [cell.detailTextLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:[UIConstants defaultTableViewCellLayoutInsets].bottom relation:NSLayoutRelationGreaterThanOrEqual];
// [cell.detailTextLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
// }];
// [NSLayoutConstraint autoSetIdentifier:@"TextLabel+DetailTextLabel(Value1)" forConstraints:^{
// [cell.detailTextLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:cell.textLabel withOffset:[UIConstants defaultTableViewCellValue2DetailTextLabelMarginLeft]];
// }];
// [NSLayoutConstraint autoSetPriority:UILayoutPriorityDefaultHigh - 1 forConstraints:^{
// [cell.textLabel autoSetContentCompressionResistancePriorityForAxis:ALAxisHorizontal];
// }];
// [NSLayoutConstraint autoSetPriority:UILayoutPriorityDefaultLow - 1 forConstraints:^{
// [cell.textLabel autoSetContentHuggingPriorityForAxis:ALAxisHorizontal];
// }];
			}
		}
	} else if (data.style == UITableViewCellStyleValue2) {
		if (data.allowTextLineWrapping) {
			cell.textLabel.numberOfLines = 0;
			cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
		} else {
			cell.textLabel.adjustsFontSizeToFitWidth = YES;
		}
		if (data.allowDetailTextLineWrapping) {
			cell.detailTextLabel.numberOfLines = 0;
			cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
		}
		if (data.needSetupPredefinedViewConstraints) {
			if (!didSetupConstraints) {
// [NSLayoutConstraint autoSetIdentifier:@"TextLabel(Value2)" forConstraints:^{
// [cell.textLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:[UIConstants defaultTableViewCellLayoutInsets].left];
// [cell.textLabel autoSetDimension:ALDimensionWidth toSize:[UIConstants defaultTableViewCellValue2TextLabelWidth]];
// [cell.textLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:[UIConstants defaultTableViewCellLayoutInsets].top relation:NSLayoutRelationGreaterThanOrEqual];
// [cell.textLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
// }];
// [NSLayoutConstraint autoSetIdentifier:@"DetailTextLabel(Value2)" forConstraints:^{
// [cell.detailTextLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:[UIConstants defaultTableViewCellValue2DetailTextLabelPointX]];
// [cell.detailTextLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:data.isAccessoryTypeNotNone ? 0 : [UIConstants defaultTableViewCellLayoutInsets].right];
// [cell.detailTextLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:[UIConstants defaultTableViewCellLayoutInsets].bottom relation:NSLayoutRelationGreaterThanOrEqual];
// [cell.detailTextLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
// }];
			}
		}
	} else if (data.style == UITableViewCellStyleSubtitle) {
		if (data.allowTextLineWrapping) {
			cell.textLabel.numberOfLines = 0;
			cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
		}
		if (data.allowDetailTextLineWrapping) {
			cell.detailTextLabel.numberOfLines = 0;
			cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
		}
		if (data.needSetupPredefinedViewConstraints) {
			if (!didSetupConstraints) {
// [NSLayoutConstraint autoSetIdentifier:@"ImageView|LayoutGuideView(Subtitle)" forConstraints:^{
// [cell.layoutGuideView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:cell.imageView withOffset:[UIConstants defaultTableViewCellLayoutInsets].left];
// }];
// [NSLayoutConstraint autoSetPriority:UILayoutPriorityRequired - 1 forConstraints:^{
// [cell.layoutGuideView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:[UIConstants defaultTableViewCellLayoutInsets].left];
// }];
// [NSLayoutConstraint autoSetIdentifier:@"LayoutGuideView(Subtitle)" forConstraints:^{
// [cell.layoutGuideView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:data.isAccessoryTypeNotNone ? 0 : [UIConstants defaultTableViewCellLayoutInsets].right];
// [cell.layoutGuideView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:[UIConstants defaultTableViewCellLayoutInsets].top relation:NSLayoutRelationGreaterThanOrEqual];
// [cell.layoutGuideView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
// }];
// [NSLayoutConstraint autoSetIdentifier:@"TextLabel|LayoutGuideView(Subtitle)" forConstraints:^{
// [cell.textLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:cell.layoutGuideView];
// [cell.textLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:cell.layoutGuideView];
// [cell.textLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:cell.layoutGuideView];
// }];
// [NSLayoutConstraint autoSetIdentifier:@"DetailTextLabel|LayoutGuideView(Subtitle)" forConstraints:^{
// [cell.detailTextLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:cell.layoutGuideView];
// [cell.detailTextLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:cell.layoutGuideView];
// [cell.detailTextLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:cell.layoutGuideView];
// }];
// [NSLayoutConstraint autoSetIdentifier:@"TextLabel+DetailTextLabel(Subtitle)" forConstraints:^{
// [cell.detailTextLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:cell.textLabel];
// }];
// [NSLayoutConstraint autoSetPriority:UILayoutPriorityFittingSizeLevel forConstraints:^{
// [cell.textLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:cell.layoutGuideView];
// [cell.detailTextLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:cell.layoutGuideView];
// }];
			}
		}
	}
	BOOL didSetupEditingControlConstraints = didSetupConstraints;
	if (data.editingType == TableViewCellEditingTypeTextField) {
		UITextField *textField = nil;
		textField = [cell.contentView viewWithTag:NSStringFromClass([UITextField class]).hash];
		if (!textField) {
			textField = [[UITextField alloc] init];
			textField.tag = NSStringFromClass([UITextField class]).hash;
			[cell.contentView addSubview:textField];
			//
			didSetupEditingControlConstraints = NO;
		}
		if (data.borderStyle != UITextBorderStyleUndef) {
			textField.borderStyle = data.borderStyle;
		} else {
			textField.borderStyle = data.placeholder ? UITextBorderStyleNone : UITextBorderStyleRoundedRect;
		}
		textField.placeholder = nil;
		textField.attributedPlaceholder = nil;
		if (data.placeholder) {
			textField.placeholder = data.placeholder;
		}
		textField.secureTextEntry = data.secureTextEntry;
		textField.autocapitalizationType = data.autocapitalizationType;
		textField.keyboardType = data.keyboardType;
		textField.clearButtonMode = UITextFieldViewModeWhileEditing;
		// textField.returnKeyType = UIReturnKeyDone;
		textField.leftView = data.leftView;
		textField.leftViewMode = data.leftView ? UITextFieldViewModeAlways : UITextFieldViewModeNever;
		textField.rightView = data.rightView;
		textField.rightViewMode = data.rightView ? UITextFieldViewModeAlways : UITextFieldViewModeNever;
		textField.inputAccessoryView = nil;
		[textField setBk_shouldChangeCharactersInRangeWithReplacementStringBlock:^BOOL (UITextField *textField, NSRange range, NSString *string) {
			if (data.maxLength > 0 && range.location >= data.maxLength) {
				return NO;
			}
			return YES;
		}];
		[textField setBk_didEndEditingBlock:^(UITextField *textField) {
			if (data.valueObservingSetterBlock) {
				data.valueObservingSetterBlock(textField.text);
			} else if (data.isDataBinding) {
				data.bindingData = textField.text;
			}
			if (data.editingDidEndPostActionBlock) {
				data.editingDidEndPostActionBlock(textField, tableView, indexPath);
			}
		}];
		if (data.valueObservingGetterBlock) {
			textField.text = data.valueObservingGetterBlock();
		} else if (data.isDataBinding) {
			textField.text = data.bindingData;
		} else {
			textField.text = nil;
		}
		if (data.editingControlPostConfigurationBlock) {
			data.editingControlPostConfigurationBlock(textField);
		}
		if (data.style == UITableViewCellStyleDefault) {
			if (!didSetupEditingControlConstraints) {
// [NSLayoutConstraint autoSetIdentifier:@"ImageView|TextField(Default)" forConstraints:^{
// [textField autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:cell.imageView withOffset:[UIConstants defaultTableViewCellLayoutInsets].left];
// }];
// [NSLayoutConstraint autoSetPriority:UILayoutPriorityRequired - 1 forConstraints:^{
// [textField autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:[UIConstants defaultTableViewCellLayoutInsets].left];
// }];
// [NSLayoutConstraint autoSetIdentifier:@"TextField(Default)" forConstraints:^{
// [textField autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:data.isAccessoryTypeNotNone ? 0 : [UIConstants defaultTableViewCellLayoutInsets].right];
// [textField autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
// }];
			}
		} else if (data.style == UITableViewCellStyleValue2) {
			if (!didSetupEditingControlConstraints) {
// [NSLayoutConstraint autoSetIdentifier:@"TextField(Value2)" forConstraints:^{
// [textField autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:[UIConstants defaultTableViewCellValue2DetailTextLabelPointX]];
// [textField autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:data.isAccessoryTypeNotNone ? 0 : [UIConstants defaultTableViewCellLayoutInsets].right];
// [textField autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
// }];
			}
		} else if (data.style == UITableViewCellStyleSubtitle) {
			if (!didSetupEditingControlConstraints || !didSetupConstraints) {
// [NSLayoutConstraint autoSetIdentifier:@"TextField|LayoutGuideView(Subtitle)" forConstraints:^{
// [textField autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:cell.layoutGuideView];
// [textField autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:cell.layoutGuideView];
// [textField autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:cell.layoutGuideView];
// }];
// [NSLayoutConstraint autoSetIdentifier:@"TextField+DetailTextLabel(Subtitle)" forConstraints:^{
// [cell.detailTextLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:textField];
// }];
// [NSLayoutConstraint autoSetPriority:UILayoutPriorityFittingSizeLevel forConstraints:^{
// [textField autoAlignAxis:ALAxisHorizontal toSameAxisOfView:cell.layoutGuideView];
// }];
			}
		}
	} else if (data.editingType == TableViewCellEditingTypeSegmentedControl) {
		UISegmentedControl *segmentedControl = [cell.contentView viewWithTag:NSStringFromClass([UISegmentedControl class]).hash];
		if (!segmentedControl) {
			segmentedControl = [[UISegmentedControl alloc] initWithItems:data.optionTexts];
			segmentedControl.tag = NSStringFromClass([UISegmentedControl class]).hash;
			[cell.contentView addSubview:segmentedControl];
			//
			didSetupEditingControlConstraints = NO;
		}
		[segmentedControl bk_removeEventHandlersForControlEvents:UIControlEventValueChanged];
		[segmentedControl bk_addEventHandler:^(UISegmentedControl *segmentedControl) {
			if (data.valueObservingSetterBlock) {
				data.valueObservingSetterBlock(data.optionValues[segmentedControl.selectedSegmentIndex]);
			} else if (data.isDataBinding) {
				data.bindingData = data.optionValues[segmentedControl.selectedSegmentIndex];
			}
			if (data.valueChangedPostActionBlock) {
				data.valueChangedPostActionBlock(segmentedControl, tableView, indexPath);
			}
		} forControlEvents:UIControlEventValueChanged];
		id optionValue = nil;
		if (data.valueObservingGetterBlock) {
			optionValue = data.valueObservingGetterBlock();
		} else if (data.isDataBinding) {
			optionValue = data.bindingData;
		}
		if ([data.optionValues containsObject:optionValue]) {
			segmentedControl.selectedSegmentIndex = [data.optionValues indexOfObject:optionValue];
		} else {
			segmentedControl.selectedSegmentIndex = UISegmentedControlNoSegment;
		}
		if (data.editingControlPostConfigurationBlock) {
			data.editingControlPostConfigurationBlock(segmentedControl);
		}
		if (!didSetupEditingControlConstraints) {
			if (data.style == UITableViewCellStyleDefault) {
// [NSLayoutConstraint autoSetIdentifier:@"ImageView|SegmentedControl(Default)" forConstraints:^{
// [segmentedControl autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:cell.imageView withOffset:[UIConstants defaultTableViewCellLayoutInsets].left];
// }];
// [NSLayoutConstraint autoSetPriority:UILayoutPriorityRequired - 1 forConstraints:^{
// [segmentedControl autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:[UIConstants defaultTableViewCellLayoutInsets].left];
// }];
// [NSLayoutConstraint autoSetIdentifier:@"SegmentedControl(Default)" forConstraints:^{
// [segmentedControl autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:data.isAccessoryTypeNotNone ? 0 : [UIConstants defaultTableViewCellLayoutInsets].right];
// [segmentedControl autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
// }];
// } else if (data.style == UITableViewCellStyleValue1) {
// [NSLayoutConstraint autoSetIdentifier:@"SegmentedControl(Value1)" forConstraints:^{
// [segmentedControl autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:data.isAccessoryTypeNotNone ? 0 : [UIConstants defaultTableViewCellLayoutInsets].right];
// [segmentedControl autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
// }];
// [NSLayoutConstraint autoSetIdentifier:@"TextLabel+SegmentedControl(Value1)" forConstraints:^{
// [segmentedControl autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:cell.textLabel withOffset:[UIConstants defaultTableViewCellValue2DetailTextLabelMarginLeft]];
// }];
// } else if (data.style == UITableViewCellStyleValue2) {
// [NSLayoutConstraint autoSetIdentifier:@"SegmentedControl(Value2)" forConstraints:^{
// [segmentedControl autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:[UIConstants defaultTableViewCellValue2DetailTextLabelPointX]];
// [segmentedControl autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
// }];
			}
		}
	} else if (data.editingType == TableViewCellEditingTypePickerView) {
		id optionValue = nil;
		if (data.valueObservingGetterBlock) {
			optionValue = data.valueObservingGetterBlock();
		} else if (data.isDataBinding) {
			optionValue = data.bindingData;
		}
		if ([data.optionValues containsObject:optionValue] && data.optionTexts.count == data.optionValues.count) {
			id optionText = data.optionTexts[[data.optionValues indexOfObject:optionValue]];
			if (data.style == UITableViewCellStyleDefault || data.style == UITableViewCellStyleSubtitle) {
				if (!data.isTextLabelNotNull) {
					if ([optionText isKindOfClass:[NSAttributedString class]]) {
						cell.textLabel.attributedText = optionText;
					} else if ([optionText isKindOfClass:[NSString class]]) {
						cell.textLabel.text = optionText;
					}
				}
			} else if (data.style == UITableViewCellStyleValue1 || data.style == UITableViewCellStyleValue2) {
				if (!data.isDetailTextLabelNotNull) {
					if ([optionText isKindOfClass:[NSAttributedString class]]) {
						cell.detailTextLabel.attributedText = optionText;
					} else if ([optionText isKindOfClass:[NSString class]]) {
						cell.detailTextLabel.text = optionText;
					}
				}
			}
		}
	} else if (data.editingType == TableViewCellEditingTypeDatePicker) {
		id dateOrString = nil;
		if (data.valueObservingGetterBlock) {
			dateOrString = data.valueObservingGetterBlock();
		} else if (data.isDataBinding) {
			dateOrString = data.bindingData;
		}
		if ([dateOrString isKindOfClass:[NSString class]]) {
			if (data.inputDateFormatter && data.outputDateFormatter && ![data.inputDateFormatter isEqual:data.outputDateFormatter]) {
				dateOrString = [data.inputDateFormatter parse:dateOrString];
			}
		}
		if ([dateOrString isKindOfClass:[NSDate class]] && data.outputDateFormatter) {
			dateOrString = [data.outputDateFormatter format:dateOrString];
		}
		if (![StringUtils isEmpty:dateOrString]) {
			if (data.style == UITableViewCellStyleDefault || data.style == UITableViewCellStyleSubtitle) {
				if (!data.isTextLabelNotNull) {
					cell.textLabel.text = dateOrString;
				}
			} else if (data.style == UITableViewCellStyleValue1 || data.style == UITableViewCellStyleValue2) {
				if (!data.isDetailTextLabelNotNull) {
					cell.detailTextLabel.text = dateOrString;
				}
			}
		}
	} else if (data.editingType == TableViewCellEditingTypeSwitch) {
		if (data.style == UITableViewCellStyleValue1 || data.style == UITableViewCellStyleValue2) {
			UISwitch *s = [cell.contentView viewWithTag:NSStringFromClass([UISwitch class]).hash];
			if (!s) {
				s = [[UISwitch alloc] init];
				s.tag = NSStringFromClass([UISwitch class]).hash;
				[cell.contentView addSubview:s];
				//
				didSetupEditingControlConstraints = NO;
			}
			[s bk_removeEventHandlersForControlEvents:UIControlEventValueChanged];
			[s bk_addEventHandler:^(UISwitch *s) {
				if (data.valueObservingSetterBlock) {
					data.valueObservingSetterBlock(@(s.on));
				} else if (data.isDataBinding) {
					data.bindingData = @(s.on);
				}
				if (data.valueChangedPostActionBlock) {
					data.valueChangedPostActionBlock(s, tableView, indexPath);
				}
			} forControlEvents:UIControlEventValueChanged];
			if (data.valueObservingGetterBlock) {
				s.on = [data.valueObservingGetterBlock() boolValue];
			} else if (data.isDataBinding) {
				s.on = [data.bindingData boolValue];
			}
			if (data.editingControlPostConfigurationBlock) {
				data.editingControlPostConfigurationBlock(s);
			}
			if (!didSetupEditingControlConstraints) {
				if (data.style == UITableViewCellStyleValue1) {
// [NSLayoutConstraint autoSetIdentifier:@"Switch(Value1)" forConstraints:^{
// [s autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:data.isAccessoryTypeNotNone ? 0 : [UIConstants defaultTableViewCellLayoutInsets].right];
// [s autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
// }];
// [NSLayoutConstraint autoSetIdentifier:@"TextLabel+Switch(Value1)" forConstraints:^{
// [s autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:cell.textLabel withOffset:[UIConstants defaultTableViewCellValue2DetailTextLabelMarginLeft]];
// }];
// } else if (data.style == UITableViewCellStyleValue2) {
// [NSLayoutConstraint autoSetIdentifier:@"Switch(Value2)" forConstraints:^{
// [s autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:[UIConstants defaultTableViewCellValue2DetailTextLabelPointX]];
// [s autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
// }];
				}
			}
		}
	}
	if (!didSetupConstraints || !didSetupEditingControlConstraints) {
		// why must in iOS 10
		[cell.contentView setNeedsUpdateConstraints];
	}
	if (data.cellPostConfigurationBlock) {
		data.cellPostConfigurationBlock(tableView, indexPath, cell);
	}
	return cell;
}

+ (void)tableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath didSelectWithData:(TableViewCellData *)data {
	if (data.shouldSelectBlock) {
		if (!data.shouldSelectBlock(tableView, indexPath)) {
			return;
		}
	}
	if (data.didSelectBlock) {
		data.didSelectBlock(tableView, indexPath);
	} else if (data.editingType == TableViewCellEditingTypePickerView && data.optionTexts.count == data.optionValues.count && data.optionValues.count != 0) {
		UIPickerView *pickerView = [[UIPickerView alloc] init];
		[pickerView.bk_dynamicDataSource implementMethod:@selector(numberOfComponentsInPickerView:) withBlock:^NSInteger (UIPickerView *pickerView) {
			return 1;
		}];
		[pickerView.bk_dynamicDataSource implementMethod:@selector(pickerView:numberOfRowsInComponent:) withBlock:^NSInteger (UIPickerView *pickerView, NSInteger component) {
			return data.optionValues.count;
		}];
		pickerView.dataSource = pickerView.bk_dynamicDataSource;
		if ([data.optionTexts bk_all:^BOOL (id obj) {
			return [obj isKindOfClass:[NSString class]];
		}]) {
			[pickerView.bk_dynamicDelegate implementMethod:@selector(pickerView:titleForRow:forComponent:) withBlock:^NSString *(UIPickerView *pickerView, NSInteger row, NSInteger component) {
				return data.optionTexts[row];
			}];
			pickerView.delegate = pickerView.bk_dynamicDelegate;
		} else if ([data.optionTexts bk_all:^BOOL (id obj) {
			return [obj isKindOfClass:[NSAttributedString class]];
		}]) {
			[pickerView.bk_dynamicDelegate implementMethod:@selector(pickerView:attributedTitleForRow:forComponent:) withBlock:^NSString *(UIPickerView *pickerView, NSInteger row, NSInteger component) {
				return data.optionTexts[row];
			}];
			pickerView.delegate = pickerView.bk_dynamicDelegate;
		}
		id optionValue = nil;
		if (data.valueObservingGetterBlock) {
			optionValue = data.valueObservingGetterBlock();
		} else if (data.isDataBinding) {
			optionValue = data.bindingData;
		}
		if ([data.optionValues containsObject:optionValue]) {
			[pickerView selectRow:[data.optionValues indexOfObject:optionValue] inComponent:0 animated:YES];
		}
// NavigationItemSheet *sheet = [[NavigationItemSheet alloc] initWithViews:@[pickerView] handler:^{
// if (data.valueObservingSetterBlock) {
// data.valueObservingSetterBlock(data.optionValues[[pickerView selectedRowInComponent:0]]);
// } else if (data.isDataBinding) {
// data.bindingData = data.optionValues[[pickerView selectedRowInComponent:0]];
// }
// if (data.valueChangedPostActionBlock) {
// data.valueChangedPostActionBlock(pickerView, tableView, indexPath);
// } else {
// [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
// }
// }];
// [sheet show];
	} else if (data.editingType == TableViewCellEditingTypeDatePicker) {
		UIDatePicker *datePicker = [[UIDatePicker alloc] init];
		datePicker.datePickerMode = data.datePickerMode;
		datePicker.locale = [NSLocale currentLocale];
		datePicker.minimumDate = data.minimumDate;
		datePicker.maximumDate = data.maximumDate;
		id dateOrString = nil;
		if (data.valueObservingGetterBlock) {
			dateOrString = data.valueObservingGetterBlock();
		} else if (data.isDataBinding) {
			dateOrString = data.bindingData;
		}
		if ([dateOrString isKindOfClass:[NSString class]] && data.inputDateFormatter) {
			dateOrString = [data.inputDateFormatter parse:dateOrString];
		}
		if (dateOrString && [dateOrString isKindOfClass:[NSDate class]]) {
			datePicker.date = dateOrString;
		}
// NavigationItemSheet *sheet = [[NavigationItemSheet alloc] initWithViews:@[datePicker] handler:^{
// id dateOrString = data.inputDateFormatter ? [data.inputDateFormatter format:datePicker.date] : datePicker.date;
// if (data.valueObservingSetterBlock) {
// data.valueObservingSetterBlock(dateOrString);
// } else if (data.isDataBinding) {
// data.bindingData = dateOrString;
// }
// if (data.valueChangedPostActionBlock) {
// data.valueChangedPostActionBlock(datePicker, tableView, indexPath);
// } else {
// [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
// }
// }];
// [sheet show];
	}
}

+ (void)tableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath didDeselectWithData:(TableViewCellData *)data {
	if (data.didDeselectBlock) {
		data.didDeselectBlock(tableView, indexPath);
	}
}

+ (void)tableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath didFocusWithData:(TableViewCellData *)data {
	if (data.didFocusBlock) {
		data.didFocusBlock(tableView, indexPath);
	} else if (data.editingType == TableViewCellEditingTypeTextField) {
		[tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
		UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
		UITextField *textField = [cell.contentView viewWithTag:NSStringFromClass([UITextField class]).hash];
		[textField becomeFirstResponder];
	} else if (data.editingType == TableViewCellEditingTypePickerView || data.editingType == TableViewCellEditingTypeDatePicker || data.didSelectBlock) {
		[tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
		if ([tableView.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
			[tableView.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
		}
	} else {
		[tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
	}
}

+ (CGFloat)tableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath rowHeightWithData:(TableViewCellData *)data {
	if (data.preInstallBlock) {
		data.preInstallBlock(data);
	}
	if (data.useAutomaticDimension) {
		return UITableViewAutomaticDimension;
	}
	CGFloat reuseHeight = data.reuseHeight;
	if (reuseHeight != 0) {
	} else if (data.needLayoutFittingHeight) {
		NSString *HeightIdentifier = [NSString stringWithFormat:@"%lu %d %ld %ld %lu %@", (unsigned long)tableView.hash, tableView.editing, (long)indexPath.section, (long)indexPath.row, (unsigned long)data.hash, data.varyingHeightIdentifierBlock ? data.varyingHeightIdentifierBlock() : nil];
		CGFloat cacheHeight = [[[self sharedRowHeightIdentifierCahce] objectForKey:HeightIdentifier] floatValue];
		if (cacheHeight == 0) {
			if ([tableView.dataSource respondsToSelector:@selector(tableView:cellForRowAtIndexPath:)]) {
				UITableViewCell *cell = [tableView.dataSource tableView:tableView cellForRowAtIndexPath:indexPath];
				CGFloat contentWidth = [UIToolkit calculatedContentWidthForCell:cell onTableView:tableView];
				NSLayoutConstraint *tempWidthConstraint = [NSLayoutConstraint constraintWithItem:cell.contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:contentWidth];
				tempWidthConstraint.priority = UILayoutPriorityRequired - 1;
				[cell.contentView addConstraint:tempWidthConstraint];
				// Auto layout engine does its math
				CGSize contentSize = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
				[cell.contentView removeConstraint:tempWidthConstraint];
				CGFloat rowHeight = contentSize.height + [UIConstants defaultTableViewSeparatorHeight] / [UIScreen mainScreen].scale;
				cacheHeight = MAX(rowHeight, [UIConstants defaultTableViewRowHeight]);
			}
			if (cacheHeight != 0) {
				[[self sharedRowHeightIdentifierCahce] setObject:@(cacheHeight) forKey:HeightIdentifier];
			}
		}
		reuseHeight = cacheHeight + data.verticalInset;
	}
	return reuseHeight != 0 ? reuseHeight : [UIConstants defaultTableViewRowHeight];
}

+ (NSString *)tableView:(UITableView *)tableView inSection:(NSInteger)section headerTitleWithData:(TableViewSectionHeaderFooterData *)data {
	return [UIToolkit tableView:tableView inSection:section titleWithData:data];
}

+ (NSString *)tableView:(UITableView *)tableView inSection:(NSInteger)section footerTitleWithData:(TableViewSectionHeaderFooterData *)data {
	return [UIToolkit tableView:tableView inSection:section titleWithData:data];
}

+ (UIView *)tableView:(UITableView *)tableView inSection:(NSInteger)section headerViewWithData:(TableViewSectionHeaderFooterData *)data {
	return [UIToolkit tableView:tableView inSection:section viewWithData:data];
}

+ (UIView *)tableView:(UITableView *)tableView inSection:(NSInteger)section footerViewWithData:(TableViewSectionHeaderFooterData *)data {
	return [UIToolkit tableView:tableView inSection:section viewWithData:data];
}

+ (CGFloat)tableView:(UITableView *)tableView inSection:(NSInteger)section headerHeightWithData:(TableViewSectionHeaderFooterData *)data {
	return [UIToolkit tableView:tableView inSection:section heightWithData:data];
}

+ (CGFloat)tableView:(UITableView *)tableView inSection:(NSInteger)section footerHeightWithData:(TableViewSectionHeaderFooterData *)data {
	return [UIToolkit tableView:tableView inSection:section heightWithData:data];
}

#pragma mark - Private

+ (CGFloat)visibleWidthForTableView:(UITableView *)tableView {
	CGFloat width = CGRectGetWidth(tableView.frame);
	if ([tableView.dataSource respondsToSelector:@selector(sectionIndexTitlesForTableView:)]) {
		if ([tableView.dataSource sectionIndexTitlesForTableView:tableView]) {
			width -= 15;
		}
	}
	if (tableView.editing) {
		width -= 37.5;
	}
	return width;
}

+ (CGFloat)calculatedContentWidthForCell:(UITableViewCell *)cell onTableView:(UITableView *)tableView {
	CGFloat accessoryWidth = 320 - [UIConstants defaultTableViewCellContentViewWidth:cell.accessoryType];
	if (cell.accessoryView) {
		// why need padding
		accessoryWidth += CGRectGetWidth(cell.accessoryView.frame) + 15;
	} else if (cell.accessoryType == UITableViewCellAccessoryNone) {
		accessoryWidth += 15;
	}
	CGFloat imageWidth = 0;
	if (cell.imageView.image) {
		// why need padding
		imageWidth = cell.imageView.image.size.width + 15;
	}
	CGFloat otherWidth = CGRectGetWidth(tableView.frame) - 320;
	return [UIToolkit visibleWidthForTableView:tableView] - accessoryWidth - imageWidth - otherWidth;
}

+ (NSString *)tableView:(UITableView *)tableView inSection:(NSInteger)section titleWithData:(TableViewSectionHeaderFooterData *)data {
	if (data.useCustomView) {
		return nil;
	}
	return data.title;
}

+ (UIView *)tableView:(UITableView *)tableView inSection:(NSInteger)section viewWithData:(TableViewSectionHeaderFooterData *)data {
	if (!data.useCustomView) {
		return nil;
	}
	BOOL didSetupConstraints = YES;
	UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:data.reuseIdentifier];
	if (view == nil) {
		view = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:data.reuseIdentifier];
		didSetupConstraints = NO;
	}
	BOOL didSetupTextLabelConstraints = didSetupConstraints;
	UILabel *textLabel = [view.contentView viewWithTag:NSStringFromClass([UILabel class]).hash];
	if (!textLabel) {
		textLabel = [[UILabel alloc] init];
		textLabel.tag = NSStringFromClass([UILabel class]).hash;
		[view.contentView addSubview:textLabel];
		//
		didSetupTextLabelConstraints = NO;
	}
	textLabel.textColor = [UIColor colorWithRGBs:0x6d6d72];
	textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
	if (data.attributedTitle) {
		textLabel.attributedText = data.attributedTitle;
	} else if (data.title) {
		textLabel.text = data.title;
	}
	textLabel.numberOfLines = 0;
	textLabel.preferredMaxLayoutWidth = [UIToolkit visibleWidthForTableView:tableView] - [UIConstants defaultTableViewCellLayoutInsets].left - [UIConstants defaultTableViewCellLayoutInsets].right;
	if (!didSetupTextLabelConstraints || !didSetupConstraints) {
// [NSLayoutConstraint autoSetIdentifier:@"TextLabel" forConstraints:^{
// [textLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:[UIConstants defaultTableViewCellLayoutInsets].left];
// }];
// [NSLayoutConstraint autoSetPriority:UILayoutPriorityRequired - 1 forConstraints:^{
// [textLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:[UIConstants defaultTableViewCellLayoutInsets].top];
// [textLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:[UIConstants defaultTableViewCellLayoutInsets].bottom];
// }];
// [NSLayoutConstraint autoSetPriority:UILayoutPriorityRequired forConstraints:^{
// [textLabel autoSetContentCompressionResistancePriorityForAxis:ALAxisVertical];
// [textLabel autoSetContentHuggingPriorityForAxis:ALAxisVertical];
// }];
	}
	return view;
}

+ (CGFloat)tableView:(UITableView *)tableView inSection:(NSInteger)section heightWithData:(TableViewSectionHeaderFooterData *)data {
	CGFloat reuseHeight = data.reuseHeight;
	if (reuseHeight != 0) {
	} else if (!data.useCustomView) {
		return UITableViewAutomaticDimension;
	} else {
		if ([tableView.delegate respondsToSelector:@selector(tableView:viewForHeaderInSection:)]) {
			UITableViewHeaderFooterView *view = (UITableViewHeaderFooterView *)[tableView.delegate tableView:tableView viewForHeaderInSection:section];
			CGSize contentSize = [view.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
			CGFloat sectionHeight = contentSize.height;
			if (section == 0) {
				sectionHeight += [UIConstants defaultTableViewSectionHeight:tableView.style];
			}
			reuseHeight = sectionHeight + data.verticalInset;
		}
	}
	return reuseHeight != 0 ? reuseHeight : [UIConstants defaultTableViewSectionHeight:tableView.style];
}

@end
