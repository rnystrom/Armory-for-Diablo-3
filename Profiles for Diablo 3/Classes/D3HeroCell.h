//
//  D3HeroCell.h
//  Profiles for Diablo 3
//
//  Created by Ryan Nystrom on 8/15/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "D3Hero.h"

extern CGFloat const kD3CellFadedAlpha;

enum D3HeroCellType {
    D3HeroCellTypeLogout,
    D3HeroCellTypeHero
};

@interface D3HeroCell : UITableViewCell

@property (weak, nonatomic) D3Hero *hero;
@property (assign, nonatomic) enum D3HeroCellType cellType;

- (void)setupView;

@end