//
// UIToolkit.h
// GoToBus
//
// Created by haibara on 10/8/14.
//
//

@import Foundation;
@import UIKit;

typedef NS_ENUM (NSInteger, TableViewCellEditingType) {
	TableViewCellEditingTypeUndef = 0,
	TableViewCellEditingTypeSwitch,
	TableViewCellEditingTypeSegmentedControl,
	TableViewCellEditingTypeTextField,
	TableViewCellEditingTypeDatePicker,
	TableViewCellEditingTypePickerView,
	TableViewCellEditingTypeCustom,
};

FOUNDATION_EXTERN NSInteger const NSTextAlignmentUndef;
UIKIT_EXTERN NSInteger const UITextBorderStyleUndef;
UIKIT_EXTERN NSInteger const UITableViewCellAccessoryDisclosureIndicatorDown;
UIKIT_EXTERN NSInteger const UITableViewCellAccessoryDisclosureIndicatorRight;

@interface TableViewCellData : NSObject

@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *className;
@property (nonatomic, strong) NSString *reuseIdentifier;
@property (nonatomic, assign) CGFloat reuseHeight;
@property (nonatomic, assign) BOOL useAutomaticDimension;
@property (nonatomic, assign) CGFloat verticalInset;
@property (nonatomic, weak) id weaklyAssociatedObject;
@property (nonatomic, strong) id stronglyAssociatedObject;
@property (nonatomic, copy) id copiedAssociatedObject;

@property (nonatomic, assign) UITableViewCellStyle style;
@property (nonatomic, assign) UITableViewCellSelectionStyle selectionStyle;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIColor *selectedBackgroundColor;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *detailText;
@property (nonatomic, strong) NSAttributedString *attributedText;
@property (nonatomic, strong) NSAttributedString *detailAttributedText;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *detailTextColor;
@property (nonatomic, strong) UIFont *textFont;
@property (nonatomic, strong) UIFont *detailTextFont;
@property (nonatomic, assign) NSTextAlignment textAlignment;
@property (nonatomic, assign) NSTextAlignment detailTextAlignment;
@property (nonatomic, assign) BOOL adjustTextFontSize;
@property (nonatomic, assign) BOOL adjustDetailTextFontSize;
@property (nonatomic, assign) NSLineBreakMode textLineBreakMode;
@property (nonatomic, assign) NSLineBreakMode detailTextLineBreakMode;
@property (nonatomic, assign) NSInteger textLineNumber;
@property (nonatomic, assign) NSInteger detailTextLineNumber;
@property (nonatomic, assign) BOOL allowTextLineWrapping;
@property (nonatomic, assign) BOOL allowDetailTextLineWrapping;
@property (nonatomic, assign) BOOL allowDetailTextRequiredFitting;
@property (nonatomic, assign) BOOL useAutoLayout;
@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, assign) UITableViewCellAccessoryType accessoryType;
@property (nonatomic, strong) UIColor *accessoryColor;

@property (nonatomic, assign) TableViewCellEditingType editingType;
@property (nonatomic, weak) id observedObject;
@property (nonatomic, strong) id keyPath;
@property (nonatomic, assign) BOOL secureTextEntry;
@property (nonatomic, assign) UITextBorderStyle borderStyle;
@property (nonatomic, assign) UITextAutocapitalizationType autocapitalizationType;
@property (nonatomic, assign) UIKeyboardType keyboardType;
@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) UIView *rightView;
@property (nonatomic, assign) NSInteger maxLength;
@property (nonatomic, strong) NSArray *optionValues;
@property (nonatomic, strong) NSArray *optionTexts;
@property (nonatomic, strong) NSNumber *maximumValue;
@property (nonatomic, strong) NSNumber *minimumValue;
@property (nonatomic, strong) NSNumber *stepValue;
@property (nonatomic, assign) UIDatePickerMode datePickerMode;
@property (nonatomic, strong) NSDateFormatter *inputDateFormatter;
@property (nonatomic, strong) NSDateFormatter *outputDateFormatter;
@property (nonatomic, strong) NSDate *minimumDate;
@property (nonatomic, strong) NSDate *maximumDate;
@property (nonatomic, strong) NSString *validationMessageCaption;
@property (nonatomic, assign) BOOL isEditingRequired;

- (void)empty;

- (void)setNeedLayoutFittingHeight;
- (void)setVaryingHeightIdentifierBlock:(NSString * (^) (void))block;

- (void)setPreInstallBlock:(void (^) (TableViewCellData *data))block;

