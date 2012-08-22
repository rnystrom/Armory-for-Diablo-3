//
//  D3HeroViewController.m
//  Profiles for Diablo 3
//
//  Created by Ryan Nystrom on 8/15/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

#import "D3HeroViewController.h"
#import "D3ItemButton.h"
#import "D3ItemViewController.h"
#import "D3SkillsViewController.h"
#import "D3StatsViewController.h"

@interface D3HeroViewController ()
@property (strong, nonatomic) D3ItemButton *headButton;
@property (strong, nonatomic) D3ItemButton *shouldersButton;
@property (strong, nonatomic) D3ItemButton *neckButton;
@property (strong, nonatomic) D3ItemButton *handsButton;
@property (strong, nonatomic) D3ItemButton *torsoButton;
@property (strong, nonatomic) D3ItemButton *bracersButton;
@property (strong, nonatomic) D3ItemButton *leftFingerButton;
@property (strong, nonatomic) D3ItemButton *waistButton;
@property (strong, nonatomic) D3ItemButton *rightFingerButton;
@property (strong, nonatomic) D3ItemButton *legsButton;
@property (strong, nonatomic) D3ItemButton *mainHandButton;
@property (strong, nonatomic) D3ItemButton *offHandButton;
@property (strong, nonatomic) D3ItemButton *feetButton;
@property (strong, nonatomic) NSArray *itemButtons;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *subtitleLabel;
@end

@implementation D3HeroViewController

#pragma mark - Class Helpers

