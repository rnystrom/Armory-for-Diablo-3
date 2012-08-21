//
//  D3Theme.h
//  Profiles for Diablo 3
//
//  Created by Ryan Nystrom on 8/18/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

extern CGFloat const kD3SmallFontSize;
extern CGFloat const kD3MediumFontSize;
extern CGFloat const kD3LargeFontSize;
extern CGFloat const kD3TitleFontSize;

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

@end
