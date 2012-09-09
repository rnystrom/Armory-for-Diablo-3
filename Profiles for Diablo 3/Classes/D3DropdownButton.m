//
//  D3DropdownButton.m
//  Profiles for Diablo 3
//
//  Created by Ryan Nystrom on 9/8/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

#import "D3DropdownButton.h"
#import "D3Theme.h"

@interface D3DropdownButton ()

@property (strong, nonatomic) UIImageView *backgroundView;
@property (strong, nonatomic) UIButton *toggleButton;
@property (strong, nonatomic) NSArray *buttons;

@end

@implementation D3DropdownButton {
    CGFloat buttonHeight;
    CGFloat totalHeight;
    BOOL isToggled;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        buttonHeight = frame.size.height;
        isToggled = NO;
        
        self.backgroundView = [[UIImageView alloc] init];
        self.backgroundView.image = [D3Theme cappedNoFlareDiabloButtonImage];
        self.backgroundView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:self.backgroundView];
        
        self.clipsToBounds = YES;
        
        self.toggleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.toggleButton.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        self.toggleButton.titleLabel.font = [D3Theme exocetSmallWithBold:NO];
        [self.toggleButton addTarget:self action:@selector(onToggleButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.toggleButton];
    }
    return self;
}

- (void)setupView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(numberOfRows)]) {
        NSInteger numberOfButtons = [self.delegate numberOfRows];

        // set the total size that the view should expand to
        totalHeight = buttonHeight * numberOfButtons;
        
        // add buttons to view
        NSMutableArray *mutButtons = [NSMutableArray array];
        for (int i = 0; i < numberOfButtons; ++i) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, i * buttonHeight, self.width, buttonHeight);
            if ([self.delegate respondsToSelector:@selector(titleForButtonAtIndex:)]) {
                [button setTitle:[self.delegate titleForButtonAtIndex:i] forState:UIControlStateNormal];
                
                // set our toggle label
                if (i == 0) {
                    [self.toggleButton setTitle:[self.delegate titleForButtonAtIndex:i] forState:UIControlStateNormal];
                }
            }
            [button addTarget:self action:@selector(onSelectionButton:) forControlEvents:UIControlEventTouchUpInside];
            button.titleLabel.font = [D3Theme exocetSmallWithBold:NO];
            button.tag = i;
            // hide all buttons, toggled
            button.hidden = YES;
            [mutButtons addObject:button];
            [self addSubview:button];
        }
        self.buttons = mutButtons;
    }
}


- (void)onToggleButton:(id)sender {
    if (isToggled) {    // close toggle
        self.frame = CGRectMake(self.left, self.top, self.width, buttonHeight);
    }
    else {              // open toggle
        self.frame = CGRectMake(self.left, self.top, self.width, totalHeight);
    }
    isToggled = ! isToggled;
    self.toggleButton.hidden = isToggled;
    [self.buttons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
        button.hidden = ! isToggled;
    }];
}


- (void)onSelectionButton:(id)sender {
    NSInteger tag = ((UIButton*)sender).tag;
    if ([self.delegate respondsToSelector:@selector(didSelectButtonAtIndex:)]) {
        [self.delegate didSelectButtonAtIndex:tag];
    }
    [self onToggleButton:sender];
    [self.toggleButton setTitle:[self.delegate titleForButtonAtIndex:tag] forState:UIControlStateNormal];
    self.selectedIndex = tag;
}


- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.backgroundView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
}


- (void)setDelegate:(NSObject<D3DropdownButtonProtocol> *)delegate {
    _delegate = delegate;
    [self setupView];
}


@end
