//
//  D3Defines.h
//  Profiles for Diablo 3
//
//  Created by Ryan Nystrom on 8/15/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

// Always use dev mode on simulator
#if !TARGET_IPHONE_SIMULATOR && !TARGET_OS_MAC
    #define D3_PRODUCTION_MODE 1
#endif

// Comment to disable logging
#define D3_LOGGING_MODE 1

#define kAppDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])

extern NSString * const kD3BaseURL;
extern NSString * const kD3APIProfileParam;
extern NSString * const kD3APIHeroParam;

extern NSString * const kD3CareerNotification;
extern NSString * const kD3LastHeroPlayedNotification;
extern NSString * const kD3DoorsAnimatedOffScreenNotification;

extern CGFloat const kD3SystemAnimationDuration;
extern CGFloat const kD3RuneSpinDuration;
extern CGFloat const kD3DoorsOpenDuration;

extern CGFloat const kD3AccountTextFieldWidth;
extern CGFloat const kD3AccountTextFieldHeight;
extern CGFloat const kD3AccountButtonWidth;
extern CGFloat const kD3AccountButtonHeight;