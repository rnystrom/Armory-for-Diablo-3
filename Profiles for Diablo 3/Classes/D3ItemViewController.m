//
//  D3ItemViewController.m
//  Profiles for Diablo 3
//
//  Created by Ryan Nystrom on 8/16/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

#import "D3ItemViewController.h"

@interface D3ItemViewController ()

@property (strong, nonatomic) UIView *itemContainerView;

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *valueLabel;
@property (strong, nonatomic) UILabel *valueUnitLabel;
@property (strong, nonatomic) UILabel *attributesLabel;
@property (strong, nonatomic) UILabel *flavorLabel;
@property (strong, nonatomic) UILabel *requiredLevelLabel;
@property (strong, nonatomic) UILabel *itemLevelLabel;
@property (strong, nonatomic) UILabel *setNameLabel;
@property (strong, nonatomic) UILabel *setItemsLabel;
@property (strong, nonatomic) UILabel *setBonusesLabel;
@property (strong, nonatomic) UILabel *typeLabel;

@property (strong, nonatomic) NSArray *labelsArray;

@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation D3ItemViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.itemContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    self.itemContainerView.backgroundColor = [UIColor clearColor];
    self.itemContainerView.alpha = 0.0f;
    [self.view addSubview:self.itemContainerView];
    
    CGSize screenSize = [UIApplication currentSize];
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicator.center = CGPointMake(self.view.width / 2.0f, screenSize.height / 2.0f);
    [self.activityIndicator startAnimating];
    [self.view addSubview:self.activityIndicator];
    
    self.backgroundImage = [UIImage imageNamed:@"dark-bg"];
    CGSize frameSize = self.view.frame.size;
    CGFloat padding = kD3Grid1;
    CGFloat textWidth = frameSize.width / 1.7f;
    CGRect textFrame = CGRectMake(padding, 0.0f, textWidth, 0.0f);
    CGRect lowTextFrame = CGRectMake(padding, 0.0f, self.view.width - padding * 2.0f, 0.0f);

    self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.itemContainerView addSubview:self.imageView];
    
    self.titleLabel = [D3Theme labelWithFrame:CGRectMake(padding, kD3TopPadding, frameSize.width - 2.0f * padding, 0)
                                         font:[D3Theme exocetLargeWithBold:YES]
                                         text:@"Title"];
    [self.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [self.titleLabel setNumberOfLines:1];
    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.itemContainerView addSubview:self.titleLabel];
    
    self.typeLabel = [D3Theme labelWithFrame:CGRectMake(padding, self.titleLabel.bottom, frameSize.width - 2.0f * padding, 0)
                                        font:[D3Theme systemSmallFontWithBold:NO]
                                        text:@"Type"];
    [self.typeLabel setTextAlignment:NSTextAlignmentCenter];
    [self.itemContainerView addSubview:self.typeLabel];

    self.valueLabel = [D3Theme labelWithFrame:textFrame
                                         font:[D3Theme titleFontWithSize:kD3TitleFontSize bold:NO]
                                         text:@"0.0"];
    [self.itemContainerView addSubview:self.valueLabel];
    
    self.valueUnitLabel = [D3Theme labelWithFrame:textFrame
                                             font:[D3Theme systemSmallFontWithBold:NO]
                                             text:@"Unit"];
    [self.itemContainerView addSubview:self.valueUnitLabel];

    self.attributesLabel = [D3Theme labelWithFrame:textFrame
                                             font:[D3Theme systemSmallFontWithBold:NO]
                                             text:@""];
    [self.attributesLabel setTextColor:[D3Theme blueItemColor]];
    [self.itemContainerView addSubview:self.attributesLabel];
    
    self.setNameLabel = [D3Theme labelWithFrame:textFrame
                                              font:[D3Theme systemSmallFontWithBold:NO]
                                              text:@""];
    [self.setNameLabel setTextColor:[UIColor lightGrayColor]];
    [self.itemContainerView addSubview:self.setNameLabel];
    
    self.setItemsLabel = [D3Theme labelWithFrame:textFrame
                                           font:[D3Theme systemSmallFontWithBold:NO]
                                           text:@""];
    [self.setItemsLabel setTextColor:[UIColor lightGrayColor]];
    [self.itemContainerView addSubview:self.setItemsLabel];
    
    self.setBonusesLabel = [D3Theme labelWithFrame:lowTextFrame
                                              font:[D3Theme systemSmallFontWithBold:NO]
                                              text:@""];
    [self.setBonusesLabel setTextColor:[UIColor lightGrayColor]];
    [self.itemContainerView addSubview:self.setBonusesLabel];
    
    self.flavorLabel = [D3Theme labelWithFrame:lowTextFrame
                                              font:[D3Theme systemFontSize:kD3SmallFontSize serif:NO bold:NO italic:YES]
                                              text:@""];
    [self.flavorLabel setTextColor:[UIColor orangeColor]];
    [self.itemContainerView addSubview:self.flavorLabel];
    
    self.itemLevelLabel = [D3Theme labelWithFrame:lowTextFrame
                                             font:[D3Theme systemSmallFontWithBold:NO]
                                             text:@""];
    [self.itemContainerView addSubview:self.itemLevelLabel];
    
    self.requiredLevelLabel = [D3Theme labelWithFrame:lowTextFrame
                                              font:[D3Theme systemSmallFontWithBold:NO]
                                              text:@""];
    self.requiredLevelLabel.textAlignment = NSTextAlignmentRight;
    [self.itemContainerView addSubview:self.requiredLevelLabel];
    
    self.labelsArray = @[
    self.valueLabel,
    self.valueUnitLabel,
    self.attributesLabel,
    self.setNameLabel,
    self.setItemsLabel,
    self.setBonusesLabel
    ];
}


