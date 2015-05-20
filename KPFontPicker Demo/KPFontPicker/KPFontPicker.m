//
//  KPFontPicker.m
//  KPFontPicker
//
//  Created by Kirill Pahnev on 20.4.2015.
//  Copyright (c) 2015 Kirill Pahnev. All rights reserved.
//

#import "KPFontPicker.h"

#define kWindowSize [UIScreen mainScreen].bounds.size

typedef NS_ENUM(NSUInteger, PickerComponents) {
    FontComponent,
    FontSizeComponent,
    FontColorComponent,
};

@implementation KPFontPicker

NSString *const kDefaultFontName = @"Helvetica";
static const NSInteger kDefaultFontSize = 17;

static const KPFontPickerColorVariants KPFontPickerColorVariantsDefault = KPFontPickerColorVariants444;
static const NSInteger KPFontPickerGrayVariantsDefault = 3;

static const CGFloat KPFontPickerMinFontSizeDefault = 8;
static const CGFloat KPFontPickerMaxFontSizeDefault = 72;
static const CGFloat KpFontPickerStepFontSizeDefault = 1;

static const CGFloat kRowHeight = 30;

- (instancetype)initWithFonts:(NSArray *)fonts
{
    self = [super init];
    if (self) {

        if (!self.pickerView) {
            _fontList = fonts;

            self.frame = CGRectMake(0.0, 0.0, kWindowSize.width, 216);
            _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 0.0, kWindowSize.width, 216.0)];
            _pickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            _pickerView.dataSource = self;
            _pickerView.delegate = self;
            self.backgroundColor = [UIColor colorWithWhite:0.98 alpha:0.98];

            _pickerView.tintColor = [UIColor blackColor];

            _pickerView.showsSelectionIndicator = YES;
            [self addSubview:_pickerView];

            [self setInitialPickerValues];
        }
    }
    return self;
}

- (instancetype)init
{
    return [self initWithFonts:nil];
}

- (void)setInitialPickerValues
{
    if (!_fontName) {
        _fontName = kDefaultFontName;
        NSInteger fontRow = [self indexForFontName:_fontName];
        [self.pickerView selectRow:fontRow inComponent:0 animated:YES];
    }
    if (!_fontSize) {
        _fontSize = kDefaultFontSize;
        NSInteger sizeRow = [self indexForFontSize:_fontSize];
        [self.pickerView selectRow:sizeRow inComponent:1 animated:YES];
    }
    if (!_color) {
        _color = [UIColor blackColor];
        NSInteger row = [self indexForNearestColor:_color];
        [self.pickerView selectRow:row inComponent:2 animated:YES];
    }
}

- (NSInteger)indexForNearestColor:(UIColor *)color
{
    if (!color)
        return NSNotFound;
    CGFloat r1, g1, b1, a1;
    [color getRed:&r1 green:&g1 blue:&b1 alpha:&a1];
    r1 = round(r1 * 255);
    g1 = round(g1 * 255);
    b1 = round(b1 * 255);

    CGFloat distance = MAXFLOAT;
    NSInteger index = NSNotFound;
    for (int i = 0; i < self.colorList.count; i++) {
        UIColor *testColor = self.colorList[i];
        if (!testColor)
            return NSNotFound;
        CGFloat r2, g2, b2, a2;
        [testColor getRed:&r2 green:&g2 blue:&b2 alpha:&a2];
        r2 = round(r2 * 255);
        g2 = round(g2 * 255);
        b2 = round(b2 * 255);

        // test RGB color code as 0-255 integer number but not float number
        if (r1 == r2 && g1 == g2 && b1 == b2) {
            return i;
        }

        CGFloat testDist = (r1 - r2) * (r1 - r2) + (g1 - g2) * (g1 - g2) + (b1 - b2) * (b1 - b2);
        if (testDist < distance) {
            distance = testDist;
            index = i;
        }
    }
    return index;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

#pragma mark - UIPickerView data source
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == FontComponent) {
        return self.fontList.count;
    } else if (component == FontSizeComponent) {
        return self.sizeList.count;
    } else if (component == FontColorComponent) {
        return self.colorList.count;
    }
    // Something went wrong
    return NAN;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (component == FontComponent) {
        return 200;
    } else if (component == FontSizeComponent) {
        return 60;
    } else if (component == FontColorComponent) {
        return 60;
    }
    return NAN; // something wrong
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return kRowHeight;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view;
{
    NSString *string;
    CGFloat size = 19;
    UIFont *font = [UIFont systemFontOfSize:size];
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor darkTextColor];
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    //    CGFloat width = 100;

    if (component == FontComponent) {
        if (self.fontList.count <= row) {
            return nil;
        }
        NSString *fontName = self.fontList[row];
        font = [UIFont fontWithName:fontName size:size];
        string = fontName;
        label.font = font;
        label.frame = CGRectMake(0, 0, kWindowSize.width * 0.6, kRowHeight);

    } else if (component == FontSizeComponent) {
        if (self.sizeList.count <= row) {
            return nil;
        }
        NSNumber *fontNumber = self.sizeList[row];
        CGFloat fontSize = fontNumber.floatValue;
        if (fontSize == floor(fontSize)) {
            string = [NSString stringWithFormat:@"%2.0f", fontSize];
        } else {
            string = [NSString stringWithFormat:@"%.1f", fontSize];
        }
        label.textAlignment = NSTextAlignmentCenter;
        label.frame = CGRectMake(0, 0, kWindowSize.width * 0.4, kRowHeight);

    } else if (component == FontColorComponent) {
        if (self.colorList.count <= row) {
            return nil;
        }
        label.backgroundColor = self.colorList[row];
        label.frame = CGRectMake(0, 0, kWindowSize.width * 0.2, kRowHeight);
    }
    label.text = string;

    return label;
}

