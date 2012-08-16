//
//  D3ItemButton.m
//  Profiles for Diablo 3
//
//  Created by Ryan Nystrom on 8/15/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

#import "D3ItemButton.h"

@interface D3ItemButton()

@end

@implementation D3ItemButton

#pragma mark - Setters

- (void)setItem:(D3Item *)item {
    _item = item;
    self.backgroundColor = item.displayColor;
}

@end
