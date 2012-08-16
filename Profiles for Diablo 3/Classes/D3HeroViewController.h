//
//  D3HeroViewController.h
//  Profiles for Diablo 3
//
//  Created by Ryan Nystrom on 8/15/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

#import "PSStackedViewDelegate.h"

@interface D3HeroViewController : UIViewController
<PSStackedViewDelegate>

@property (weak, nonatomic) D3Hero *hero;

@end
