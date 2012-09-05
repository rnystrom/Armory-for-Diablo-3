//
//  AppDelegate.h
//  Profiles for Diablo 3
//
//  Created by Ryan Nystrom on 8/15/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "D3ViewController.h"
#import "PSStackedView.h"
#import "D3AccountViewController.h"

#define kAppDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong, readonly) PSStackedViewController *stackController;
@property (nonatomic, strong) D3AccountViewController *accountViewController;
@property (nonatomic, strong) D3ViewController *masterController;
@end
