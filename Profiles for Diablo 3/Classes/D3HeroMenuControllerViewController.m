//
//  D3HeroMenuControllerViewController.m
//  Profiles for Diablo 3
//
//  Created by Ryan Nystrom on 8/15/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

#import "D3HeroMenuControllerViewController.h"
#import "D3HeroCell.h"
#import "D3LogoutCell.h"
#import "PSStackedViewController.h"
#import "D3HeroViewController.h"
#import "AppDelegate.h"
#import "OLGhostAlertView.h"
#import "D3Defines.h"

@interface D3HeroMenuControllerViewController ()
@property (strong, nonatomic) UITableView *menuView;
@property (strong, nonatomic) D3Career *career;
@property (strong, nonatomic) UIButton *logoutButton;
@end

@implementation D3HeroMenuControllerViewController {
    BOOL isShowingHero;
}

#pragma mark - NSObject

- (id)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedCareerReadyNotification:) name:kD3CareerNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedLastHeroPlayedNotification:) name:kD3LastHeroPlayedNotification object:nil];
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
    return 2;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kD3Grid2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [self.career.heroes count];
    }
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *D3HeroCellIdentifier = @"D3HeroCell";
    static NSString *D3LogoutCellIdentifier = @"D3LogoutCell";
    
    id cell = nil;
    if (indexPath.section == 0) {
        D3HeroCell *heroCell = (D3HeroCell*)[tableView dequeueReusableCellWithIdentifier:D3HeroCellIdentifier];
        if (heroCell == nil) {
            heroCell = [[D3HeroCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:D3HeroCellIdentifier];
            heroCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        D3Hero *hero = self.career.heroes[indexPath.row];
        heroCell.hero = hero;
        if (! hero.isFullyLoaded) {
            UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            activityIndicator.center = CGPointMake(kD3Grid3 / 2.0f, kD3Grid1);
            [heroCell.contentView addSubview:activityIndicator];
            [activityIndicator startAnimating];
            
            [hero finishLoadingWithSuccess:^(D3Hero *hero) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [activityIndicator stopAnimating];
                    [activityIndicator removeFromSuperview];
                    [heroCell setupView];
                });
            } failure:^(NSHTTPURLResponse *response, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSInteger code = response.statusCode != 0 ? response.statusCode : error.code;
                    OLGhostAlertView *av = [[OLGhostAlertView alloc] initWithTitle:errorTitleForStatusCode(code) message:errorMessageForStatusCode(code)];
                    [av show];
                });
            }];
        }
        else {
            [heroCell setupView];
        }
        cell = heroCell;
    }
    else if (indexPath.section == 1) {
        D3LogoutCell *logoutCell = (D3LogoutCell*)[tableView dequeueReusableCellWithIdentifier:D3LogoutCellIdentifier];
        if (logoutCell == nil) {
            logoutCell = [[D3LogoutCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:D3LogoutCellIdentifier];
            logoutCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        logoutCell.backgroundColor = [D3Theme midgroundColor];
        CGRect frame = logoutCell.contentView.frame;

        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"off"]];
        imageView.center = CGPointMake(frame.size.width / 2.0f, frame.size.height / 2.0f - kD3Grid1 / 4.0f);
        [logoutCell.contentView addSubview:imageView];

        UILabel *label = [D3Theme labelWithFrame:CGRectMake(0, 0, frame.size.width, 0) font:[D3Theme systemFontSize:kD3TinyFontSize serif:NO bold:YES italic:NO] text:@"SIGN OUT"];
        label.center = CGPointMake(frame.size.width / 2.0f, imageView.frame.size.height + imageView.frame.origin.y + 4.0f);
        label.textAlignment = UITextAlignmentCenter;
        [logoutCell.contentView addSubview:label];
        
        cell = logoutCell;
    }
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    D3HeroCell *cell = (D3HeroCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    [self.menuView.visibleCells enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isMemberOfClass:[D3HeroCell class]] && obj != cell) {
            D3HeroCell *heroCell = (D3HeroCell*)obj;
            [heroCell setSelected:NO animated:NO];
        }
    }];
    
    if (indexPath.section == 1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kD3ShouldResetNotification object:nil];
    }
    else if (cell.hero.isFullyLoaded) { // do not load the card unless the hero is loaded
        [cell setSelected:YES animated:YES];
        D3HeroViewController *viewController = [[D3HeroViewController alloc] init];
        viewController.hero = cell.hero;
        
        [kAppDelegate.stackController popToRootViewControllerAnimated:YES];
        [kAppDelegate.stackController pushViewController:viewController fromViewController:nil animated:YES];
    }
}


#pragma mark - Notifications

- (void)receivedCareerReadyNotification:(NSNotification*)notification {
    [kAppDelegate.stackController popToRootViewControllerAnimated:YES];
    D3Career *career = notification.userInfo[kD3CareerNotificationUserInfoKey];
    self.career = career;
    [self.menuView reloadData];
}

- (void)receivedLastHeroPlayedNotification:(NSNotification*)notification {
    D3Hero *lastHero = notification.userInfo[kD3HeroNotificationUserInfoKey];
    D3HeroViewController *viewController = [[D3HeroViewController alloc] init];
    viewController.hero = lastHero;
    [kAppDelegate.stackController popToRootViewControllerAnimated:YES];
    [kAppDelegate.stackController pushViewController:viewController fromViewController:nil animated:NO];
    
    [self.menuView.visibleCells enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isMemberOfClass:[D3HeroCell class]]) {
            D3HeroCell *cell = (D3HeroCell*)obj;
            if (cell.hero == lastHero) {
                [cell setSelected:YES animated:NO];
                *stop = YES;
            }
        }
    }];
}

@end
