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
#import "TestFlight.h"
#import "D3Defines.h"
#import "OLGhostAlertView.h"

@interface AppDelegate ()
@property (nonatomic, strong) PSStackedViewController *stackController;
@end

@implementation AppDelegate
#import "UIApplication+AppDimensions.h"
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [TestFlight takeOff:@"3df1dca088684de8a8543d2eb3d76387_MTI4NTM4MjAxMi0wOS0wNCAxNToyOToxMC4xMzQxNDI"];
    
#define TESTING 1
#ifdef TESTING
    [TestFlight setDeviceIdentifier:[[UIDevice currentDevice] uniqueIdentifier]];
#endif
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    // container so we can have a "modal" affect with the account view
    self.masterController = [[D3ViewController alloc] init];
    self.masterController.view.autoresizesSubviews = YES;
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
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        [D3Career getCareerForBattletag:previousCareer success:^(D3Career *career) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            });
            // TODO: remove placeholder image with spinner
        } failure:^(NSHTTPURLResponse *response, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                
                self.accountViewController = [[D3AccountViewController alloc] init];
                [self.masterController.view addSubview:self.accountViewController.view];
                self.accountViewController.view.left = 0;
                self.accountViewController.view.top = 0;
                
                NSInteger code = response.statusCode != 0 ? response.statusCode : error.code;
                OLGhostAlertView *av = [[OLGhostAlertView alloc] initWithTitle:errorTitleForStatusCode(code) message:errorMessageForStatusCode(code)];
                [av show];
            });
        }];
    }
    else {
        self.accountViewController = [[D3AccountViewController alloc] init];
        [self.masterController.view addSubview:self.accountViewController.view];
    }
    
    // quick fix for alignment
    self.stackController.view.left = 0;
    self.stackController.view.top = 0;
    self.accountViewController.view.left = 0;
    self.accountViewController.view.top = 0;
    
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
    self.accountViewController.view.frame = self.masterController.view.bounds;
    [self.masterController.view addSubview:self.accountViewController.view];
    self.accountViewController.view.left = 0;
    self.accountViewController.view.top = 0;
    
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