- (void)setImageBlock:(UIImage * (^) (void))block;
- (void)setAccessoryTypeBlock:(UITableViewCellAccessoryType (^) (void))block;
- (void)setAccessoryViewBlock:(UIView * (^) (void))block;
- (void)setEditingAccessoryViewBlock:(UIView * (^)(void))block;
- (void)setTextBlock:(NSString * (^) (void))block;
- (void)setDetailTextBlock:(NSString * (^) (void))block;
- (void)setTextColorBlock:(UIColor * (^) (void))block;
- (void)setDetailTextColorBlock:(UIColor * (^) (void))block;
- (void)setAttributedTextBlock:(NSAttributedString * (^) (void))block;
- (void)setDetailAttributedTextBlock:(NSAttributedString * (^) (void))block;

- (void)setValueObservingGetterBlock:(id (^) (void))block;
- (void)setValueObservingSetterBlock:(void (^) (id value))block;

- (void)setEditingControlPostConfigurationBlock:(void (^) (id editingControl))block;
- (void)setCellPostConfigurationBlock:(void (^) (UITableView *tableView, NSIndexPath *indexPath, id cell))block;

- (void)setValueChangedPostActionBlock:(void (^) (id editingControl, UITableView *tableView, NSIndexPath *indexPath))block;
- (void)setEditingDidEndPostActionBlock:(void (^) (UITextField *textField, UITableView *tableView, NSIndexPath *indexPath))block;
- (void)setShouldSelectBlock:(BOOL (^) (UITableView *tableView, NSIndexPath *indexPath))block;
- (void)setDidSelectBlock:(void (^) (UITableView *tableView, NSIndexPath *indexPath))block;
- (void)setDidDeselectBlock:(void (^) (UITableView *tableView, NSIndexPath *indexPath))block;
- (void)setDidFocusBlock:(void (^) (UITableView *tableView, NSIndexPath *indexPath))block;

- (void)setRequiredValidationRuleBlock:(BOOL (^) (void))block;
- (void)setRequiredValidationRuleBlock:(BOOL (^) (void))block1 withMessageBlock:(NSString * (^) (void))block2;
- (void)addIntegrityValidationRuleBlock:(BOOL (^) (void))block;
- (void)addIntegrityValidationRuleBlock:(BOOL (^) (void))block1 withMessageBlock:(NSString * (^) (void))block2;

- (BOOL)validateIntegrity;
- (BOOL)validateRequired;
- (NSString *)requiredValidationMessage:(BOOL)valid;
- (NSString *)integrityValidationMessage:(BOOL)valid;

@end

@interface TableViewSectionHeaderFooterData : NSObject
@property (nonatomic, strong) NSString *reuseIdentifier;
@property (nonatomic, assign) CGFloat reuseHeight;
@property (nonatomic, assign) CGFloat verticalInset;
@property (nonatomic, assign) BOOL preserveCase;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSAttributedString *attributedTitle;
@end

@interface UIToolkit : NSObject

+ (CGFloat)instantiateRowHeightForTableViewCellWithNibName:(NSString *)nibName;
+ (CGSize)instantiateItemSizeForCollectionViewCellWithNibName:(NSString *)nibName;

+ (UITableViewCell *)tableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath cellWithData:(TableViewCellData *)data;
+ (void)tableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath didSelectWithData:(TableViewCellData *)data;
+ (void)tableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath didDeselectWithData:(TableViewCellData *)data;
+ (void)tableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath didFocusWithData:(TableViewCellData *)data;
+ (CGFloat)tableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath rowHeightWithData:(TableViewCellData *)data;

+ (NSString *)tableView:(UITableView *)tableView inSection:(NSInteger)section headerTitleWithData:(TableViewSectionHeaderFooterData *)data;
+ (NSString *)tableView:(UITableView *)tableView inSection:(NSInteger)section footerTitleWithData:(TableViewSectionHeaderFooterData *)data;
+ (UIView *)tableView:(UITableView *)tableView inSection:(NSInteger)section headerViewWithData:(TableViewSectionHeaderFooterData *)data;
+ (UIView *)tableView:(UITableView *)tableView inSection:(NSInteger)section footerViewWithData:(TableViewSectionHeaderFooterData *)data;
+ (CGFloat)tableView:(UITableView *)tableView inSection:(NSInteger)section headerHeightWithData:(TableViewSectionHeaderFooterData *)data;
+ (CGFloat)tableView:(UITableView *)tableView inSection:(NSInteger)section footerHeightWithData:(TableViewSectionHeaderFooterData *)data;

@end
