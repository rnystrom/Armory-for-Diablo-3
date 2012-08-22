//
//  D3CardViewController.m
//  Profiles for Diablo 3
//
//  Created by Ryan Nystrom on 8/18/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

#import "D3CardViewController.h"

@interface D3CardViewController ()

@end

@implementation D3CardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.width = kD3CardWidth;
    
    self.texturedView = [[D3TexturedView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    [self.view addSubview:self.texturedView];
    
    CALayer *layer = self.view.layer;
    layer.cornerRadius = 5.0f;
}


@end
