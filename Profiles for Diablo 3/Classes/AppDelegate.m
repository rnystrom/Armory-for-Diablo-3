//
//  AppDelegate.m
//  Profiles for Diablo 3
//
//  Created by Ryan Nystrom on 8/15/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

#import "AppDelegate.h"
#import "D3HeroMenuControllerViewController.h"
#import "D3Theme.h"

@interface AppDelegate ()
@property (nonatomic, strong) PSStackedViewController *stackController;
@end

@implementation AppDelegate
#import "UIApplication+AppDimensions.h"
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    // container so we can have a "modal" affect with the account view
    self.masterController = [[UIViewController alloc] init];
    self.window.rootViewController = self.masterController;
    
    D3HeroMenuControllerViewController *menuController = [[D3HeroMenuControllerViewController alloc] init];
    self.stackController = [[PSStackedViewController alloc] initWithRootViewController:menuController];
    self.stackController.largeLeftInset = kD3MenuWidth;
    [self.masterController.view addSubview:self.stackController.view];
    
    self.window.backgroundColor = [D3Theme backgroundColor];
    
    [self.window makeKeyAndVisible];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *previousCareer = [defaults objectForKey:kD3PreviouslyLoggedCareer];
    if (previousCareer) {
        [D3Career getCareerForBattletag:previousCareer success:^(D3Career *career) {
            // TODO: remove placeholder image with spinner
        } failure:^(NSError *error) {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [av show];
        }];
    }
    else {
        self.accountViewController = [[D3AccountViewController alloc] init];
        [self.masterController.view addSubview:self.accountViewController.view];
    }
    
    // quick fix for alignment
    self.stackController.view.left = 0;
    self.accountViewController.view.left = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedRemoveDoorsNotification:) name:kD3DoorsAnimatedOffScreenNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedShouldResetNotification:) name:kD3ShouldResetNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedCareerReadyNotification:) name:kD3CareerNotification object:nil];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notifications

- (void)receivedRemoveDoorsNotification:(NSNotification*)notification {
    [self.accountViewController.view removeFromSuperview];
    self.accountViewController = nil;
}


- (void)receivedShouldResetNotification:(NSNotification*)notification {
    self.accountViewController = [[D3AccountViewController alloc] init];
    [self.masterController.view addSubview:self.accountViewController.view];
    self.accountViewController.view.left = 0;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:kD3PreviouslyLoggedCareer];
    [defaults synchronize];
}


- (void)receivedCareerReadyNotification:(NSNotification*)notification {
    D3Career *career = notification.userInfo[kD3CareerNotificationUserInfoKey];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:career.battletag forKey:kD3PreviouslyLoggedCareer];
    [defaults synchronize];
}


@end
