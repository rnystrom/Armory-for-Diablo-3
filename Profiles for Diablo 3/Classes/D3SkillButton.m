//
//  D3SkillButton.m
//  Profiles for Diablo 3
//
//  Created by Ryan Nystrom on 8/18/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

#import "D3SkillButton.h"

@implementation D3SkillButton

#pragma mark - UIButton

+ (D3SkillButton*)buttonWithSkill:(D3Skill*)skill {
    // TODO: add placeholder image
    D3SkillButton *button = [self buttonWithType:UIButtonTypeCustom];
    button.skill = skill;
    return button;
}


#pragma mark - Helpers

- (void)setupView {
    if (!self.skill.name) {
        self.backgroundColor = [UIColor blackColor];
    }
    else {
        CGFloat labelPadding = kD3Grid1 / 4.0f;
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kD3Grid3, 0)];
        titleLabel.text = self.skill.name;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [D3Theme systemSmallFontWithBold:NO];
        titleLabel.backgroundColor = [UIColor clearColor];
        [titleLabel sizeToFit];
        [titleLabel autoHeight];
        
        CGPoint center = self.center;
        center.y += self.frame.size.height / 2.0f + labelPadding;
        titleLabel.center = center;
        
        [self.superview addSubview:titleLabel];
    }
}

@end