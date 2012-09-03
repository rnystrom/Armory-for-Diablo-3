//
//  D3StatsViewController.m
//  Profiles for Diablo 3
//
//  Created by Ryan Nystrom on 8/19/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

#import "D3StatsViewController.h"

@interface D3StatsViewController ()

@property (strong, nonatomic) UIScrollView *scrollView;

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
    
    self.backgroundImage = [UIImage imageNamed:@"dark-bg"];
    
    self.titleLabel = [D3Theme labelWithFrame:CGRectMake(kD3Grid1, kD3TopPadding + 10.0f, self.view.width - 2.0f * kD3Grid1, 0) font:[D3Theme exocetLargeWithBold:NO] text:@"Stats"];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.text = @"STATS";
    [self.view addSubview:self.titleLabel];
    
    CGFloat viewHeight = [UIApplication currentSize].height;
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(kD3Grid1, kD3Grid2, self.view.width - 2.0f * kD3Grid1, viewHeight - 2.0f * kD3Grid1)];
    self.scrollView.contentSize = self.scrollView.frame.size;
    self.scrollView.bounces = YES;
    self.scrollView.alwaysBounceHorizontal = NO;
    self.scrollView.alwaysBounceVertical = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    if (self.hero) {
        [self setupView];
    }
}


#pragma mark - Helpers

- (void)setupView {
    CGFloat runningY = kD3Grid1 / 2.0f;
    CGFloat spacer = kD3Grid1 / 2.0f;
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
    runningY += spacer;
    
    runningY = [self addStatsGroupWithTitle:@"Offense" names:@[
                @"Damage:",
                @"Damage Incresase:",
                @"Crit Hit Chance:",
                @"Thorns:",
                ] values:@[
                [NSString stringWithFormat:@"%.0f",self.hero.damage],
                [NSString stringWithFormat:@"%.0f%%",self.hero.damageIncrease],
                [NSString stringWithFormat:@"%.0f%%",self.hero.critChance],
                [NSString stringWithFormat:@"%.0f",self.hero.thorns]
                ] atY:runningY];
    runningY += spacer;
    
    runningY = [self addStatsGroupWithTitle:@"Defense" names:@[
                @"Maximum Life:",
                @"Life on Hit:",
                @"Life per Kill:",
                @"Life Steal:",
                @"Armor:",
                @"Block Chance:",
                @"Block Amount:",
                @"Damage Reduction:",
                @"Arcane Resist:",
                @"Cold Resist:",
                @"Fire Resist:",
                @"Lightning Resist:",
                @"Poison Resist:",
                @"Physical Resist:",
                ] values:@[
                [NSString stringWithFormat:@"%i",self.hero.life],
                [NSString stringWithFormat:@"%.0f",self.hero.lifeOnHit],
                [NSString stringWithFormat:@"%.0f",self.hero.lifePerKill],
                [NSString stringWithFormat:@"%.0f",self.hero.lifeSteal],
                [NSString stringWithFormat:@"%i",self.hero.armor],
                [NSString stringWithFormat:@"%.0f%%",self.hero.blockChance],
                [NSString stringWithFormat:@"%i",self.hero.blockAmountMax],
                [NSString stringWithFormat:@"%.0f%%",self.hero.damageReduction],
                [NSString stringWithFormat:@"%i",self.hero.arcaneResist],
                [NSString stringWithFormat:@"%i",self.hero.coldResist],
                [NSString stringWithFormat:@"%i",self.hero.fireResist],
                [NSString stringWithFormat:@"%i",self.hero.lightningResist],
                [NSString stringWithFormat:@"%i",self.hero.poisonResist],
                [NSString stringWithFormat:@"%i",self.hero.physicalResist]
                ] atY:runningY];
    runningY += spacer;
    
    runningY = [self addStatsGroupWithTitle:@"Misc" names:@[
                @"Gold Find:",
                @"Magic Find:",
                ] values:@[
                [NSString stringWithFormat:@"%.0f%%",self.hero.goldFind * 100.0f],
                [NSString stringWithFormat:@"%.0f%%",self.hero.magicFind * 100.0f],
                ] atY:runningY];
    
    CGSize contentSize = self.scrollView.contentSize;
    contentSize.height = runningY;
    self.scrollView.contentSize = contentSize;
}

// returns last height
- (CGFloat)addStatsGroupWithTitle:(NSString*)title names:(NSArray*)names values:(NSArray*)values atY:(CGFloat)y {
    __block CGRect runningFrame = CGRectMake(kD3Grid1, y, self.scrollView.width - 2 * kD3Grid1, 0);
    CGFloat padding = kD3Grid1 / 4.0f;
    UILabel *textLabel = [D3Theme labelWithFrame:runningFrame font:[D3Theme exocetMediumWithBold:NO] text:title];
    textLabel.textAlignment = NSTextAlignmentCenter;
    [self.scrollView addSubview:textLabel];
    
    runningFrame.origin.y += textLabel.frame.size.height + padding;
    if ([names count] == [values count]) {
        [names enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[NSString class]]) {
                NSString *name = (NSString*)obj;
                NSString *value = values[idx];
                
                UILabel *nameLabel = [D3Theme labelWithFrame:runningFrame font:[D3Theme systemSmallFontWithBold:YES] text:name];
                nameLabel.textColor = [D3Theme redItemColor];
                [self.scrollView addSubview:nameLabel];
                
                UILabel *valueLabel = [D3Theme labelWithFrame:runningFrame font:[D3Theme systemSmallFontWithBold:NO] text:value];
                valueLabel.textAlignment = NSTextAlignmentRight;
                [self.scrollView addSubview:valueLabel];
                
                runningFrame.origin.y += nameLabel.frame.size.height + padding;
            }
        }];
    }
    return runningFrame.origin.y;
}


@end
