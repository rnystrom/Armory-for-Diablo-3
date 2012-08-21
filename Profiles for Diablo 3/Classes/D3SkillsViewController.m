//
//  D3SkillsViewController.m
//  Profiles for Diablo 3
//
//  Created by Ryan Nystrom on 8/18/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

#import "D3SkillsViewController.h"
#import "D3SkillButton.h"
#import "D3SkillDetailViewController.h"

@interface D3SkillsViewController ()

@property (strong, nonatomic) D3SkillButton *firstBarSkillButton;
@property (strong, nonatomic) D3SkillButton *secondBarSkillButton;
@property (strong, nonatomic) D3SkillButton *firstActiveSkillButton;
@property (strong, nonatomic) D3SkillButton *secondActiveSkillButton;
@property (strong, nonatomic) D3SkillButton *thirdActiveSkillButton;
@property (strong, nonatomic) D3SkillButton *fourthActiveSkillButton;
@property (strong, nonatomic) D3SkillButton *firstPassiveSkillButton;
@property (strong, nonatomic) D3SkillButton *secondPassiveSkillButton;
@property (strong, nonatomic) D3SkillButton *thirdPassiveSkillButton;
@property (strong, nonatomic) NSArray *buttonsArray;

@end

@implementation D3SkillsViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kD3Grid1 / 4.0f, self.view.width, 0)];
    titleLabel.font = [D3Theme exocetLargeWithBold:NO];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.text = @"SKILLS";
    [self.view addSubview:titleLabel];
    
    CGPoint titleCenter = titleLabel.center;
    titleCenter.x = self.view.width / 2.0f;
    titleLabel.center = titleCenter;
    [titleLabel autoHeight];
    
    if ([self.hero.activeSkills count] > 4 && [self.hero.passiveSkills count] > 1) {
        self.firstBarSkillButton = [D3SkillButton buttonWithSkill:self.hero.activeSkills[0]];
        self.secondBarSkillButton = [D3SkillButton buttonWithSkill:self.hero.activeSkills[1]];
        self.firstActiveSkillButton = [D3SkillButton buttonWithSkill:self.hero.activeSkills[2]];
        self.secondActiveSkillButton = [D3SkillButton buttonWithSkill:self.hero.activeSkills[3]];
        self.thirdActiveSkillButton = [D3SkillButton buttonWithSkill:self.hero.activeSkills[4]];
        self.fourthActiveSkillButton = [D3SkillButton buttonWithSkill:self.hero.activeSkills[5]];
        self.firstPassiveSkillButton = [D3SkillButton buttonWithSkill:self.hero.passiveSkills[0]];
        self.secondPassiveSkillButton = [D3SkillButton buttonWithSkill:self.hero.passiveSkills[1]];
        self.thirdPassiveSkillButton = [D3SkillButton buttonWithSkill:self.hero.passiveSkills[2]];
        
        CGFloat middleSpacing = kD3Grid2;
        CGFloat buttonHeight = kD3Grid2;
        CGFloat buttonWidth = kD3Grid2;
        
        CGFloat leftX = (self.view.width - middleSpacing - buttonWidth) / 2.0f - buttonWidth;
        CGFloat rightX = (self.view.width + middleSpacing + buttonWidth) / 2.0f;
        
        CGFloat ySpacing = kD3Grid2;
        CGFloat runningY = ySpacing + titleLabel.frame.size.height + titleLabel.frame.origin.y;
        
        self.firstBarSkillButton.frame = CGRectMake(leftX, runningY, buttonWidth, buttonHeight);
        self.secondBarSkillButton.frame = CGRectMake(rightX, runningY, buttonWidth, buttonHeight);
        
        self.firstActiveSkillButton.frame = CGRectMake(leftX, runningY += buttonHeight + ySpacing, buttonWidth, buttonHeight);
        self.secondActiveSkillButton.frame = CGRectMake(rightX, runningY, buttonWidth, buttonHeight);
        self.thirdActiveSkillButton.frame = CGRectMake(leftX, runningY += buttonHeight + ySpacing, buttonWidth, buttonHeight);
        self.fourthActiveSkillButton.frame = CGRectMake(rightX, runningY, buttonWidth, buttonHeight);
        
        self.firstPassiveSkillButton.frame = CGRectMake(0, 0, buttonWidth, buttonHeight);
        self.secondPassiveSkillButton.frame = CGRectMake(0, 0, buttonWidth, buttonHeight);
        self.thirdPassiveSkillButton.frame = CGRectMake(0, 0, buttonWidth, buttonHeight);
        
        CGFloat thirds = kD3Grid4;
        runningY += buttonHeight + ySpacing + kD3Grid2;
        self.firstPassiveSkillButton.center = CGPointMake(self.view.width / 2.0f - thirds, runningY);
        self.secondPassiveSkillButton.center = CGPointMake(self.view.width / 2.0f, runningY);
        self.thirdPassiveSkillButton.center = CGPointMake(self.view.width / 2.0f + thirds, runningY);
        
        self.buttonsArray = @[
        self.firstBarSkillButton,
        self.secondBarSkillButton,
        self.firstActiveSkillButton,
        self.secondActiveSkillButton,
        self.thirdActiveSkillButton,
        self.fourthActiveSkillButton,
        self.firstPassiveSkillButton,
        self.secondPassiveSkillButton,
        self.thirdPassiveSkillButton
        ];
        NSMutableArray *mutOperations = [NSMutableArray array];
        [self.buttonsArray enumerateObjectsUsingBlock:^(D3SkillButton *button, NSUInteger idx, BOOL *stop) {
            UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [button addSubview:activityIndicator];
            [activityIndicator startAnimating];
            [self.view addSubview:button];
            
            [button setupView];
            [button addTarget:self action:@selector(onSkill:) forControlEvents:UIControlEventTouchUpInside];
            
            AFImageRequestOperation *operation = [button.skill requestIconWithImageProcessingBlock:NULL success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                [button setBackgroundImage:image forState:UIControlStateNormal];
                [activityIndicator stopAnimating];
                [activityIndicator removeFromSuperview];
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                // TODO: placeholder image
            }];
            if (operation) {
                [mutOperations addObject:operation];
            }
        }];
        [[D3HTTPClient sharedClient] enqueueBatchOfHTTPRequestOperations:mutOperations progressBlock:NULL completionBlock:NULL];
    }
}


#pragma mark - Actions

- (void)onSkill:(id)sender {
    if ([sender isKindOfClass:[D3SkillButton class]]) {
        D3SkillButton *button = (D3SkillButton*)sender;
        D3SkillDetailViewController *viewController = [[D3SkillDetailViewController alloc] init];
        viewController.skill = button.skill;
        [self.stackController popToViewController:self animated:YES];
        [self.stackController pushViewController:viewController animated:YES];
    }
}


@end
