//
//  D3HeroCell.m
//  Profiles for Diablo 3
//
//  Created by Ryan Nystrom on 8/15/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

#import "D3HeroCell.h"
#import "D3Theme.h"

CGFloat const kD3CellFadedAlpha = 0.5f;

@interface D3HeroCell ()

@property (strong, nonatomic) UIImageView *iconView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *subtitleLabel;
@property (strong, nonatomic) UIImageView *shadowView;

@end

@implementation D3HeroCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [D3Theme midgroundColor];
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
    // override, do not do blue background
    [super setSelected:selected animated:animated];
    
    NSString *imageName = nil;
    if (selected) {
        self.contentView.alpha = 1.0f;
        self.backgroundColor = [D3Theme backgroundColor];
        imageName = [NSString stringWithFormat:@"%@-selected",self.hero.className];
        
        if (!self.shadowView) {
            UIImage *shadowImage = [UIImage imageNamed:@"block-shadow"];
            shadowImage = [shadowImage stretchableImageWithLeftCapWidth:floorf(shadowImage.size.width / 2.0f) topCapHeight:floorf(shadowImage.size.height / 2.0f)];
            self.shadowView.image = shadowImage;
            self.shadowView.contentMode = UIViewContentModeScaleToFill;
            self.shadowView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            self.shadowView.frame = self.contentView.bounds;
            [self.contentView addSubview:self.shadowView];
        }
        self.shadowView.hidden = NO;
    }
    else {
        self.backgroundColor = [D3Theme midgroundColor];
        self.contentView.alpha = kD3CellFadedAlpha;
        imageName = self.hero.className;
        self.shadowView.hidden = YES;
    }
    UIImage *image = [UIImage imageNamed:imageName];
    self.iconView.image = image;
}


#pragma mark - Helpers

- (void)setupView {
    CGRect frame = self.contentView.frame;
    CGFloat itemPadding = -2.0f;
    UIImage *classImage = [UIImage imageNamed:self.hero.className];
    if (! self.iconView && self.hero.className) {
        self.iconView = [[UIImageView alloc] initWithImage:classImage];
        
        CGFloat iconScale = frame.size.height / self.iconView.frame.size.height;
        CGFloat resizeScale = 0.6f;
        CGFloat iconHeight = iconScale * self.iconView.frame.size.height * resizeScale;
        CGFloat iconWidth = iconScale * self.iconView.frame.size.width * resizeScale;
        
        self.iconView.frame = CGRectMake(0, 0, iconWidth, iconHeight);
        self.iconView.center = CGPointMake(frame.size.width / 2.0f, frame.size.height / 2.0f - kD3Grid1 / 2.5f);
        [self.contentView addSubview:self.iconView];
    }
    if (! self.nameLabel) {
        self.nameLabel = [D3Theme labelWithFrame:CGRectMake(0, 0, frame.size.width, 0)
                                            font:[D3Theme systemFontSize:kD3TinyFontSize serif:NO bold:YES italic:NO]
                                            text:[self.hero.name uppercaseString]];
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        self.nameLabel.center = CGPointMake(frame.size.width / 2.0f,
                                            self.iconView.frame.size.height + self.iconView.frame.origin.y + self.nameLabel.frame.size.height / 2.0f + itemPadding);
        [self.contentView addSubview:self.nameLabel];
    }
    if (! self.subtitleLabel) {
        self.subtitleLabel = [D3Theme labelWithFrame:CGRectMake(0, 0, frame.size.width, 0)
                                                font:[D3Theme systemFontSize:kD3TinyFontSize serif:NO bold:NO italic:NO]
                                                text:[NSString stringWithFormat:@"%i %@",self.hero.level,[self.hero formattedClassName]]];
        self.subtitleLabel.textAlignment = NSTextAlignmentCenter;
        self.subtitleLabel.center = CGPointMake(frame.size.width / 2.0f,
                                                self.nameLabel.frame.size.height + self.nameLabel.frame.origin.y + self.subtitleLabel.frame.size.height / 2.0f + itemPadding);
        [self.contentView addSubview:self.subtitleLabel];
    }
    if (self.isSelected) {
        self.contentView.alpha = 1.0f;
    }
    else {
        self.contentView.alpha = kD3CellFadedAlpha;
    }
    NSString *titleString = nil;
    if (self.hero.hardcore) {
        titleString = [NSString stringWithFormat:@"%@ - HC",[self.hero.name capitalizedString]];
    }
    else {
        titleString = [self.hero.name capitalizedString];
    }
    self.nameLabel.text = titleString;
    self.subtitleLabel.text = [NSString stringWithFormat:@"%i %@",self.hero.level,[self.hero formattedClassName]];
    self.iconView.image = classImage;
}


@end
