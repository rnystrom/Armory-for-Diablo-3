//
//  D3StatsViewController.m
//  Profiles for Diablo 3
//
//  Created by Ryan Nystrom on 8/19/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

#import "D3StatsViewController.h"

@interface D3StatsViewController ()

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *strengthLabel;
@property (strong, nonatomic) UILabel *dexterityLabel;
@property (strong, nonatomic) UILabel *intelligenceLabel;
@property (strong, nonatomic) UILabel *vitalityLabel;
@property (strong, nonatomic) UILabel *damageLabel;
@property (strong, nonatomic) UILabel *damageIncreaseLabel;
@property (strong, nonatomic) UILabel *critHitLabel;
@property (strong, nonatomic) UILabel *maxLifeLabel;
@property (strong, nonatomic) UILabel *damageReductionLabel;
@property (strong, nonatomic) UILabel *arcaneResistLabel;
@property (strong, nonatomic) UILabel *coldResistLabel;
@property (strong, nonatomic) UILabel *fireResistLabel;
@property (strong, nonatomic) UILabel *lightningResistLabel;
@property (strong, nonatomic) UILabel *poisonResistLabel;
@property (strong, nonatomic) UILabel *armorLabel;

@end

@implementation D3StatsViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kD3Grid1, kD3Grid1 / 4.0f, self.view.width - 2 * kD3Grid1, kD3LargeFontSize)];
    self.titleLabel.font = [D3Theme exocetLargeWithBold:NO];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.titleLabel.text = @"STATS";
    [self.view addSubview:self.titleLabel];
    
    if (self.hero) {
        [self setupView];
    }
}


#pragma mark - Helpers

- (void)setupView {
    CGFloat runningY = self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + kD3Grid1;
    runningY = [self addStatsGroupWithTitle:@"Attributes" names:@[
                @"Strength:",
                @"Dexterity:",
                @"Intelligence:",
                @"Vitality:"
                ] values:@[
                [NSString stringWithFormat:@"%i",self.hero.strength],
                [NSString stringWithFormat:@"%i",self.hero.dexterity],
                [NSString stringWithFormat:@"%i",self.hero.intelligence],
                [NSString stringWithFormat:@"%i",self.hero.vitality]
                ] atY:runningY];
    runningY += kD3Grid1;
    
    runningY = [self addStatsGroupWithTitle:@"Offense" names:@[
                @"Damage:",
                @"Damage Incresase:",
                @"Crit Hit Chance:",
                ] values:@[
                [NSString stringWithFormat:@"%.0f",self.hero.damage],
                [NSString stringWithFormat:@"%.0f%%",self.hero.damageIncrease],
                [NSString stringWithFormat:@"%.0f%%",self.hero.critChance],
                ] atY:runningY];
    runningY += kD3Grid1;
    
    runningY = [self addStatsGroupWithTitle:@"Defense" names:@[
                @"Maximum Life:",
                @"Armor:",
                @"Damage Reduction:",
                @"Arcane Resist:",
                @"Cold Resist:",
                @"Fire Resist:",
                @"Lightning Resist:",
                @"Poison Resist:",
                ] values:@[
                [NSString stringWithFormat:@"%i",self.hero.life],
                [NSString stringWithFormat:@"%i",self.hero.armor],
                [NSString stringWithFormat:@"%.0f%%",self.hero.damageReduction],
                [NSString stringWithFormat:@"%i",self.hero.arcaneResist],
                [NSString stringWithFormat:@"%i",self.hero.coldResist],
                [NSString stringWithFormat:@"%i",self.hero.fireResist],
                [NSString stringWithFormat:@"%i",self.hero.lightningResist],
                [NSString stringWithFormat:@"%i",self.hero.poisonResist]
                ] atY:runningY];
}

// returns last height
- (CGFloat)addStatsGroupWithTitle:(NSString*)title names:(NSArray*)names values:(NSArray*)values atY:(CGFloat)y {
    __block CGRect runningFrame = CGRectMake(kD3Grid1, y, self.view.width - 2 * kD3Grid1, 0);
    CGFloat padding = kD3Grid1 / 4.0f;
    UILabel *textLabel = [[UILabel alloc] initWithFrame:runningFrame];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.text = title;
    textLabel.font = [D3Theme systemSmallFontWithBold:NO];
    textLabel.textColor = [UIColor whiteColor];
    [textLabel autoHeight];
    [self.view addSubview:textLabel];
    
    runningFrame.origin.y += textLabel.frame.size.height + padding;
    if ([names count] == [values count]) {
        [names enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[NSString class]]) {
                NSString *name = (NSString*)obj;
                NSString *value = values[idx];
                
                UILabel *nameLabel = [[UILabel alloc] initWithFrame:runningFrame];
                nameLabel.text = name;
                nameLabel.backgroundColor = [UIColor clearColor];
                nameLabel.font = [D3Theme systemSmallFontWithBold:NO];
                nameLabel.textColor = [UIColor whiteColor];
                [nameLabel autoHeight];
                [self.view addSubview:nameLabel];
                
                UILabel *valueLabel = [[UILabel alloc] initWithFrame:runningFrame];
                valueLabel.text = value;
                valueLabel.backgroundColor = [UIColor clearColor];
                valueLabel.font = [D3Theme systemSmallFontWithBold:NO];
                valueLabel.textColor = [UIColor whiteColor];
                valueLabel.textAlignment = NSTextAlignmentRight;
                [valueLabel autoHeight];
                [self.view addSubview:valueLabel];
                
                runningFrame.origin.y += nameLabel.frame.size.height + padding;
            }
        }];
    }
    return runningFrame.origin.y;
}


@end