+ (UIButton*)extraButtonLeft:(BOOL)isLeft containerFrame:(CGRect)containerFrame{
    CGFloat middleSpacing = kD3Grid1;
    CGFloat y = (containerFrame.size.width - middleSpacing) / 2.0f - kD3Grid4;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    CGRect frame = CGRectMake(isLeft ? y : containerFrame.size.width / 2.0f + middleSpacing / 2.0f, 675.0f, kD3Grid4, kD3Grid2);
    [button setFrame:frame];
    return button;
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [D3Theme foregroundColor];
    
    self.titleLabel = [D3Theme labelWithFrame:CGRectMake(0, kD3Grid1 / 4.0f, self.view.width, 0) font:[D3Theme exocetLargeWithBold:NO] text:nil];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:self.titleLabel];
    
    self.subtitleLabel = [D3Theme labelWithFrame:CGRectMake(0, kD3Grid1 / 4.0f, self.view.width, 0) font:[D3Theme systemSmallFontWithBold:NO] text:nil];
    self.subtitleLabel.textAlignment = NSTextAlignmentCenter;
    self.subtitleLabel.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:self.subtitleLabel];
    
    [self setupGearButtons];
    
    UIButton *skillsButton = [D3HeroViewController extraButtonLeft:YES containerFrame:self.view.frame];
    [skillsButton setTitle:@"Skills" forState:UIControlStateNormal];
    [skillsButton addTarget:self action:@selector(onSkills:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:skillsButton];
    
    UIButton *statsButton = [D3HeroViewController extraButtonLeft:NO containerFrame:self.view.frame];
    [statsButton setTitle:@"Stats" forState:UIControlStateNormal];
    [statsButton addTarget:self action:@selector(onStats:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:statsButton];
    
    if (self.hero) {
        [self setupHero];
    }
}


#pragma mark - Actions

- (void)onItemTouchUpInside:(id)sender {
    D3ItemButton *button = (D3ItemButton*)sender;
    D3Item *selectedItem = button.item;
    D3ItemViewController *viewController = [[D3ItemViewController alloc] init];
    viewController.item = selectedItem;
    [self.stackController popToViewController:self animated:YES];
    [self.stackController pushViewController:viewController animated:YES];
}


- (void)onSkills:(id)sender {
    D3SkillsViewController *viewController = [[D3SkillsViewController alloc] init];
    viewController.hero = self.hero;
    [self.stackController popToViewController:self animated:YES];
    [self.stackController pushViewController:viewController animated:YES];
}


- (void)onStats:(id)sender {
    D3StatsViewController *viewController = [[D3StatsViewController alloc] init];
    viewController.hero = self.hero;
    [self.stackController popToViewController:self animated:YES];
    [self.stackController pushViewController:viewController animated:YES];
}


#pragma mark - Helpers

- (void)setupGearButtons {
    self.headButton = [[D3ItemButton alloc] initWithFrame:CGRectMake(0, 0, kD3Grid2, kD3Grid3)];
    self.shouldersButton = [[D3ItemButton alloc] initWithFrame:CGRectMake(0, 0, kD3Grid2, kD3Grid3)];
    self.neckButton = [[D3ItemButton alloc] initWithFrame:CGRectMake(0, 0, kD3Grid1, kD3Grid1)];
    self.handsButton = [[D3ItemButton alloc] initWithFrame:CGRectMake(0, 0, kD3Grid2, kD3Grid3)];
    self.bracersButton = [[D3ItemButton alloc] initWithFrame:CGRectMake(0, 0, kD3Grid2, kD3Grid3)];
    self.leftFingerButton = [[D3ItemButton alloc] initWithFrame:CGRectMake(0, 0, kD3Grid1, kD3Grid1)];
    self.rightFingerButton = [[D3ItemButton alloc] initWithFrame:CGRectMake(0, 0, kD3Grid1, kD3Grid1)];
    self.waistButton = [[D3ItemButton alloc] initWithFrame:CGRectMake(0, 0, kD3Grid2, kD3Grid1)];
    self.legsButton = [[D3ItemButton alloc] initWithFrame:CGRectMake(0, 0, kD3Grid2, kD3Grid3)];
    self.mainHandButton = [[D3ItemButton alloc] initWithFrame:CGRectMake(0, 0, kD3Grid2, kD3Grid3 * 1.5f)];
    self.offHandButton = [[D3ItemButton alloc] initWithFrame:CGRectMake(0, 0, kD3Grid2, kD3Grid3 * 1.5f)];
    self.feetButton = [[D3ItemButton alloc] initWithFrame:CGRectMake(0, 0, kD3Grid2, kD3Grid3)];
    self.torsoButton = [[D3ItemButton alloc] initWithFrame:CGRectMake(0, 0, kD3Grid2 * 1.5f, kD3Grid3 * 1.5f)];
    
    CGFloat screenHeight = [UIApplication currentSize].height;
    CGFloat center = self.view.frame.size.width / 2.0f;
    CGFloat minPadding = kD3Grid1 / 4.0f;
    CGFloat shoulderOffset = kD3Grid3 / 2.0f + kD3Grid2 / 2.0f;
    CGFloat leftShoulderCenter = center - shoulderOffset - minPadding;
    CGFloat rightShoulderCenter = center + shoulderOffset + minPadding;
    
    // waist & below
    self.waistButton.center = CGPointMake(center, screenHeight / 2.0f);
    CGFloat runningItemHeight = self.waistButton.center.y + self.waistButton.frame.size.height / 2.0f;
    self.legsButton.center = CGPointMake(center, runningItemHeight += self.legsButton.frame.size.height / 2.0f + minPadding);
    self.feetButton.center = CGPointMake(center, runningItemHeight += self.legsButton.frame.size.height + minPadding);
    
    // above waist
    runningItemHeight = self.waistButton.frame.origin.y - self.waistButton.frame.size.height / 2.0f;
    self.torsoButton.center = CGPointMake(center, runningItemHeight -= self.torsoButton.frame.size.height / 2.0f - minPadding);
    self.headButton.center = CGPointMake(center, runningItemHeight -= self.torsoButton.frame.size.height - minPadding);
    
    // "shoulder" items
    self.shouldersButton.center = CGPointMake(leftShoulderCenter, self.torsoButton.frame.origin.y);
    self.neckButton.center = CGPointMake(rightShoulderCenter, self.torsoButton.frame.origin.y);
    
    // offset items
    CGFloat torsoBottomY = self.torsoButton.frame.origin.y + self.torsoButton.size.height;
    CGFloat leftOffset = self.shouldersButton.frame.origin.x;
    CGFloat rightOffset = self.neckButton.frame.origin.x + self.neckButton.frame.size.width;
    
    self.handsButton.center = CGPointMake(leftOffset, torsoBottomY);
    self.bracersButton.center = CGPointMake(rightOffset, torsoBottomY);
    
    // adjust weapons to match bottoms with boots
    CGFloat bootsBottomY = self.feetButton.frame.origin.y + self.feetButton.size.height;
    CGRect mhFrame = self.mainHandButton.frame;
    CGRect ohFrame = self.offHandButton.frame;
    mhFrame.origin.y = bootsBottomY - mhFrame.size.height;
    ohFrame.origin.y = bootsBottomY - ohFrame.size.height;
    mhFrame.origin.x = leftOffset - mhFrame.size.width / 2.0f;
    ohFrame.origin.x = rightOffset - ohFrame.size.width / 2.0f;
    self.mainHandButton.frame = mhFrame;
    self.offHandButton.frame = ohFrame;
    
    // place rings between weapons and hands
    CGFloat betweenWeaponHands = (self.handsButton.frame.origin.y + self.handsButton.frame.size.height + self.mainHandButton.frame.origin.y) / 2.0f;
    self.leftFingerButton.center = CGPointMake(leftOffset, betweenWeaponHands);
    self.rightFingerButton.center = CGPointMake(rightOffset, betweenWeaponHands);
    
    // Refer to D3Items ItemType typedef for ordering
    self.itemButtons = @[
    self.headButton,
    self.shouldersButton,
    self.neckButton,
    self.handsButton,
    self.bracersButton,
    self.leftFingerButton,
    self.rightFingerButton,
    self.waistButton,
    self.legsButton,
    self.mainHandButton,
    self.offHandButton,
    self.feetButton,
    self.torsoButton
    ];
    
    // hard casting button because we just defined the array
    [self.itemButtons enumerateObjectsUsingBlock:^(D3ItemButton *button, NSUInteger idx, BOOL *stop) {
        [self.view addSubview:button];
        [button addTarget:self action:@selector(onItemTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    }];
}

- (void)setupHero {
    [self.titleLabel setText:[self.hero.name uppercaseString]];
    [self.titleLabel autoHeight];
    
    NSString *subtitleString = [NSString stringWithFormat:@"%i %@",self.hero.level, [self.hero.className capitalizedString]];
    CGRect subtitleFrame = self.subtitleLabel.frame;
    subtitleFrame.origin.y = self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height;
    self.subtitleLabel.frame = subtitleFrame;
    self.subtitleLabel.text = subtitleString;
    [self.subtitleLabel autoHeight];
    
    NSMutableArray *mutOperations = [NSMutableArray array];
    [self.itemButtons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[D3ItemButton class]]) {
            D3ItemButton *button = (D3ItemButton*)obj;
            D3Item *correspondingItem = self.hero.itemsArray[idx];
            if (correspondingItem) {
                // button background logic in [D3ItemButton setItem:...];
                button.item = correspondingItem;
                
                AFImageRequestOperation *operation = [correspondingItem requestForItemIconWithImageProcessingBlock:NULL success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [button setBackgroundImage:image forState:UIControlStateNormal];
                    });
                } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
#ifdef D3_LOGGING_MODE
                    NSLog(@"Request: %@\nError: %@\nResponse: %@",request.URL,error.localizedDescription,response);
#endif
                }];
                if (operation) {
                    [mutOperations addObject:operation];
                }
            }
        }
    }];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self addOperations:mutOperations];
    [[D3HTTPClient sharedClient] enqueueBatchOfHTTPRequestOperations:mutOperations progressBlock:NULL completionBlock:^(NSArray *operations) {
        if ([[operations filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isCancelled == NO"]] count] > 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            });
        }
    }];
}


#pragma mark - Setters

- (void)setHero:(D3Hero *)hero {
    _hero = hero;
    [self setupHero];
}


@end
