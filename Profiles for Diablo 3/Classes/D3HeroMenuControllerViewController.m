//
//  D3HeroMenuControllerViewController.m
//  Profiles for Diablo 3
//
//  Created by Ryan Nystrom on 8/15/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

#import "D3HeroMenuControllerViewController.h"
#import "D3HeroCell.h"
#import "PSStackedViewController.h"
#import "AppDelegate.h"
#import "D3HeroViewController.h"
#import "D3AccountView.h"

@interface D3HeroMenuControllerViewController ()
@property (strong, nonatomic) UITableView *menuView;
@property (weak, nonatomic) NSArray *heroes;
@end

@implementation D3HeroMenuControllerViewController

#pragma mark - NSObject

- (id)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedCareerReadyNotification:) name:kD3CareerNotification object:nil];
    }
    return self;
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect screenFrame = [[UIScreen mainScreen] applicationFrame];
    self.menuView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kD3MenuWidth, screenFrame.size.height) style:UITableViewStylePlain];
    self.menuView.dataSource = self;
    self.menuView.delegate = self;
    [self.view addSubview:self.menuView];
    [self.menuView reloadData];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.heroes count] > 0) {
        return [self.heroes count] + 2;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    D3HeroCell *cell = (D3HeroCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[D3HeroCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.row == [self.heroes count] + 1) {
        cell.cellType = D3HeroCellTypeLogout;
    }
    else if (indexPath.row == [self.heroes count]) {
        cell.cellType = D3HeroCellTypeAccount;
    }
    else {
        cell.hero = self.heroes[indexPath.row];
    }
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // TODO: unselect cells, disable connections for items
    D3HeroCell *cell = (D3HeroCell*)[tableView cellForRowAtIndexPath:indexPath];
    if (cell.cellType == D3HeroCellTypeLogout) {
        CGRect windowFrame = [[UIScreen mainScreen] bounds];
        CGFloat windowWidth = windowFrame.size.width;
        windowFrame.size.width = windowFrame.size.height;
        windowFrame.size.height = windowWidth;
        D3AccountView *accountView = [[D3AccountView alloc] initWithFrame:windowFrame];
        [kAppDelegate.window.rootViewController.view addSubview:accountView];
    }
    else if (cell.cellType == D3HeroCellTypeAccount) {
        
    }
    else if (cell.hero.isFullyLoaded) {
        D3Hero *selectedHero = self.heroes[indexPath.row];
        D3HeroViewController *viewController = [[D3HeroViewController alloc] init];
        viewController.hero = selectedHero;
        
        [kAppDelegate.stackController popToRootViewControllerAnimated:YES];
        [kAppDelegate.stackController pushViewController:viewController fromViewController:nil animated:YES];
    }
}


#pragma mark - Notifications

- (void)receivedCareerReadyNotification:(NSNotification*)notification {
    [kAppDelegate.stackController popToRootViewControllerAnimated:YES];
    D3Career *career = [D3HTTPClient sharedClient].career;
    self.heroes = career.heroes;
    [self.menuView reloadData];
}

@end
