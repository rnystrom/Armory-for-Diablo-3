//
//  D3Theme.m
//  Profiles for Diablo 3
//
//  Created by Ryan Nystrom on 8/18/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

#import "D3Theme.h"
#import <QuartzCore/QuartzCore.h>

#pragma mark - Font Sizes

CGFloat const kD3TinyFontSize = 12.0f;
CGFloat const kD3SmallFontSize = 16.0f;
CGFloat const kD3MediumFontSize = 22.0f;
CGFloat const kD3LargeFontSize = 33.0f;
CGFloat const kD3TitleFontSize = 66.0f;

#pragma mark - Sizes

CGFloat const kD3Grid1 = 32.0f;
CGFloat const kD3Grid2 = kD3Grid1 * 2.0f;
CGFloat const kD3Grid3 = kD3Grid1 * 3.0f;
CGFloat const kD3Grid4 = kD3Grid1 * 4.0f;
CGFloat const kD3Grid5 = kD3Grid1 * 5.0f;
CGFloat const kD3AccountTextFieldWidth = 176.0f;
CGFloat const kD3AccountTextFieldHeight = 44.0f;
CGFloat const kD3AccountButtonWidth = 132.0f;
CGFloat const kD3AccountButtonHeight = kD3AccountTextFieldHeight;
CGFloat const kD3MenuWidth = kD3Grid4;
CGFloat const kD3MenuHeight = kD3Grid4;
CGFloat const kD3CardWidth = (1024.0f - kD3MenuWidth) / 2.0f;

#pragma mark - Animations

CGFloat const kD3SystemAnimationDuration = 0.25f;
CGFloat const kD3RuneSpinDuration = 1.0f;
CGFloat const kD3DoorsOpenDuration = 1.0f;

@implementation D3Theme

#pragma mark - Fonts

+ (UIFont*)exocetWithFontSize:(CGFloat)size bold:(BOOL)isBold {
    if (isBold) {
        [UIFont fontWithName:@"ExocetHeavy" size:size];
    }
    return [UIFont fontWithName:@"Exocet" size:size];
}


+ (UIFont*)exocetSmallWithBold:(BOOL)isBold {
    return [self exocetWithFontSize:kD3SmallFontSize bold:isBold];
}


+ (UIFont*)exocetMediumWithBold:(BOOL)isBold {
    return [self exocetWithFontSize:kD3MediumFontSize bold:isBold];
}


+ (UIFont*)exocetLargeWithBold:(BOOL)isBold {
    return [self exocetWithFontSize:kD3LargeFontSize bold:isBold];
}


+ (UIFont*)systemFontSize:(CGFloat)size serif:(BOOL)isSerif bold:(BOOL)isBold italic:(BOOL)isItalic{
    NSMutableString *mutFontName = nil;
    if (isSerif) {
        mutFontName = [NSMutableString stringWithString:@"TimesNewRomanPS"];
    }
    else {
        mutFontName = [NSMutableString stringWithString:@"Arial"];
    }
    if (isBold || isItalic) {
        [mutFontName appendFormat:@"-"];
    }
    if (isBold) {
        [mutFontName appendFormat:@"Bold"];
    }
    if (isItalic) {
        [mutFontName appendFormat:@"Italic"];
    }
    [mutFontName appendFormat:@"MT"];
    return [UIFont fontWithName:mutFontName size:size];
}


+ (UIFont*)systemFontWithSize:(CGFloat)size bold:(BOOL)isBold {
    return [self systemFontSize:size serif:NO bold:isBold italic:NO];
}


+ (UIFont*)systemSmallFontWithBold:(BOOL)isBold {
    return [self systemFontWithSize:kD3SmallFontSize bold:isBold];
}


+ (UIFont*)systemMediumFontWithBold:(BOOL)isBold {
    return [self systemFontWithSize:kD3MediumFontSize bold:isBold];
}


+ (UIFont*)systemLargeFontWithBold:(BOOL)isBold {
    return [self systemFontWithSize:kD3LargeFontSize bold:isBold];
}


+ (UIFont*)titleFontWithSize:(CGFloat)size bold:(BOOL)isBold {
    return [self systemFontSize:size serif:YES bold:isBold italic:NO];
}


+ (UIFont*)titleSmallFontWithBold:(BOOL)isBold {
    return [self titleFontWithSize:kD3SmallFontSize bold:isBold];
}


+ (UIFont*)titleMediumFontWithBold:(BOOL)isBold {
    return [self titleFontWithSize:kD3MediumFontSize bold:isBold];
}


+ (UIFont*)titleLargeFontWithBold:(BOOL)isBold {
    return [self titleFontWithSize:kD3LargeFontSize bold:isBold];
}

#pragma mark - Colors

+ (UIColor*)backgroundColor {
    return [UIColor colorWithRed:36.0f / 255.0f green:36.0f / 255.0f blue:37.0f / 255.0f alpha:1.0f];
}


+ (UIColor*)midgroundColor {
    return [UIColor colorWithRed:61.0f / 255.0f green:63.0f / 255.0f blue:65.0f / 255.0f alpha:1.0f];
}


+ (UIColor*)foregroundColor {
    return [UIColor colorWithRed:79.0f / 255.0f green:81.0f / 255.0f blue:83.0f / 255.0f alpha:1.0f];
}


+ (UIColor*)borderColor {
//    return [UIColor colorWithRed:79.0f / 255.0f green:81.0f / 255.0f blue:83.0f / 255.0f alpha:1.0f];
    return [UIColor blackColor];
}


+ (UIColor*)textColor {
    return [UIColor colorWithRed:250.0f / 255.0f green:250.0f / 255.0f blue:251.0f / 255.0f alpha:1.0f];
}


+ (UIColor*)yellowItemColor {
    return [UIColor colorWithRed:166.0f / 255.0f green:162.0f / 255.0f blue:48.0f / 255.0f alpha:1.0f];
}


+ (UIColor*)blueItemColor {
    return [UIColor colorWithRed:68.0f / 255.0f green:118.0f / 255.0f blue:136.0f / 255.0f alpha:1.0f];
}


+ (UIColor*)orangeItemColor {
    return [UIColor colorWithRed:211.0f / 255.0f green:168.0f / 255.0f blue:85.0f / 255.0f alpha:1.0f];
}


+ (UIColor*)greenItemColor {
    return [UIColor colorWithRed:119.0f / 255.0f green:166.0f / 255.0f blue:64.0f / 255.0f alpha:1.0f];
}


+ (UIColor*)whiteItemColor {
    return [UIColor colorWithRed:238.0f / 255.0f green:227.0f / 255.0f blue:217.0f / 255.0f alpha:1.0f];
}


+ (UIColor*)redItemColor {
    return [UIColor colorWithRed:136.0f / 255.0f green:69.0f / 255.0f blue:69.0f / 255.0f alpha:1.0f];
}


#pragma mark - Labels

+ (UILabel*)labelWithFrame:(CGRect)frame font:(UIFont*)font text:(NSString *)text {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = font;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [D3Theme textColor];
    label.text = text;
    label.shadowColor = [UIColor blackColor];
    label.shadowOffset = CGSizeMake(0, 1.0f);
    [label autoHeight];
    return label;
}


@end
