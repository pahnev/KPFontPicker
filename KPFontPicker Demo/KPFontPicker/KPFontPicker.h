//
//  KPFontPicker.h
//  KPFontPicker
//
//  Created by Kirill Pahnev on 20.4.2015.
//  Copyright (c) 2015 Kirill Pahnev. All rights reserved.
//
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, KPFontPickerColorVariants) {
    KPFontPickerColorVariantsNone = 0,
    KPFontPickerColorVariants222 = 8,
    KPFontPickerColorVariants333 = 27,
    KPFontPickerColorVariants444 = 64, // default
    KPFontPickerColorVariants555 = 125,
    KPFontPickerColorVariants666 = 216, // web safe color
};

@protocol KPFontPickerDelegate <NSObject>

/**
 @brief             Called by the picker view when the user selects a row in any component.
 @param font        Name of the font selected in the picker.
 @param fontSize    Size of the font selected in the picker.
 @param fontColor   Color of the font selected in the picker.
 */
- (void)pickerDidSelectFont:(NSString *)font withSize:(CGFloat)fontSize color:(UIColor *)fontColor;

@optional

- (void)pickerDidSelectRow:(NSInteger)row inComponent:(NSInteger)component;
- (void)pickerDidSelectFont:(NSString *)font;
- (void)pickerDidSelectFontSize:(CGFloat)fontSize;
- (void)pickerDidSelectFontColor:(UIColor *)fontColor;

@end

@interface KPFontPicker : UIView <UIPickerViewDelegate, UIPickerViewDataSource>

@property(nonatomic, weak) id<KPFontPickerDelegate> delegate;
@property(strong, nonatomic) UIPickerView *pickerView;

@property(strong, nonatomic) NSArray *fontList;
@property(strong, nonatomic) NSArray *sizeList;
@property(strong, nonatomic) NSArray *colorList;

@property(strong, nonatomic) NSString *fontName;
@property CGFloat fontSize;
@property(strong, nonatomic) UIColor *color;

@property(strong, nonatomic) UIFont *font;
@property CGFloat minFontSize;
@property CGFloat maxFontSize;
@property CGFloat stepFontSize;

@property KPFontPickerColorVariants colorVariants;
@property NSInteger grayVariants;

/**
 @brief         Simple pickerview to modify elements that contain text.
 @param fonts   Assign an array of your selected font.
 @return        A container view which contains the UIPicker with
 */
- (instancetype)initWithFonts:(NSArray *)fonts;

@end
