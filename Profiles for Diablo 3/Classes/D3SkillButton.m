//
//  D3SkillButton.m
//  Profiles for Diablo 3
//
//  Created by Ryan Nystrom on 8/18/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

#import "D3SkillButton.h"
#import "D3Theme.h"

@interface D3SkillButton ()

@property (strong) UILabel *nameLabel;
@property (strong) UILabel *runeLabel;

@end

@implementation D3SkillButton

#pragma mark - UIButton

+ (D3SkillButton*)buttonWithSkill:(D3Skill*)skill {
    // TODO: add placeholder image
    D3SkillButton *button = [self buttonWithType:UIButtonTypeCustom];
    button.skill = skill;
    CGFloat buttonHeight = kD3Grid2;
    CGFloat buttonWidth = kD3Grid2;
    button.frame = CGRectMake(0,0,buttonWidth,buttonHeight);
    return button;
}


#pragma mark - Helpers

- (void)setupView {
    if (self.skill.name) {
        self.nameLabel = [D3Theme labelWithFrame:CGRectMake(0, 0, kD3Grid1 * 6.0f, 0) font:[D3Theme systemSmallFontWithBold:NO] text:@"Placeholder"];
        self.nameLabel.text = self.skill.name;
        self.nameLabel.numberOfLines = 1;
        self.nameLabel.adjustsFontSizeToFitWidth = YES;
        [self.nameLabel autoHeight];
        
        self.nameLabel.center = self.center;
        self.nameLabel.top = self.bottom + 5.0f;
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        
        if (self.skill.isActive) {
            self.runeLabel = [D3Theme labelWithFrame:CGRectMake(0, 0, kD3Grid1 * 6.0f, 0) font:[D3Theme systemSmallFontWithBold:NO] text:@"Placeholder"];
            self.runeLabel.text = self.skill.rune.name;
            self.runeLabel.textColor = [D3Theme redItemColor];
            self.runeLabel.numberOfLines = 1;
            self.runeLabel.adjustsFontSizeToFitWidth = YES;
            [self.runeLabel autoHeight];
            [self.superview addSubview:self.runeLabel];
            
            self.runeLabel.center = self.center;
            self.runeLabel.top = self.nameLabel.bottom;
            self.runeLabel.textAlignment = NSTextAlignmentCenter;
        }
        
        [self.superview addSubview:self.nameLabel];
    }
}


@end