#pragma mark - UIPickerView delegate methods
// Do something with the selected row.
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // cache current font and color selected
    if (component == FontComponent) {
        if ([self.delegate respondsToSelector:@selector(pickerDidSelectFont:)])
            [self.delegate pickerDidSelectFont:[self selectedFontName]];
        _fontName = [self selectedFontName];
    } else if (component == FontSizeComponent) {
        if ([self.delegate respondsToSelector:@selector(pickerDidSelectFontSize:)])
            [self.delegate pickerDidSelectFontSize:[self selectedFontSize]];

        _fontSize = [self selectedFontSize];

    } else if (component == FontColorComponent) {
        if ([self.delegate respondsToSelector:@selector(pickerDidSelectFontColor:)])
            [self.delegate pickerDidSelectFontColor:[self selectedColor]];

        _color = [self selectedColor];
    }

    if ([self.delegate respondsToSelector:@selector(pickerDidSelectFont:withSize:color:)])
        [self.delegate pickerDidSelectFont:_fontName withSize:_fontSize color:_color];
}

#pragma mark - Font name component data
- (NSArray *)fontList
{
    if (_fontList.count) {
        return _fontList;
    }

    // list all font names in system
    NSArray *fonts = [[NSMutableArray alloc] init];
    NSArray *families = [UIFont familyNames];
    for (NSString *familyName in families) {
        NSArray *names = [UIFont fontNamesForFamilyName:familyName];

        fonts = [fonts arrayByAddingObjectsFromArray:names];
    }

    // add current font name when not found in list
    if (_fontName) {
        _fontList = fonts;
        NSInteger index = [self indexForFontName:_fontName];
        if (index == NSNotFound) {
            NSArray *temp = @[ _fontName ];
            fonts = [temp arrayByAddingObjectsFromArray:fonts];
        }
    }

    // sort by font name
    fonts = [fonts sortedArrayUsingComparator:^NSComparisonResult(NSString *str1, NSString *str2) {
      return [str1 localizedCaseInsensitiveCompare:str2];
    }];

    _fontList = fonts;
    return _fontList;
}

- (NSInteger)indexForFontName:(NSString *)fontName
{
    for (int i = 0; i < self.fontList.count; i++) {
        NSString *testName = self.fontList[i];
        if ([fontName isEqualToString:testName]) {
            return i;
        }
    }
    if ([fontName hasPrefix:@"."]) {
        fontName = [fontName substringFromIndex:1];
        return [self indexForFontName:fontName];
    }
    return NSNotFound;
}

#pragma mark - Font size component data
- (NSArray *)sizeList
{
    //    if (self.sizeHidden) {
    //        return @[];
    //    }
    if (_sizeList.count) {
        return _sizeList;
    }

    if (!(self.minFontSize > 0)) {
        self.minFontSize = KPFontPickerMinFontSizeDefault;
    }
    if (!(self.maxFontSize > 0)) {
        self.maxFontSize = KPFontPickerMaxFontSizeDefault;
    }
    if (!(self.stepFontSize > 0)) {
        self.stepFontSize = KpFontPickerStepFontSizeDefault;
    }

    NSMutableArray *sizes = [[NSMutableArray alloc] init];
    for (CGFloat fsize = self.minFontSize; fsize <= self.maxFontSize; fsize += self.stepFontSize) {
        NSNumber *nsize = [NSNumber numberWithFloat:fsize];
        [sizes addObject:nsize];
    }

    // add current font size when not found in list
    if (_fontSize) {
        _sizeList = sizes;
        NSInteger index = [self indexForFontSize:_fontSize];
        if (index == NSNotFound) {
            NSNumber *nsize = [NSNumber numberWithFloat:_fontSize];
            [sizes addObject:nsize];

            // sort by font name
            NSArray *temp = [sizes sortedArrayUsingComparator:^NSComparisonResult(NSNumber *size1, NSNumber *size2) {
              return [size1 compare:size2];
            }];
            sizes = [NSMutableArray arrayWithArray:temp];
        }
    }

    _sizeList = [NSArray arrayWithArray:sizes];
    return _sizeList;
}

