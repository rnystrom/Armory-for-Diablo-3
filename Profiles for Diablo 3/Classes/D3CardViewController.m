//
//  D3CardViewController.m
//  Profiles for Diablo 3
//
//  Created by Ryan Nystrom on 8/18/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

#import "D3CardViewController.h"

@interface D3CardViewController ()

@property (strong, nonatomic) UIImageView *backgroundView;

@end

@implementation D3CardViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.width = kD3CardWidth;
    self.backgroundImage = [UIImage imageNamed:@"card-bg"];
    self.view.clipsToBounds = YES;
    
    CGFloat orientedHeight = [UIApplication currentSize].height;
    
    CALayer *layer = self.view.layer;
    layer.cornerRadius = 10.0f;
    
    UIImageView *borderImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, orientedHeight)];
    borderImage.image = [D3Theme cappedCardImage];
    [self.view addSubview:borderImage];
}


#pragma mark - Setters

- (void)setBackgroundImage:(UIImage *)backgroundImage {
    _backgroundImage = backgroundImage;
    if (! self.backgroundView) {
        CGFloat orientedHeight = [UIApplication currentSize].height;
        CGRect frame = CGRectMake(0, 0, self.view.width, orientedHeight);
        self.backgroundView = [[UIImageView alloc] initWithFrame:frame];
        [self.view insertSubview:self.backgroundView atIndex:0];
    }
    self.backgroundView.image = backgroundImage;
}


@end
