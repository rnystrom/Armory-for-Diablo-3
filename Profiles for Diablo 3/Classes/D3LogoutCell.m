//
//  D3LogoutCell.m
//  Profiles for Diablo 3
//
//  Created by Ryan Nystrom on 8/22/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

#import "D3LogoutCell.h"

@implementation D3LogoutCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        self.backgroundColor = [D3Theme backgroundColor];
    }
    else if (! self.selected) {
        self.backgroundColor = [D3Theme midgroundColor];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (selected) {
        self.backgroundColor = [D3Theme backgroundColor];
    }
    else if (! self.selected) {
        self.backgroundColor = [D3Theme midgroundColor];
    }}

@end
