//
//  D3Theme.m
//  Profiles for Diablo 3
//
//  Created by Ryan Nystrom on 8/18/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

#import "D3Theme.h"

#pragma mark - Sizes

CGFloat const kD3Grid1 = 32.0f;
CGFloat const kD3Grid2 = kD3Grid1 * 2.0f;
CGFloat const kD3Grid3 = kD3Grid1 * 3.0f;
CGFloat const kD3Grid4 = kD3Grid1 * 4.0f;
CGFloat const kD3Grid5 = kD3Grid1 * 5.0f;
CGFloat const kD3AccountTextFieldWidth  = kD3Grid3 * 2;
CGFloat const kD3AccountTextFieldHeight = 44.0f;
CGFloat const kD3AccountButtonWidth     = 132.0f;
CGFloat const kD3AccountButtonHeight    = kD3AccountTextFieldHeight;
CGFloat const kD3MenuWidth  = kD3Grid4;
CGFloat const kD3MenuHeight = kD3Grid4;
CGFloat const kD3CardWidth  = (1024.0f - kD3MenuWidth) / 2.0f;
CGFloat const kD3TopPadding = 4.0;

#pragma mark - Animations

CGFloat const kD3SystemAnimationDuration    = 0.25f;
CGFloat const kD3RuneSpinDuration           = 1.0f;
CGFloat const kD3DoorsOpenDuration          = 1.0f;

#pragma mark - Font Sizes

CGFloat const kD3TinyFontSize   = kD3Grid1 * 0.375f;
CGFloat const kD3SmallFontSize  = kD3Grid1 * 0.5f;
CGFloat const kD3MediumFontSize = kD3Grid1 * 0.7f;
CGFloat const kD3LargeFontSize  = kD3Grid1;
CGFloat const kD3TitleFontSize  = kD3Grid1 * 2.0f;

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
    return [UIColor blackColor];
}


+ (UIColor*)textColor {
    return [UIColor colorWithRed:250.0f / 255.0f green:250.0f / 255.0f blue:251.0f / 255.0f alpha:1.0f];
}


+ (UIColor*)yellowItemColor {
    return [UIColor colorWithRed:230.0f / 255.0f green:235.0f / 255.0f blue:78.0f / 255.0f alpha:1.0f];
}


+ (UIColor*)blueItemColor {
    return [UIColor colorWithRed:78.0f / 255.0f green:156.0f / 255.0f blue:235.0f / 255.0f alpha:1.0f];
}


+ (UIColor*)orangeItemColor {
    return [UIColor colorWithRed:211.0f / 255.0f green:168.0f / 255.0f blue:85.0f / 255.0f alpha:1.0f];
}


+ (UIColor*)greenItemColor {
    return [UIColor colorWithRed:125.0f / 255.0f green:173.0f / 255.0f blue:68.0f / 255.0f alpha:1.0f];
}


+ (UIColor*)whiteItemColor {
    return [UIColor colorWithRed:238.0f / 255.0f green:227.0f / 255.0f blue:217.0f / 255.0f alpha:1.0f];
}


+ (UIColor*)redItemColor {
    return [UIColor colorWithRed:200.0f / 255.0f green:92.0f / 255.0f blue:92.0f / 255.0f alpha:1.0f];
}


+ (UIColor*)glowColor {
    return [self blueItemColor];
}


#pragma mark - Labels

+ (UILabel*)labelWithFrame:(CGRect)frame font:(UIFont*)font text:(NSString *)text {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = font;
    label.numberOfLines = 0;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [D3Theme textColor];
    label.text = text;
    label.shadowColor = [UIColor blackColor];
    label.shadowOffset = CGSizeMake(0, 1.0f);
    [label autoHeight];
    return label;
}


#pragma mark - UIImages

+ (UIImage*)cappedItemImage {
    return [[UIImage imageNamed:@"item-overlay"] resizableImageWithCapInsets:UIEdgeInsetsMake(15.0f, 14.0f, 15.0f, 12.0f)];
}


+ (UIImage*)cappedItemHighlightedImage {
    return [[UIImage imageNamed:@"item-overlay-highlighted"] resizableImageWithCapInsets:UIEdgeInsetsMake(15.0f, 14.0f, 15.0f, 12.0f)];
}


+ (UIImage*)cappedItemSelectedImage {
    return [[UIImage imageNamed:@"item-overlay-selected"] resizableImageWithCapInsets:UIEdgeInsetsMake(15.0f, 14.0f, 15.0f, 12.0f)];
}


+ (UIImage*)cappedButtonImage {
    return [[UIImage imageNamed:@"item-overlay-button"] resizableImageWithCapInsets:UIEdgeInsetsMake(15.0f, 14.0f, 15.0f, 12.0f)];
}


+ (CGPoint)cappedItemImageOffset {
    return CGPointMake(8.0f, 8.0f);
}


+ (UIImage*)cappedCardImage {
    return [[UIImage imageNamed:@"cardblock"] resizableImageWithCapInsets:UIEdgeInsetsMake(14.0f, 14.0f, 14.0f, 14.0f)];
}

+ (UIImage*)cappedTextboxImage {
    return [[UIImage imageNamed:@"textbox"] resizableImageWithCapInsets:UIEdgeInsetsMake(10.0f, 10.0f, 11.0f, 10.0f)];
}


+ (UIImage*)cappedDiabloButtonImage {
    return [[UIImage imageNamed:@"button"] resizableImageWithCapInsets:UIEdgeInsetsMake(13.0f, 21.5f, 13.5f, 20.5f)];
}


@end
