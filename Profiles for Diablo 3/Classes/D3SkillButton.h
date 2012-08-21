//
//  D3SkillButton.h
//  Profiles for Diablo 3
//
//  Created by Ryan Nystrom on 8/18/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface D3SkillButton : UIButton

+ (D3SkillButton*)buttonWithSkill:(D3Skill*)skill;

@property (weak, nonatomic) D3Skill *skill;

- (void)setupView;

@end
