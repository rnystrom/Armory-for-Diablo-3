//
//  RuneEmitterView.h
//  Diablo
//
//  Created by Ryan Nystrom on 6/28/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface D3RuneEmitterView : UIView

@property (assign, nonatomic) BOOL killMe;

- (id)initWithPathFromImageView:(UIImageView*)imageView;
- (void)enableEmitter;

@end
