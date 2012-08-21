//
//  D3Theme.m
//  Profiles for Diablo 3
//
//  Created by Ryan Nystrom on 8/18/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

#import "D3Theme.h"

CGFloat const kD3SmallFontSize = 16.0f;
CGFloat const kD3MediumFontSize = 22.0f;
CGFloat const kD3LargeFontSize = 33.0f;
CGFloat const kD3TitleFontSize = 66.0f;

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

@end
