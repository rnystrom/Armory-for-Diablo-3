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
@property (strong, nonatomic) UILabel *subtitleLabel;
@property (strong, nonatomic) UILabel *skillLabel;
@property (strong, nonatomic) UILabel *runeTitleLabel;
@property (strong, nonatomic) UILabel *runeLabel;

@property (strong, nonatomic) NSArray *labelsArray;

@end

@implementation D3SkillDetailViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel = [D3Theme labelWithFrame:CGRectMake(kD3Grid1, kD3TopPadding, self.view.width - 2.0f * kD3Grid1, 0) font:[D3Theme exocetLargeWithBold:NO] text:@"Placeholder"];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.titleLabel.numberOfLines = 1;
    [self.view addSubview:self.titleLabel];
    
//    self.subtitleLabel = [D3Theme labelWithFrame:CGRectMake(kD3Grid1, self.titleLabel.bottom, self.view.width - 2.0f * kD3Grid1, 0) font:[D3Theme systemSmallFontWithBold:NO] text:@"Placeholder"];
//    self.subtitleLabel.numberOfLines = 1;
//    self.subtitleLabel.textAlignment = NSTextAlignmentCenter;
//    self.subtitleLabel.adjustsFontSizeToFitWidth = YES;
//    [self.view addSubview:self.subtitleLabel];
    
    self.skillLabel = [D3Theme labelWithFrame:CGRectMake(kD3Grid1, self.titleLabel.bottom, self.view.width - 2.0f * kD3Grid1, 0) font:[D3Theme systemSmallFontWithBold:NO] text:@"Placeholder"];
    self.skillLabel.textColor = [UIColor blackColor];
    self.skillLabel.numberOfLines = 0;
    self.skillLabel.layer.shadowColor = [UIColor clearColor].CGColor;
    self.skillLabel.layer.shadowOpacity = 0;
    [self.view addSubview:self.skillLabel];
    
    if (self.skill.isActive) {
        self.runeTitleLabel = [D3Theme labelWithFrame:CGRectMake(kD3Grid1, 0, self.view.width - 2.0f * kD3Grid1, 0) font:[D3Theme exocetMediumWithBold:NO] text:@"Rune"];
        self.runeTitleLabel.textColor = [D3Theme greenItemColor];
        [self.view addSubview:self.runeTitleLabel];
        
        self.runeLabel = [D3Theme labelWithFrame:CGRectMake(kD3Grid1, 0, self.view.width - 2.0f * kD3Grid1, 0) font:[D3Theme systemSmallFontWithBold:NO] text:nil];
        [self.runeLabel setTextColor:[UIColor blackColor]];
        self.runeLabel.layer.shadowColor = [UIColor clearColor].CGColor;
        self.runeLabel.layer.shadowOpacity = 0;
        [self.runeLabel setNumberOfLines:0];
        [self.view addSubview:self.runeLabel];
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
    self.titleLabel.text = self.skill.name;
    
    self.skillLabel.top = kD3Grid3;
    self.skillLabel.text = self.skill.description;
    [self.skillLabel autoHeight];
    
    if (self.skill.isActive) {
//        self.subtitleLabel.text = self.skill.rune.name;
//        self.subtitleLabel.top = self.titleLabel.bottom;
        
        self.runeTitleLabel.top = self.skillLabel.bottom + kD3Grid1;
        self.runeTitleLabel.text = self.skill.rune.name;
        [self.runeTitleLabel autoHeight];
        
        self.runeLabel.text = self.skill.rune.description;
        [self.runeLabel autoHeight];
        self.runeLabel.top = self.runeTitleLabel.bottom + kD3Grid1 / 4.0f;
    }
}

@end
