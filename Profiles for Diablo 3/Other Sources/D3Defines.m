//
//  D3Defines.m
//  Profiles for Diablo 3
//
//  Created by Ryan Nystrom on 8/15/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

#import "D3Defines.h"

#pragma mark - URL

NSString * const kD3BaseURL = @"http://us.battle.net/api/d3";
NSString * const kD3APIProfileParam = @"profile";
NSString * const kD3APIHeroParam = @"hero";


#pragma mark - Notifications

NSString * const kD3CareerNotification = @"com.nystromproductions.profiles.career";
NSString * const kD3LastHeroPlayedNotification = @"com.nystromproductions.profiles.last-hero-played";
NSString * const kD3DoorsAnimatedOffScreenNotification = @"com.nystromproductions.profiles.doors-offscreen";


#pragma mark - Animations

CGFloat const kD3SystemAnimationDuration = 0.25f;
CGFloat const kD3RuneSpinDuration = 1.0f;
CGFloat const kD3DoorsOpenDuration = 1.0f;


#pragma mark - Sizes

CGFloat const kD3AccountTextFieldWidth = 176.0f;
CGFloat const kD3AccountTextFieldHeight = 44.0f;
CGFloat const kD3AccountButtonWidth = 132.0f;
CGFloat const kD3AccountButtonHeight = kD3AccountTextFieldHeight;