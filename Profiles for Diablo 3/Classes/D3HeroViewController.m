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
@property (strong, nonatomic) UILabel *hardcoreLabel;
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
    
    self.backgroundImage = [UIImage imageNamed:@"hero-card-bg-3"];
    
    // placeholder text so we can autosize the labels
    self.titleLabel = [D3Theme labelWithFrame:CGRectMake(kD3Grid1 / 2.0f, kD3TopPadding, self.view.width - kD3Grid4, 0)
                                         font:[D3Theme exocetLargeWithBold:NO]
                                         text:@"NAME"];
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.titleLabel.numberOfLines = 1;
    [self.view addSubview:self.titleLabel];
    
    self.hardcoreLabel = [D3Theme labelWithFrame:CGRectMake(kD3Grid1 / 2.0f, self.titleLabel.bottom, 0, 0) font:[D3Theme systemSmallFontWithBold:YES] text:@"Hardcore"];
    self.hardcoreLabel.textColor = [D3Theme redItemColor];
    [self.hardcoreLabel sizeToFit];
    [self.view addSubview:self.hardcoreLabel];
    
    self.subtitleLabel = [D3Theme labelWithFrame:CGRectMake(kD3Grid1 / 2.0f, self.titleLabel.bottom, self.view.width - kD3Grid2, 0)
                                            font:[D3Theme systemSmallFontWithBold:NO]
                                            text:@"60 Placeholder"];
    self.subtitleLabel.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:self.subtitleLabel];
    
    [self setupGearButtons];
    
    UIButton *statsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    statsButton.frame = CGRectMake(self.view.width - kD3Grid1 * 1.5f - kD3Grid1 / 2.0f, kD3TopPadding + 4.0f, kD3Grid1 * 1.5f, kD3Grid1 * 1.5f);
    [statsButton setImage:[UIImage imageNamed:@"stats-button"] forState:UIControlStateNormal];
    [statsButton addTarget:self action:@selector(onStats:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:statsButton];
    
    UIButton *skillsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    skillsButton.frame = CGRectMake(statsButton.left - statsButton.width - kD3Grid1 / 4.0f, statsButton.frame.origin.y, statsButton.width, statsButton.height);
    [skillsButton setImage:[UIImage imageNamed:@"skills-button"] forState:UIControlStateNormal];
    [skillsButton addTarget:self action:@selector(onSkills:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:skillsButton];
    
    if (self.hero.isFullyLoaded) {
        [self setupHero];
    }
    else {
        [self.hero addObserver:self forKeyPath:@"isFullyLoaded" options:NSKeyValueObservingOptionNew context:NULL];
    }
}


#pragma mark - Actions

- (void)onItemTouchUpInside:(id)sender {
    D3ItemButton *button = (D3ItemButton*)sender;
    
    D3Item *selectedItem = button.item;
    if (selectedItem.iconString) {
        D3ItemViewController *viewController = [[D3ItemViewController alloc] init];
        viewController.item = selectedItem;
        [self.stackController popToViewController:self animated:YES];
        [self.stackController pushViewController:viewController animated:YES];
    }
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
    self.headButton = [[D3ItemButton alloc] initWithFrame:CGRectMake(0, 0, kD3Grid2, kD3Grid4)];
    self.shouldersButton = [[D3ItemButton alloc] initWithFrame:CGRectMake(0, 0, kD3Grid2, kD3Grid4)];
    self.neckButton = [[D3ItemButton alloc] initWithFrame:CGRectMake(0, 0, kD3Grid2, kD3Grid2)];
    self.handsButton = [[D3ItemButton alloc] initWithFrame:CGRectMake(0, 0, kD3Grid2, kD3Grid4)];
    self.bracersButton = [[D3ItemButton alloc] initWithFrame:CGRectMake(0, 0, kD3Grid2, kD3Grid4)];
    self.leftFingerButton = [[D3ItemButton alloc] initWithFrame:CGRectMake(0, 0, kD3Grid2, kD3Grid2)];
    self.rightFingerButton = [[D3ItemButton alloc] initWithFrame:CGRectMake(0, 0, kD3Grid2, kD3Grid2)];
    self.waistButton = [[D3ItemButton alloc] initWithFrame:CGRectMake(0, 0, kD3Grid2, kD3Grid2)];
    self.legsButton = [[D3ItemButton alloc] initWithFrame:CGRectMake(0, 0, kD3Grid2, kD3Grid4)];
    self.mainHandButton = [[D3ItemButton alloc] initWithFrame:CGRectMake(0, 0, kD3Grid2, kD3Grid4)];
    self.offHandButton = [[D3ItemButton alloc] initWithFrame:CGRectMake(0, 0, kD3Grid2, kD3Grid4)];
    self.feetButton = [[D3ItemButton alloc] initWithFrame:CGRectMake(0, 0, kD3Grid2, kD3Grid4)];
    self.torsoButton = [[D3ItemButton alloc] initWithFrame:CGRectMake(0, 0, kD3Grid2 * 1.5f, kD3Grid4 * 1.5f)];
    
    CGFloat center = self.view.frame.size.width / 2.0f;
    CGFloat minPadding = 3.0f;
    CGFloat shoulderOffset = (self.torsoButton.width + self.shouldersButton.width) / 2.0f;
    CGFloat leftShoulderCenter = center - shoulderOffset - kD3Grid1;
    CGFloat rightShoulderCenter = center + shoulderOffset + kD3Grid1;
    
    // center items
    self.headButton.center = CGPointMake(center, self.subtitleLabel.bottom + self.headButton.height / 2.0f + minPadding + 10.0f);
    self.torsoButton.center = CGPointMake(center, self.headButton.bottom + self.torsoButton.height / 2.0f + minPadding);
    self.waistButton.center = CGPointMake(center, self.torsoButton.bottom + self.waistButton.height / 2.0f + minPadding);
    self.legsButton.center = CGPointMake(center, self.waistButton.bottom + self.legsButton.height / 2.0f + minPadding);
    self.feetButton.center = CGPointMake(center, self.legsButton.bottom + self.feetButton.height / 2.0f + minPadding);
    
    // "shoulder" items
    self.shouldersButton.center = CGPointMake(leftShoulderCenter, self.torsoButton.frame.origin.y);
    self.neckButton.center = CGPointMake(rightShoulderCenter, self.torsoButton.frame.origin.y);
    
    // offset items
    CGFloat leftOffset = self.shouldersButton.frame.origin.x;
    CGFloat rightOffset = self.neckButton.frame.origin.x + self.neckButton.frame.size.width;
    
    self.handsButton.center = CGPointMake(leftOffset, self.torsoButton.bottom);
    self.bracersButton.center = CGPointMake(rightOffset, self.torsoButton.bottom);
    
    // adjust weapons to match bottoms with boots
    CGRect mhFrame = self.mainHandButton.frame;
    CGRect ohFrame = self.offHandButton.frame;
    mhFrame.origin.y = self.feetButton.bottom - mhFrame.size.height;
    ohFrame.origin.y = self.feetButton.bottom - ohFrame.size.height;
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
    
    if (self.hero.hardcore) {
        self.hardcoreLabel.hidden = NO;
        self.hardcoreLabel.left = self.titleLabel.left;
        self.hardcoreLabel.top = self.titleLabel.bottom;
        
        self.subtitleLabel.left = self.hardcoreLabel.right + 8.0f;
        self.subtitleLabel.top = self.titleLabel.bottom + 1.0f;
    }
    else {
        self.hardcoreLabel.hidden = YES;
    }
    
    NSString *subtitleString = nil;
    if (self.hero.level == 60) {
        subtitleString = [NSString stringWithFormat:@"%i %@ - Paragon %i",self.hero.level, [self.hero formattedClassName], self.hero.paragonLevel];
    }
    else {
        subtitleString = [NSString stringWithFormat:@"%i %@",self.hero.level, [self.hero formattedClassName]];
    }
    self.subtitleLabel.text = subtitleString;
    
    NSMutableArray *mutOperations = [NSMutableArray array];
    [self.itemButtons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[D3ItemButton class]]) {
            D3ItemButton *button = (D3ItemButton*)obj;
            D3Item *correspondingItem = self.hero.itemsArray[idx];
            if (correspondingItem) {
                // button background logic in [D3ItemButton setItem:...];
                // includes handling gems/sockets
                button.item = correspondingItem;
                
                AFImageRequestOperation *operation = [correspondingItem requestForItemIconWithImageProcessingBlock:^UIImage* (UIImage* image) {
                    if ([UIScreen mainScreen].scale > 1.0f) {
                        CGFloat scale = [UIScreen mainScreen].scale;
                        CGSize doubledSize = CGSizeMake(image.size.width * scale, image.size.height * scale);
                        image = [image resizedToSize:doubledSize];
                    }
                    return image;
                } success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        button.item.icon = image;
                        [button setImage:image forState:UIControlStateNormal];
                        
                        if (button.item == self.hero.mainHand) {
                            [self.offHandButton setImage:self.hero.mainHand.icon forState:UIControlStateNormal];
                            self.offHandButton.alpha = 0.5f;
                        }
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


#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"isFullyLoaded"]) {
        [self setupHero];
    }
}


@end
