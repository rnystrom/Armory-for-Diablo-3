//
//  D3Item+OverrideColors.m
//  Profiles for Diablo 3
//
//  Created by Ryan Nystrom on 8/22/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

#import "D3Item+OverrideColors.h"
#import "D3Theme.h"

@implementation D3Item (OverrideColors)

// Override to use our theme's colors
// Normally throws a warning but as D3Item is a custom class
// We aren't worried about accessing the super method
- (UIColor*)displayColorFromDictionary {
    if (self.colorString) {
        return @{
        @"white"    : [D3Theme whiteItemColor],
        @"blue"     : [D3Theme blueItemColor],
        @"yellow"   : [D3Theme yellowItemColor],
        @"orange"   : [D3Theme orangeItemColor],
        @"green"    : [D3Theme greenItemColor],
        @"null"     : [D3Theme redItemColor]
        }[self.colorString];
    }
    return [D3Theme redItemColor];
}


@end
