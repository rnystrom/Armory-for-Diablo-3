//
//  D3HeroCell.m
//  Profiles for Diablo 3
//
//  Created by Ryan Nystrom on 8/15/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

#import "D3HeroCell.h"
#import <QuartzCore/QuartzCore.h>

CGFloat const kFadedAlpha = 0.25f;

@interface D3HeroCell ()

@property (strong, nonatomic) UIImageView *iconView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *subtitleLabel;

@end

@implementation D3HeroCell

@synthesize selected = _selected;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    // override, do not do blue background
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    // override, do not do blue background
    _selected = selected;
    if (selected) {
        self.contentView.alpha = 1.0f;
    }
    else {
        self.contentView.alpha = kFadedAlpha;
    }
}


#pragma mark - Helpers

- (void)setupView {
    CGRect frame = self.contentView.frame;
    UIImage *classImage = [UIImage imageNamed:self.hero.className];
    self.iconView = [[UIImageView alloc] initWithImage:classImage];
    
    CGFloat iconScale = frame.size.height / self.iconView.frame.size.height;
    CGFloat resizeScale = 0.5f;
    CGFloat iconHeight = iconScale * self.iconView.frame.size.height * resizeScale;
    CGFloat iconWidth = iconScale * self.iconView.frame.size.width * resizeScale;
    CGFloat itemPadding = 0.0f;
    
    self.iconView.frame = CGRectMake(0, 0, iconWidth, iconHeight);
    self.iconView.center = CGPointMake(frame.size.width / 2.0f, frame.size.height / 2.0f - kD3Grid1 / 2.0f);
    [self.contentView addSubview:self.iconView];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 0)];
    self.nameLabel.text = [self.hero.name uppercaseString];
    self.nameLabel.font = [D3Theme systemFontSize:kD3TinyFontSize serif:NO bold:YES italic:NO];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.backgroundColor = [UIColor clearColor];
    [self.nameLabel autoHeight];
    self.nameLabel.center = CGPointMake(frame.size.width / 2.0f, self.iconView.frame.size.height + self.iconView.frame.origin.y + self.nameLabel.frame.size.height / 2.0f + itemPadding);
    [self.contentView addSubview:self.nameLabel];
    
    self.subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 0)];
    self.subtitleLabel.text = [NSString stringWithFormat:@"%i %@",self.hero.level, [self.hero.className capitalizedString]];
    self.subtitleLabel.font = [D3Theme systemFontSize:kD3TinyFontSize serif:NO bold:NO italic:NO];
    self.subtitleLabel.textAlignment = NSTextAlignmentCenter;
    self.subtitleLabel.backgroundColor = [UIColor clearColor];
    [self.subtitleLabel autoHeight];
    self.subtitleLabel.center = CGPointMake(frame.size.width / 2.0f, self.nameLabel.frame.size.height + self.nameLabel.frame.origin.y + self.subtitleLabel.frame.size.height / 2.0f + itemPadding);
    [self.contentView addSubview:self.subtitleLabel];
    
    self.contentView.alpha = kFadedAlpha;
}


#pragma mark - Setters

- (void)setHero:(D3Hero *)hero {
    _hero = hero;
    self.cellType = D3HeroCellTypeHero;
    
    if (! hero.isFullyLoaded) {
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.contentView addSubview:activityIndicator];
        [activityIndicator startAnimating];
        
        [hero finishLoadingWithSuccess:^(D3Hero *hero) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [activityIndicator stopAnimating];
                [activityIndicator removeFromSuperview];
                [self setupView];
            });
        } failure:^(NSError *error) {
            
        }];
    }
    else {
        [self setupView];
    }
}


- (void)setCellType:(enum D3HeroCellType)cellType {
    _cellType = cellType;
    if (cellType == D3HeroCellTypeLogout) {
        self.textLabel.text = @"Logout";
    }
}


@end
