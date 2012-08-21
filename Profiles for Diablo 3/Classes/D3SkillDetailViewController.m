//
//  D3SkillDetailViewController.m
//  Profiles for Diablo 3
//
//  Created by Ryan Nystrom on 8/19/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

#import "D3SkillDetailViewController.h"

@interface D3SkillDetailViewController ()

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *skillLabel;
@property (strong, nonatomic) UILabel *runeLabel;

@property (strong, nonatomic) NSArray *labelsArray;

@end

@implementation D3SkillDetailViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kD3Grid1, kD3Grid1 / 4.0f, self.view.width - 2 * kD3Grid1, kD3LargeFontSize)];
    self.titleLabel.font = [D3Theme exocetLargeWithBold:NO];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:self.titleLabel];
    
    self.skillLabel = [[UILabel alloc] initWithFrame:CGRectMake(kD3Grid1, 0, self.view.width - 2 * kD3Grid1, 0)];
    [self.skillLabel setTextColor:[UIColor whiteColor]];
    [self.skillLabel setNumberOfLines:0];
    self.skillLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.skillLabel];
    
    if (self.skill.isActive) {
        self.runeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kD3Grid1, 0, self.view.width - 2 * kD3Grid1, 0)];
        [self.runeLabel setTextColor:[UIColor whiteColor]];
        [self.runeLabel setNumberOfLines:0];
        self.runeLabel.backgroundColor = [UIColor clearColor];
        [self.view addSubview:self.runeLabel];
        
        self.labelsArray = @[
        self.titleLabel,
        self.skillLabel,
        self.runeLabel
        ];
    }
    else {
        self.labelsArray = @[
        self.titleLabel,
        self.skillLabel
        ];
    }
    
    if (self.skill) {
        [self setupView];
    }
}


- (void)setSkill:(D3Skill *)skill {
    _skill = skill;
    [self setupView];
}


- (void)setupView {
    CGFloat padding = kD3Grid1 / 4.0f;
    
    self.titleLabel.text = self.skill.name;
    
    self.skillLabel.text = self.skill.description;
    [self.skillLabel autoHeight];
    CGRect skillFrame = self.skillLabel.frame;
    skillFrame.origin.y = self.titleLabel.frame.size.height + self.titleLabel.frame.origin.y + padding;
    self.skillLabel.frame = skillFrame;
    
    if (self.skill.isActive) {
        self.runeLabel.text = self.skill.rune.description;
        [self.runeLabel autoHeight];
        CGRect runeFrame = self.runeLabel.frame;
        runeFrame.origin.y = self.skillLabel.frame.size.height + self.skillLabel.frame.origin.y + padding;
        self.runeLabel.frame = runeFrame;
    }
}

@end
