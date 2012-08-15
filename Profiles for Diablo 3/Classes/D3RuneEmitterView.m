//
//  RuneEmitterView.m
//  Diablo
//
//  Created by Ryan Nystrom on 6/28/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

#import "D3RuneEmitterView.h"

@implementation D3RuneEmitterView
{
    CAEmitterLayer *emitter;
}

- (id)initWithPathFromImageView:(UIImageView *)imageView
{
    if (self = [super initWithFrame:imageView.frame]) {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)enableEmitter
{
    emitter = (CAEmitterLayer*)self.layer;
    CGSize size = self.frame.size;
    [emitter setEmitterPosition:CGPointMake(size.width / 2.0f, size.height / 2.0f)];
    [emitter setEmitterSize:CGSizeMake(size.width, size.height)];
    [emitter setEmitterShape:kCAEmitterLayerCircle];
    [emitter setRenderMode:kCAEmitterLayerAdditive];
    
    CAEmitterCell *runeGlow = [CAEmitterCell emitterCell];
    [runeGlow setColor:[[UIColor whiteColor] CGColor]];
    [runeGlow setName:@"runeGlow"];
    [runeGlow setBirthRate:2000.0f];
    [runeGlow setVelocity:30.0f];
    [runeGlow setLifetime:0.6f];
    [runeGlow setEmissionRange:M_PI * 2.0f];
    [runeGlow setContents:(id)[[UIImage imageNamed:@"burn.png"] CGImage]];
    
    [emitter setEmitterCells:[NSArray arrayWithObject:runeGlow]];
}

+ (Class)layerClass
{
    return [CAEmitterLayer class];
}

@end
