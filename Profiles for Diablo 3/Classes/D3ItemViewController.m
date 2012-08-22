//
//  D3ItemViewController.m
//  Profiles for Diablo 3
//
//  Created by Ryan Nystrom on 8/16/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

#import "D3ItemViewController.h"
#import "D3Theme.h"

@interface D3ItemViewController ()

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *valueLabel;
@property (strong, nonatomic) UILabel *valueUnitLabel;
@property (strong, nonatomic) UILabel *weaponInfoLabel;
@property (strong, nonatomic) UILabel *attributesLabel;
@property (strong, nonatomic) UILabel *flavorLabel;
@property (strong, nonatomic) UILabel *requiredLevelLabel;
@property (strong, nonatomic) UILabel *itemLevelLabel;
@property (strong, nonatomic) UILabel *setNameLabel;
@property (strong, nonatomic) UILabel *setItemsLabel;
@property (strong, nonatomic) UILabel *setBonusesLabel;
@property (strong, nonatomic) UILabel *typeLabel;

@property (strong, nonatomic) NSArray *labelsArray;

@end

@implementation D3ItemViewController

#pragma mark - Class Helpers

+ (UILabel*)labelForView:(UIView*)view frame:(CGRect)frame{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    [label setNumberOfLines:0];
    [label setAdjustsFontSizeToFitWidth:YES];
    [label setBackgroundColor:[UIColor clearColor]];
    [view addSubview:label];
    return label;
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.width = kD3CardWidth;
    [self.view setBackgroundColor:[UIColor blackColor]];
    CGSize frameSize = self.view.frame.size;
    
    CGFloat padding = kD3Grid1;
    
    CGFloat rightofImageY = padding;
    
    self.titleLabel = [D3ItemViewController labelForView:self.view frame:CGRectMake(padding, kD3Grid1 / 4.0f, frameSize.width - 2.0f * padding, kD3LargeFontSize)];
    [self.titleLabel setFont:[D3Theme exocetLargeWithBold:YES]];
    [self.titleLabel setTextColor:self.item.displayColor];
    [self.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [self.titleLabel setNumberOfLines:1];
    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];

    self.valueLabel = [D3ItemViewController labelForView:self.view frame:CGRectMake(rightofImageY, 0.0f, frameSize.width - rightofImageY - padding, 0.0f)];
    [self.valueLabel setFont:[D3Theme titleFontWithSize:kD3TitleFontSize bold:NO]];
    [self.valueLabel setTextColor:[UIColor whiteColor]];
    
    self.typeLabel = [D3ItemViewController labelForView:self.view frame:CGRectMake(rightofImageY, 0.0f, frameSize.width - rightofImageY - padding, 0.0f)];
    [self.typeLabel setFont:[D3Theme systemSmallFontWithBold:NO]];
    [self.typeLabel setTextColor:[UIColor grayColor]];
    [self.typeLabel setTextAlignment:NSTextAlignmentRight];
    
    self.valueUnitLabel = [D3ItemViewController labelForView:self.view frame:CGRectMake(rightofImageY, 0.0f, frameSize.width - rightofImageY - padding, 0.0f)];
    [self.valueUnitLabel setFont:[D3Theme systemSmallFontWithBold:NO]];
    [self.valueUnitLabel setTextColor:[UIColor grayColor]];
    
    self.attributesLabel = [D3ItemViewController labelForView:self.view frame:CGRectMake(padding, 0.0f, frameSize.width - padding * 2.0f, 0.0f)];
    [self.attributesLabel setFont:[D3Theme systemSmallFontWithBold:NO]];
    [self.attributesLabel setTextColor:[UIColor blueColor]];
    [self.view addSubview:self.attributesLabel];
    
    self.setNameLabel = [D3ItemViewController labelForView:self.view frame:CGRectMake(rightofImageY, 0.0f, frameSize.width - rightofImageY - padding, 0.0f)];
    [self.setNameLabel setFont:[D3Theme systemSmallFontWithBold:NO]];
    [self.setNameLabel setTextColor:[UIColor grayColor]];
    
    self.setItemsLabel = [D3ItemViewController labelForView:self.view frame:CGRectMake(padding, 0.0f, frameSize.width - padding * 2.0f, 0.0f)];
    [self.setItemsLabel setFont:[D3Theme systemSmallFontWithBold:NO]];
    [self.setItemsLabel setTextColor:[UIColor grayColor]];
    
    self.setBonusesLabel = [D3ItemViewController labelForView:self.view frame:CGRectMake(padding, 0.0f, frameSize.width - padding * 2.0f, 0.0f)];
    [self.setBonusesLabel setFont:[D3Theme systemSmallFontWithBold:NO]];
    [self.setBonusesLabel setTextColor:[UIColor grayColor]];
    
    self.flavorLabel = [D3ItemViewController labelForView:self.view frame:CGRectMake(padding, 0.0f, frameSize.width - padding * 2.0f, 0.0f)];
    [self.flavorLabel setFont:[D3Theme systemFontSize:kD3SmallFontSize serif:NO bold:NO italic:YES]];
    [self.flavorLabel setTextColor:[UIColor orangeColor]];
    
    self.requiredLevelLabel = [D3ItemViewController labelForView:self.view frame:CGRectMake(padding, 0.0f, frameSize.width - padding * 2.0f, 0.0f)];
    [self.requiredLevelLabel setFont:[D3Theme systemSmallFontWithBold:NO]];
    [self.requiredLevelLabel setTextColor:[UIColor whiteColor]];
    [self.requiredLevelLabel setTextAlignment:NSTextAlignmentRight];
    
    self.itemLevelLabel = [D3ItemViewController labelForView:self.view frame:CGRectMake(padding, 0.0f, frameSize.width - padding * 2.0f, 0.0f)];
    [self.itemLevelLabel setFont:[D3Theme systemSmallFontWithBold:NO]];
    [self.itemLevelLabel setTextColor:[UIColor whiteColor]];
    [self.itemLevelLabel setTextAlignment:NSTextAlignmentLeft];
    
    self.labelsArray = @[
    self.valueLabel,
    self.valueUnitLabel,
    self.attributesLabel,
    self.setNameLabel,
    self.setItemsLabel,
    self.setBonusesLabel,
    self.flavorLabel
    ];
}


