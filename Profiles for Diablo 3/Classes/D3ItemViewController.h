//
//  D3ItemViewController.h
//  Profiles for Diablo 3
//
//  Created by Ryan Nystrom on 8/16/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

#import "D3CardViewController.h"
#import "PSStackedViewDelegate.h"

@interface D3ItemViewController : D3CardViewController
<PSStackedViewDelegate>

@property (weak, nonatomic) D3Item *item;

@end