- (NSInteger)indexForFontSize:(CGFloat)pointSize
{
    for (int i = 0; i < self.sizeList.count; i++) {
        NSNumber *fontNumber = self.sizeList[i];
        CGFloat fontSize = fontNumber.floatValue;
        if (fontSize == pointSize) {
            return i;
        }
    }
    return NSNotFound;
}

- (CGFloat)selectedFontSize
{
    CGFloat fontSize = self.minFontSize;

    NSInteger sizeIndex = [_pickerView selectedRowInComponent:1];
    if (sizeIndex > -1) {
        NSNumber *sizeNumber = self.sizeList[sizeIndex];
        fontSize = sizeNumber.floatValue;
    }

    return fontSize;
}

- (NSString *)selectedFontName
{
    NSString *fontName;
    NSInteger fontIndex = [_pickerView selectedRowInComponent:0];
    if (fontIndex > -1) {
        fontName = self.fontList[fontIndex];
    }
    return fontName;
}

#pragma mark - Font color component data
- (NSArray *)colorList
{
    if (_colorList.count) {
        return _colorList;
    }
    NSMutableArray *colors = [[NSMutableArray alloc] init];

    // default variants
    if (!(self.colorVariants < 0)) {
        self.colorVariants = KPFontPickerColorVariantsDefault;
    }
    if (!(self.grayVariants < 0)) {
        self.grayVariants = KPFontPickerGrayVariantsDefault;
    }

    // add color variants
    if (self.colorVariants > 0) {
        int ilevel = (int)ceil(pow((double)self.colorVariants, 1.0 / 3.0));
        CGFloat flevel = (float)ilevel - 1;
        for (int r = 0; r < ilevel; r++) {
            for (int g = 0; g < ilevel; g++) {
                for (int b = ilevel - 1; b >= 0; b--) {
                    if (colors.count >= self.colorVariants)
                        break;
                    if (self.grayVariants > 0 && r == g && g == b)
                        continue;
                    UIColor *color = [UIColor colorWithRed:r / flevel green:g / flevel blue:b / flevel alpha:1.0];
                    [colors addObject:color];
                }
            }
        }
    }

    // add grayscale variants
    if (self.grayVariants > 0) {
        NSInteger ilevel = self.grayVariants;
        CGFloat flevel = (float)ilevel - 1;
        for (int w = 0; w < ilevel; w++) {
            UIColor *color = [UIColor colorWithRed:w / flevel green:w / flevel blue:w / flevel alpha:1.0];
            [colors addObject:color];
        }
    }

    // add current color when not found in list
    if (_color) {
        _colorList = colors;
        NSInteger index = [self indexForColor:_color];
        if (index == NSNotFound) {
            NSArray *temp = @[ _color ];
            temp = [temp arrayByAddingObjectsFromArray:colors];
            colors = [NSMutableArray arrayWithArray:temp];
        }
    }

    // sort by H/B/S
    NSArray *sorted = [colors sortedArrayUsingComparator:^NSComparisonResult(UIColor *col1, UIColor *col2) {
      CGFloat h1, s1, b1, a1;
      [col1 getHue:&h1 saturation:&s1 brightness:&b1 alpha:&a1];

      CGFloat h2, s2, b2, a2;
      [col2 getHue:&h2 saturation:&s2 brightness:&b2 alpha:&a2];

      if (h1 > h2) {
          return NSOrderedAscending;
      } else if (h1 < h2) {
          return NSOrderedDescending;
      }
      if (b1 > b2) {
          return NSOrderedAscending;
      } else if (b1 < b2) {
          return NSOrderedDescending;
      }
      if (s1 > s2) {
          return NSOrderedAscending;
      } else if (s1 < s2) {
          return NSOrderedDescending;
      }
      return NSOrderedSame;
    }];

    _colorList = sorted;
    return _colorList;
}

- (NSInteger)indexForColor:(UIColor *)color
{
    if (!color)
        return NSNotFound;
    CGFloat r1, g1, b1, a1;
    [color getRed:&r1 green:&g1 blue:&b1 alpha:&a1];
    r1 = round(r1 * 255);
    g1 = round(g1 * 255);
    b1 = round(b1 * 255);

    for (int i = 0; i < self.colorList.count; i++) {
        UIColor *testColor = self.colorList[i];
        if (!testColor)
            return NSNotFound;
        CGFloat r2, g2, b2, a2;
        [testColor getRed:&r2 green:&g2 blue:&b2 alpha:&a2];
        r2 = round(r2 * 255);
        g2 = round(g2 * 255);
        b2 = round(b2 * 255);

        // test RGB color code as 0-255 integer number but not float number
        if (r1 == r2 && g1 == g2 && b1 == b2) {
            return i;
        }
    }
    return NSNotFound;
}

- (UIColor *)selectedColor
{
    NSInteger colorIndex;
    UIColor *color;
    colorIndex = [_pickerView selectedRowInComponent:2];
    if (colorIndex > -1) {
        color = self.colorList[colorIndex];
    }
    return color;
}

@end
