//
//  D3TexturedView.m
//  Profiles for Diablo 3
//
//  Created by Ryan Nystrom on 8/21/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

#import "D3TexturedView.h"

@implementation D3TexturedView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *image = [UIImage imageNamed:@"texture"];
        self.backgroundColor = [UIColor colorWithPatternImage:image];
    }
    return self;
}

@end