#pragma mark - Helpers

- (void)populateView {
    CGSize iconSize = self.item.icon.size;
    CGFloat aspectRatio = iconSize.height / iconSize.width;
    CGRect imageFrame = self.imageView.frame;
    imageFrame.size = CGSizeMake(kD3Grid5, kD3Grid5 * aspectRatio);
    imageFrame.origin = CGPointMake(kD3Grid1 * 8.0f, kD3Grid2);
    self.imageView.frame = imageFrame;
    self.imageView.image = self.item.icon;
    
    [self.titleLabel setText:self.item.name];
    [self.requiredLevelLabel setText:self.item.requiredLevelString];
    [self.flavorLabel setText:self.item.flavorText];
    [self.itemLevelLabel setText:self.item.itemLevelString];
    [self.typeLabel setText:self.item.typeString];
    
    self.titleLabel.textColor = self.item.displayColor;
    
    if ([self.item isQuiver]) {
        [self.valueLabel setText:@""];
        [self.valueUnitLabel setText:@""];
    }
    else {
        [self.valueLabel setText:self.item.displayValue];
        [self.valueUnitLabel setText:self.item.displayValueUnit];
    }
    
    if (self.item.isPartOfSet) {
        [self.setNameLabel setText:self.item.setName];
        [self.setItemsLabel setText:[self.item setItemsFormattedString]];
        [self.setBonusesLabel setText:[self.item setBonusesFormattedString]];
    }
    
    NSString *attributeString = [self.item.attributes componentsJoinedByString:@"\n"];
    [self.attributesLabel setText:attributeString];
    
    __block CGFloat runningY = kD3Grid2;
    CGFloat padding = kD3Grid1 / 4.0f;
    
    // dynamically adjust height of labels that should stack into order
    // casting as UILabel because we created the array in -viewDidLoad
    [self.labelsArray enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop){
        [label autoHeight];
        
        CGRect labelFrame = label.frame;
        labelFrame.size.height = labelFrame.size.height;
        labelFrame.origin.y = runningY;
        runningY += labelFrame.size.height + padding;
        [label setFrame:labelFrame];
    }];
    
    // set required level label
    [self.requiredLevelLabel autoHeight];
    CGRect requiredFrame = self.requiredLevelLabel.frame;
    requiredFrame.origin.y = self.view.height - requiredFrame.size.height - kD3Grid1;
    [self.requiredLevelLabel setFrame:requiredFrame];
    
    // set item level label
    [self.itemLevelLabel autoHeight];
    CGRect itemLevelFrame = self.itemLevelLabel.frame;
    itemLevelFrame.origin.y = self.view.height - itemLevelFrame.size.height - kD3Grid1;
    [self.itemLevelLabel setFrame:itemLevelFrame];
    
    [self.flavorLabel autoHeight];
    CGRect flavorFrame = self.flavorLabel.frame;
    flavorFrame.origin.y = self.itemLevelLabel.top - flavorFrame.size.height - kD3Grid1;
    self.flavorLabel.frame = flavorFrame;
    
    [self.activityIndicator stopAnimating];
    [self.activityIndicator removeFromSuperview];
    [UIView animateWithDuration:0.25f
                          delay:0
                        options:kNilOptions
                     animations:^{
                         self.itemContainerView.alpha = 1.0f;
                     }
                     completion:NULL];
}


#pragma mark - Setters

- (void)setItem:(D3Item *)item {
    _item = item;
    if (item.isFullyLoaded) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self populateView];
        });
    }
    else {
        [item addObserver:self forKeyPath:@"isFullyLoaded" options:NSKeyValueObservingOptionNew context:NULL];
    }
}


#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"isFullyLoaded"]) {
        [self populateView];
    }
}

@end
