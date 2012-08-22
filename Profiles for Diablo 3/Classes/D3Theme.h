//
//  D3Theme.h
//  Profiles for Diablo 3
//
//  Created by Ryan Nystrom on 8/18/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

extern CGFloat const kD3TinyFontSize;
extern CGFloat const kD3SmallFontSize;
extern CGFloat const kD3MediumFontSize;
extern CGFloat const kD3LargeFontSize;
extern CGFloat const kD3TitleFontSize;
extern CGFloat const kD3AccountTextFieldWidth;
extern CGFloat const kD3AccountTextFieldHeight;
extern CGFloat const kD3AccountButtonWidth;
extern CGFloat const kD3AccountButtonHeight;
extern CGFloat const kD3MenuWidth;
extern CGFloat const kD3MenuHeight;
extern CGFloat const kD3CardWidth;
extern CGFloat const kD3Grid1;
extern CGFloat const kD3Grid2;
extern CGFloat const kD3Grid3;
extern CGFloat const kD3Grid4;
extern CGFloat const kD3Grid5;
extern CGFloat const kD3SystemAnimationDuration;
extern CGFloat const kD3RuneSpinDuration;
extern CGFloat const kD3DoorsOpenDuration;

@interface D3Theme

+ (UIFont*)exocetWithFontSize:(CGFloat)size bold:(BOOL)isBold;
+ (UIFont*)exocetSmallWithBold:(BOOL)isBold;
+ (UIFont*)exocetMediumWithBold:(BOOL)isBold;
+ (UIFont*)exocetLargeWithBold:(BOOL)isBold;

+ (UIFont*)systemFontSize:(CGFloat)size serif:(BOOL)isSerif bold:(BOOL)isBold italic:(BOOL)isItalic;
+ (UIFont*)systemFontWithSize:(CGFloat)size bold:(BOOL)isBold;
+ (UIFont*)systemSmallFontWithBold:(BOOL)isBold;
+ (UIFont*)systemMediumFontWithBold:(BOOL)isBold;
+ (UIFont*)systemLargeFontWithBold:(BOOL)isBold;
+ (UIFont*)titleFontWithSize:(CGFloat)size bold:(BOOL)isBold;
+ (UIFont*)titleSmallFontWithBold:(BOOL)isBold;
+ (UIFont*)titleMediumFontWithBold:(BOOL)isBold;
+ (UIFont*)titleLargeFontWithBold:(BOOL)isBold;

+ (UIColor*)backgroundColor;
+ (UIColor*)midgroundColor;
+ (UIColor*)foregroundColor;
+ (UIColor*)borderColor;
+ (UIColor*)textColor;
+ (UIColor*)yellowItemColor;
+ (UIColor*)blueItemColor;
+ (UIColor*)orangeItemColor;
+ (UIColor*)greenItemColor;
+ (UIColor*)whiteItemColor;
+ (UIColor*)redItemColor;

+ (UILabel*)labelWithFrame:(CGRect)frame font:(UIFont*)font text:(NSString*)text;

@end
