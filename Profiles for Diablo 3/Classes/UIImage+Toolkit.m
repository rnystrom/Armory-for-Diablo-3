//
//  UIImage+Toolkit.m
//  Profiles for Diablo 3
//
//  Created by Ryan Nystrom on 8/23/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

#import "UIImage+Toolkit.h"

@implementation UIImage (Toolkit)

- (UIImage*)resizedToSize:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


@end
