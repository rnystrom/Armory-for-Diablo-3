//
//  UILabel+AutoSize.m
//  Profiles for Diablo 3
//
//  Created by Ryan Nystrom on 8/18/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

#import "UILabel+AutoSize.h"

@implementation UILabel (AutoSize)

- (void)autoHeight {
    CGRect frame = self.frame;
    CGSize maxSize = CGSizeMake(frame.size.width, 9999);
    CGSize expectedSize = [self.text sizeWithFont:self.font constrainedToSize:maxSize lineBreakMode:self.lineBreakMode];
    frame.size.height = expectedSize.height;
    [self setFrame:frame];
}

@end
