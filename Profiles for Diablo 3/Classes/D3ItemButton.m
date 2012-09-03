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

@end

@implementation D3ItemButton

#pragma mark - Setters

- (void)setItem:(D3Item *)item {
    _item = item;
    CALayer *layer = self.layer;
    layer.shadowColor = item.displayColor.CGColor;
    layer.shadowOffset = CGSizeZero;
    layer.shadowRadius = 10.0f;
    layer.shadowOpacity = 1.0f;
    layer.shouldRasterize = YES;
    
    if (item.sockets > 0) {
//        NSMutableArray *mutSocketImageRequests = [NSMutableArray array];
        CGSize socketImageSize = [UIImage imageNamed:@"socket"].size;
        CGFloat socketHeight = socketImageSize.height / 2.0f * item.sockets;
        CGPoint center = CGPointMake(self.frame.size.width / 2.0f, self.frame.size.height / 2.0f - socketHeight / 2.0f);
        for (int i = 0; i < item.sockets; ++i) {
            UIImageView *socketView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, socketImageSize.width, socketImageSize.height)];
            socketView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"socket"]];
            socketView.center = center;
            [self addSubview:socketView];
            
            center.y += socketImageSize.height;
        }
    }
}


@end
