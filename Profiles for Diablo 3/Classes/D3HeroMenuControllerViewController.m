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

@implementation D3HeroMenuControllerViewController {
    BOOL isShowingHero;
}

#pragma mark - NSObject

- (id)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedCareerReadyNotification:) name:kD3CareerNotification object:nil];
        isShowingHero = NO;
    }
    return self;
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGSize screenSize = [UIApplication currentSize];
    self.menuView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kD3MenuWidth, screenSize.height) style:UITableViewStyleGrouped];
    self.menuView.dataSource = self;
    self.menuView.delegate = self;
    self.menuView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.menuView.separatorColor = [D3Theme borderColor];
    [self.view addSubview:self.menuView];
    [self.menuView reloadData];
    
    // hack to change background color
    self.menuView.backgroundView = nil;
    self.menuView.backgroundView = [[UIView alloc] init];
    self.menuView.backgroundColor = [D3Theme foregroundColor];
    
    UIColor *textureColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"texture"]];
    self.view.backgroundColor = textureColor;
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kD3Grid2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.heroes count] + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    D3HeroCell *cell = (D3HeroCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[D3HeroCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.row == [self.heroes count] && indexPath.row != 0) {
        cell.cellType = D3HeroCellTypeLogout;
    }
    else if (indexPath.row < [self.heroes count]) {
        D3Hero *hero = self.heroes[indexPath.row];
        cell.hero = hero;
        if (! hero.isFullyLoaded) {
            UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [cell.contentView addSubview:activityIndicator];
            [activityIndicator startAnimating];
            
            [hero finishLoadingWithSuccess:^(D3Hero *hero) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [activityIndicator stopAnimating];
                    [activityIndicator removeFromSuperview];
                    [cell setupView];
                });
            } failure:^(NSError *error) {
                
            }];
        }
        else {
            [cell setupView];
        }
    }
    
//    if (indexPath.row < [self.heroes count]) {
//        // if we are here we have at least 1 hero, load it into the stack
//        D3Hero *hero = self.heroes[indexPath.row];
//        cell.hero = hero;
//    }
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.menuView.visibleCells enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isMemberOfClass:[UITableViewCell class]]) {
            UITableViewCell *cell = (UITableViewCell*)obj;
            [cell setSelected:NO animated:NO];
        }
    }];
    
    // TODO: unselect cells, disable connections for items
    D3HeroCell *cell = (D3HeroCell*)[tableView cellForRowAtIndexPath:indexPath];
    if (cell.cellType == D3HeroCellTypeLogout && indexPath.row != 0) {
        [cell setSelected:NO animated:NO];
        CGRect windowFrame = [[UIScreen mainScreen] bounds];
        CGFloat windowWidth = windowFrame.size.width;
        windowFrame.size.width = windowFrame.size.height;
        windowFrame.size.height = windowWidth;
        D3AccountView *accountView = [[D3AccountView alloc] initWithFrame:windowFrame];
        [kAppDelegate.window.rootViewController.view addSubview:accountView];
    }
    else if (cell.hero.isFullyLoaded) {
        [cell setSelected:YES animated:YES];
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
