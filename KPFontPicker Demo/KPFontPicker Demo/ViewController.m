//
//  ViewController.m
//  KPFontPicker Demo
//
//  Created by Kirill Pahnev on 19/05/15.
//  Copyright (c) 2015 Kirill Pahnev. All rights reserved.
//

#import "ViewController.h"
#import "KPFontPicker.h"

@interface ViewController () <KPFontPickerDelegate, UITextFieldDelegate>
@property(weak, nonatomic) IBOutlet UITextField *textField;
@property(strong, nonatomic) KPFontPicker *picker;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Custom list of font. By default it loads all the fonts in the system.
    NSArray *fonts = @[ @"AmericanTypewriter", @"Baskerville", @"Copperplate", @"Didot", @"EuphemiaUCAS", @"Futura-Medium", @"GillSans", @"Helvetica", @"Marion-Regular", @"Optima-Regular", @"Palatino-Roman", @"TimesNewRoman", @"Verdana" ];

    self.picker = [[KPFontPicker alloc] initWithFonts:fonts];

    self.picker.delegate = self;
    self.textField.delegate = self;
    self.textField.inputAccessoryView = [self createToolbar];
}

#pragma mark - KPFontpicker Delegate
- (void)pickerDidSelectFont:(NSString *)font withSize:(CGFloat)fontSize color:(UIColor *)fontColor
{
    self.textField.font = [UIFont fontWithName:font size:fontSize];
    self.textField.textColor = fontColor;
}

// Optional delegate
- (void)pickerDidSelectFontColor:(UIColor *)fontColor
{
    NSLog(@"Color selected %@", fontColor);
}

#pragma mark - Toolbar
- (UIToolbar *)createToolbar
{
    UIToolbar *keyboardDoneButtonView = [[UIToolbar alloc] init];
    keyboardDoneButtonView.barTintColor = [UIColor darkGrayColor];
    keyboardDoneButtonView.tintColor = [UIColor whiteColor];
    [keyboardDoneButtonView sizeToFit];

    UIBarButtonItem *keyboardButton = [[UIBarButtonItem alloc] initWithTitle:@"Keyboard"
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(keyboardClicked:)];

    UIBarButtonItem *fontButton = [[UIBarButtonItem alloc] initWithTitle:@"Font"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(pickerClicked:)];

    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                target:self
                                                                                action:@selector(doneClicked:)];

    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:keyboardButton, fontButton, flex, doneButton, nil]];

    return keyboardDoneButtonView;
}

#pragma mark - Toolbar actions
- (IBAction)keyboardClicked:(id)sender
{
    if ([self.textField isFirstResponder]) {
        self.textField.inputView = nil;

        [self.textField reloadInputViews];
    }
}

- (IBAction)pickerClicked:(id)sender
{
    if ([self.textField isFirstResponder]) {
        self.textField.inputView = self.picker;
        [self.textField reloadInputViews];
    }
}

- (IBAction)doneClicked:(id)sender
{
    if ([self.textField isFirstResponder]) {
        self.textField.inputView = nil;

        [self.textField resignFirstResponder];
    }
}

@end
