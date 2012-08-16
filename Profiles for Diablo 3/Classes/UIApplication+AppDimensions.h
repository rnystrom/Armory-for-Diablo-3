//
//  UIApplication+AppDimensions.h
//  Profiles for Diablo 3
//
//  Created by Ryan Nystrom on 8/16/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//
//  http://stackoverflow.com/questions/7905432/how-to-get-orientation-dependent-height-and-width-of-the-screen/7905540#7905540

#import <UIKit/UIKit.h>

@interface UIApplication (AppDimensions)
+(CGSize) currentSize;
+(CGSize) sizeInOrientation:(UIInterfaceOrientation)orientation;
@end