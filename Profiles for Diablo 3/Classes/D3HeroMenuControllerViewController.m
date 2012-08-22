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
#import "AppDelegate.h"
#import "D3HeroViewController.h"
#import "D3AccountView.h"

@interface D3HeroMenuControllerViewController ()
@property (strong, nonatomic) UITableView *menuView;
@property (weak, nonatomic) NSArray *heroes;
@property (strong, nonatomic) UIButton *logoutButton;
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
    return 2;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kD3Grid2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [self.heroes count];
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
        D3Hero *hero = self.heroes[indexPath.row];
        heroCell.hero = hero;
        if (! hero.isFullyLoaded) {
            UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [heroCell.contentView addSubview:activityIndicator];
            [activityIndicator startAnimating];
            
            [hero finishLoadingWithSuccess:^(D3Hero *hero) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [activityIndicator stopAnimating];
                    [activityIndicator removeFromSuperview];
                    [heroCell setupView];
                });
            } failure:^(NSError *error) {
                
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
        label.textAlignment = NSTextAlignmentCenter;
        [logoutCell.contentView addSubview:label];
        
        cell = logoutCell;
    }
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
    if (indexPath.section == 1) {
        [(UITableViewCell*)cell setSelected:NO animated:NO];
        CGRect windowFrame = [[UIScreen mainScreen] bounds];
        CGFloat windowWidth = windowFrame.size.width;
        windowFrame.size.width = windowFrame.size.height;
        windowFrame.size.height = windowWidth;
        D3AccountView *accountView = [[D3AccountView alloc] initWithFrame:windowFrame];
        [kAppDelegate.window.rootViewController.view addSubview:accountView];
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
    D3Career *career = [D3HTTPClient sharedClient].career;
    self.heroes = career.heroes;
    [self.menuView reloadData];
}

@end
