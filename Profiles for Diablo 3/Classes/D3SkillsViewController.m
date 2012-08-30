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
    
    self.backgroundImage = [UIImage imageNamed:@"dark-bg"];
    
    UILabel *titleLabel = [D3Theme labelWithFrame:CGRectMake(0, kD3TopPadding, self.view.width, 0) font:[D3Theme exocetLargeWithBold:YES] text:@"Skills"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:titleLabel];
    
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
        
        CGFloat spacer = kD3Grid3;
        
        UILabel *activeLabel = [D3Theme labelWithFrame:CGRectMake(0, titleLabel.bottom + kD3Grid1, self.view.width, 0) font:[D3Theme systemMediumFontWithBold:NO] text:@"Active"];
        activeLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:activeLabel];
        
        CGPoint leftCenter = CGPointMake(self.view.width / 2.0f - kD3Grid3, activeLabel.bottom + activeLabel.height + kD3Grid1);
        CGPoint rightCenter = CGPointMake(self.view.width / 2.0f + kD3Grid3, leftCenter.y);

        self.firstBarSkillButton.center = leftCenter;
        self.secondBarSkillButton.center = rightCenter;
        
        leftCenter.y = self.firstBarSkillButton.bottom + spacer;
        rightCenter.y = self.firstBarSkillButton.bottom + spacer;
        self.firstActiveSkillButton.center = leftCenter;
        self.secondActiveSkillButton.center = rightCenter;
        
        leftCenter.y = self.firstActiveSkillButton.bottom + spacer;
        rightCenter.y = self.firstActiveSkillButton.bottom + spacer;
        self.thirdActiveSkillButton.center = leftCenter;
        self.fourthActiveSkillButton.center = rightCenter;
        
        leftCenter.y = self.thirdActiveSkillButton.bottom + spacer;
        
        UILabel *passiveLabel = [D3Theme labelWithFrame:CGRectMake(0, leftCenter.y, self.view.width, 0) font:[D3Theme systemMediumFontWithBold:NO] text:@"Passive"];
        passiveLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:passiveLabel];
        
        leftCenter.y = passiveLabel.bottom + passiveLabel.height + kD3Grid1;
        
        CGFloat thirds = kD3Grid1 * 4.5;
        self.firstPassiveSkillButton.center = CGPointMake(self.view.width / 2.0f - thirds, leftCenter.y);
        self.secondPassiveSkillButton.center = CGPointMake(self.view.width / 2.0f, leftCenter.y);
        self.thirdPassiveSkillButton.center = CGPointMake(self.view.width / 2.0f + thirds, leftCenter.y);
        
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
            // default image
            if (button.skill.isActive) {
                [button setImage:[UIImage imageNamed:@"skill-blank"] forState:UIControlStateNormal];
            }
            else {
                [button setImage:[UIImage imageNamed:@"skills-passive-blank"] forState:UIControlStateNormal];
            }
            [self.view addSubview:button];
            
            if (button.skill.iconString) {
                UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                [button addSubview:activityIndicator];
                [activityIndicator startAnimating];
                
                [button setupView];
                [button addTarget:self action:@selector(onSkill:) forControlEvents:UIControlEventTouchUpInside];
                
                AFImageRequestOperation *operation = [button.skill requestIconWithImageProcessingBlock:^UIImage* (UIImage* image) {
                    if ([UIScreen mainScreen].scale > 1.0f) {
                        CGFloat scale = [UIScreen mainScreen].scale;
                        CGSize doubledSize = CGSizeMake(image.size.width * scale, image.size.height * scale);
                        image = [image resizedToSize:doubledSize];
                    }
                    return image;
                }  success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                    if (image) {
                        [button setImage:image forState:UIControlStateNormal];
                    }
                    [activityIndicator stopAnimating];
                    [activityIndicator removeFromSuperview];
                } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                    // TODO: placeholder image
                }];
                if (operation) {
                    [mutOperations addObject:operation];
                }
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
