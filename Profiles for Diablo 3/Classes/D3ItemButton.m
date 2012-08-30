//
//  D3ItemButton.m
//  Profiles for Diablo 3
//
//  Created by Ryan Nystrom on 8/15/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

#import "D3ItemButton.h"
#import <QuartzCore/QuartzCore.h>

@interface D3ItemButton()
//@property (strong, nonatomic) UIView *backgroundImageView;
@end

@implementation D3ItemButton

#pragma mark - Helpers

//- (void)setupBackgroundImageView {
//    self.clipsToBounds = NO;
//    CGRect frame = self.frame;
//    CGPoint frameOffset = [D3Theme cappedItemImageOffset];
//    CGRect backgroundFrame = CGRectMake(0, 0, frame.size.width - frameOffset.x, frame.size.height - frameOffset.y);
//    self.backgroundImageView = [[UIView alloc] initWithFrame:backgroundFrame];
//    self.backgroundImageView.center = self.center;
    
//    CALayer *layer = self.backgroundImageView.layer;
//    layer.cornerRadius = 10.0f;
    
//    if ([self superview]) {
//        [[self superview] insertSubview:self.backgroundImageView belowSubview:self];
//    }
//}


#pragma mark - Setters

- (void)setItem:(D3Item *)item {
    _item = item;
//    self.backgroundImageView.backgroundColor = item.displayColor;
    
    CALayer *layer = self.layer;
    layer.shadowColor = item.displayColor.CGColor;
    layer.shadowOffset = CGSizeZero;
    layer.shadowRadius = 10.0f;
    layer.shadowOpacity = 1.0f;
    layer.shouldRasterize = YES;
}


//- (void)setFrame:(CGRect)frame {
//    [super setFrame:frame];
//
//    if (! self.backgroundImageView) {
//        [self setupBackgroundImageView];
//    }
//    CGPoint frameOffset = [D3Theme cappedItemImageOffset];
//    self.backgroundImageView.frame = CGRectMake(0, 0, frame.size.width - frameOffset.x, frame.size.height - frameOffset.y);
//    self.backgroundImageView.center = self.center;
//}


//- (void)setCenter:(CGPoint)center {
//    [super setCenter:center];
//    self.backgroundImageView.center = center;
//}


#pragma mark - UIButton

//- (void)didMoveToSuperview {
//    [self setupBackgroundImageView];
//}

@end