#pragma mark - Helpers

- (void)populateView {
    [self.titleLabel setText:self.item.name];
    [self.valueLabel setText:self.item.displayValue];
    [self.valueUnitLabel setText:self.item.displayValueUnit];
    [self.requiredLevelLabel setText:self.item.requiredLevelString];
    [self.flavorLabel setText:self.item.flavorText];
    [self.itemLevelLabel setText:self.item.itemLevelString];
    [self.typeLabel setText:self.item.typeString];
    
    if (self.item.isPartOfSet) {
        [self.setNameLabel setText:self.item.setName];
        [self.setItemsLabel setText:[self.item setItemsFormattedString]];
        [self.setBonusesLabel setText:[self.item setBonusesFormattedString]];
    }
    
    NSMutableString *attributeString = [NSMutableString string];
    [self.item.attributes enumerateObjectsUsingBlock:^(NSString *attribute, NSUInteger idx, BOOL *stop){
        if (idx == 0) {
            [attributeString appendFormat:@"%@",attribute];
        }
        else {
            [attributeString appendFormat:@"\n%@",attribute];
        }
    }];
    [self.attributesLabel setText:attributeString];
    
    __block CGFloat runningY = self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height;
    CGFloat padding = kD3Grid1 / 4.0f;
    
    // dynamically adjust height of labels that should stack into order
    // casting as UILabel because we created the array in -viewDidLoad
    [self.labelsArray enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop){
        [label autoHeight];
        
        CGRect labelFrame = label.frame;
        labelFrame.size.height = labelFrame.size.height;
//        if (label == self.titleLabel) {
//            CGRect iconFrame = self.iconView.frame;
//            iconFrame.origin.y = labelFrame.size.height + labelFrame.origin.y;
//            [self.iconView setFrame:iconFrame];
//        }
//        if (label == self.valueLabel) {
//            runningY = self.iconView.frame.origin.y;
//        }
//        if (label == self.attributesLabel && runningY < (self.iconView.frame.size.height + self.iconView.frame.origin.y)) {
//            runningY = self.iconView.frame.size.height + self.iconView.frame.origin.y + padding;
//        }
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
    
    // set item level label
    [self.typeLabel autoHeight];
    CGRect typeFrame = self.typeLabel.frame;
    typeFrame.origin.y = self.valueLabel.frame.origin.y;
    [self.typeLabel setFrame:typeFrame];
}


#pragma mark - Setters

- (void)setItem:(D3Item *)item {
    _item = item;
    if (item.isFullyLoaded) {
        [self populateView];
    }
    else {
        [item finishLoadingWithSuccess:^(D3Item *loadedItem) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self populateView];
            });
        } failure:^(NSError *error) {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [av show];
        }];
    }
}

@end
