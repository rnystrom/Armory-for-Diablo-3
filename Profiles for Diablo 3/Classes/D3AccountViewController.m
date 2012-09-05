//
//  D3AccountViewController.m
//  Profiles for Diablo 3
//
//  Created by Ryan Nystrom on 8/30/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//
//  Lots of hack for orientation...

#import "D3AccountViewController.h"
#import "D3HTTPClient.h"
#import "D3RuneEmitterView.h"
#import "D3Theme.h"
#import "OLGhostAlertView.h"
#import "D3Defines.h"

@interface D3AccountViewController ()

@property (strong, nonatomic) UIView *leftDoor;
@property (strong, nonatomic) UIView *rightDoor;
@property (strong, nonatomic) UIImageView *unlockView;
@property (strong, nonatomic) UITextField *accountTextField;
@property (strong, nonatomic) UIButton *enterAccountButton;
@property (strong, nonatomic) UILabel *accountLabel;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *subtitleLabel;

@end

@implementation D3AccountViewController {
    CGFloat splitWidth;
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
    NSLog(@"did load");
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    self.leftDoor = [[UIView alloc] initWithFrame:CGRectZero];
    self.rightDoor = [[UIView alloc] initWithFrame:CGRectZero];
    [self.leftDoor setBackgroundColor:[UIColor clearColor]];
    [self.rightDoor setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.rightDoor];
    [self.view addSubview:self.leftDoor];
    self.leftDoor.clipsToBounds = NO;
    self.rightDoor.clipsToBounds = NO;
    
    UIImageView *leftDoorImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"left-door"]];
    [self.leftDoor addSubview:leftDoorImage];
    UIImageView *rightDoorImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right-door"]];
    [self.rightDoor addSubview:rightDoorImage];
    
    self.accountTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, kD3AccountTextFieldWidth, kD3AccountTextFieldHeight)];
    [self.accountTextField setBackgroundColor:[UIColor whiteColor]];
    self.accountTextField.placeholder = @"Battletag#1234";
    self.accountTextField.delegate = self;
    self.accountTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.accountTextField.background = [D3Theme cappedTextboxImage];
    self.accountTextField.backgroundColor = [UIColor clearColor];
    self.accountTextField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.accountTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.accountTextField.textColor = [D3Theme whiteItemColor];
    self.accountTextField.font = [D3Theme systemSmallFontWithBold:NO];
    self.accountTextField.textAlignment = UITextAlignmentCenter;
    
    self.enterAccountButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.enterAccountButton.frame = CGRectMake(0, 0, kD3AccountButtonWidth, kD3AccountButtonHeight);
    [self.enterAccountButton setTitle:@"Search" forState:UIControlStateNormal];
    self.enterAccountButton.titleLabel.font = [D3Theme exocetSmallWithBold:NO];
    [self.enterAccountButton addTarget:self action:@selector(onEnterAccount:) forControlEvents:UIControlEventTouchUpInside];
    [self.enterAccountButton setBackgroundImage:[D3Theme cappedDiabloButtonImage] forState:UIControlStateNormal];
    self.enterAccountButton.hidden = NO;
    
    [self.rightDoor addSubview:self.accountTextField];
    [self.rightDoor addSubview:self.enterAccountButton];
    
    self.accountLabel = [D3Theme labelWithFrame:CGRectZero font:[D3Theme exocetLargeWithBold:NO] text:@"battletag"];
    self.accountLabel.textAlignment = UITextAlignmentCenter;
    self.accountLabel.textColor = [D3Theme backgroundColor];
    self.accountLabel.shadowColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.2f];
    self.accountLabel.shadowOffset = CGSizeMake(0, -1);
    [self.rightDoor addSubview:self.accountLabel];
    
    self.titleLabel = [D3Theme labelWithFrame:CGRectZero font:[D3Theme exocetWithFontSize:60.0f bold:YES] text:@"Armory"];
    self.titleLabel.textAlignment = UITextAlignmentCenter;
    [self.rightDoor addSubview:self.titleLabel];
    
    self.subtitleLabel = [D3Theme labelWithFrame:CGRectZero font:[D3Theme systemMediumFontWithBold:NO] text:@"For Diablo 3"];
    self.subtitleLabel.textAlignment = UITextAlignmentCenter;
    [self.rightDoor addSubview:self.subtitleLabel];
    
    self.unlockView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rune"]];
    [self.leftDoor addSubview:self.unlockView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}


- (void) viewDidUnload {
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGSize size = self.view.size;
    splitWidth = size.width / 3.0f;
    CGRect leftDoorFrame = CGRectMake(0, 0, splitWidth, size.height);
    CGRect rightDoorFrame = CGRectMake(splitWidth - 1.0f, 0, size.width - splitWidth, size.height);
    self.leftDoor.frame = leftDoorFrame;
    self.rightDoor.frame = rightDoorFrame;
    
        CGFloat textFieldButtonPadding = 22.0f;
    CGFloat combinedWidth = textFieldButtonPadding + kD3AccountButtonWidth + kD3AccountTextFieldWidth;
    self.accountTextField.center = CGPointMake(rightDoorFrame.size.width / 2.0f - combinedWidth / 2.0f + kD3AccountTextFieldWidth / 2.0f, rightDoorFrame.size.height / 2.0f);
    self.enterAccountButton.center = CGPointMake(rightDoorFrame.size.width / 2.0f + combinedWidth / 2.0f - kD3AccountButtonWidth / 2.0f, rightDoorFrame.size.height / 2.0f);
    
    self.unlockView.center = CGPointMake(splitWidth, size.height / 2.0f);
    
    self.accountLabel.width = self.rightDoor.width;
    self.accountLabel.center = CGPointMake(self.rightDoor.width / 2.0f, self.rightDoor.height / 2.0f - kD3Grid1 - 15.0f);
    
    self.titleLabel.width = self.rightDoor.width;
    self.titleLabel.center = CGPointMake(self.rightDoor.width / 2.0f, kD3Grid3);
    
    self.subtitleLabel.width = self.rightDoor.width;
    self.subtitleLabel.center = CGPointMake(self.rightDoor.width / 2.0f, kD3Grid3 + kD3Grid1 + 10.0f);
}


#pragma mark - Actions

- (void)onEnterAccount:(id)sender {
    [self.accountTextField resignFirstResponder];
    [self findAccount];
}


- (void)findAccount {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicator.center = self.enterAccountButton.center;
    [self.rightDoor addSubview:activityIndicator];
    [self.enterAccountButton setHidden:YES];
    [activityIndicator startAnimating];
    
    NSString *account = self.accountTextField.text;
    [D3Career getCareerForBattletag:account success:^(D3Career *career) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (! career || [career.heroes count] == 0) {
                OLGhostAlertView *av = [[OLGhostAlertView alloc] initWithTitle:@"Error" message:@"No heroes found for account."];
                [av show];
                
                [activityIndicator stopAnimating];
                [activityIndicator removeFromSuperview];
                
                // disable all interaction so animation can complete
                self.accountTextField.enabled = NO;
                self.enterAccountButton.hidden = NO;
                self.enterAccountButton.enabled = NO;
            }
            else {
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                [activityIndicator stopAnimating];
                [activityIndicator removeFromSuperview];
                [self spinRune];
            }
        });
    } failure:^(NSHTTPURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSInteger code = response.statusCode != 0 ? response.statusCode : error.code;
            if (error.code > 100) {
                code = error.code;
            }
            OLGhostAlertView *av = [[OLGhostAlertView alloc] initWithTitle:errorTitleForStatusCode(code) message:errorMessageForStatusCode(code)];
            [av show];
            
            [activityIndicator stopAnimating];
            [activityIndicator removeFromSuperview];
            self.enterAccountButton.hidden = NO;
        });
    }];
}


- (void)spinRune {
    D3RuneEmitterView *emitter = [[D3RuneEmitterView alloc] initWithPathFromImageView:self.unlockView];
    emitter.center = self.unlockView.center;
    [self.leftDoor insertSubview:emitter belowSubview:self.unlockView];
    [emitter enableEmitter];
    
    [UIView animateWithDuration:kD3RuneSpinDuration
                          delay:1.0f
                        options:kNilOptions
                     animations:^{
                         self.unlockView.transform = CGAffineTransformMakeRotation(M_PI / 2.0f);
                     }
                     completion:^(BOOL finished){
                         if (finished) {
                             [self openDoors];
                         }
                     }];
}


- (void)openDoors {
    CGRect leftFrame = self.leftDoor.frame;
    CGRect rightFrame = self.rightDoor.frame;
    leftFrame.origin.x = -leftFrame.size.width - self.unlockView.frame.size.width / 2.0f;
    rightFrame.origin.x = self.view.width;
    
    [UIView animateWithDuration:kD3DoorsOpenDuration
                          delay:0
                        options:kNilOptions
                     animations:^{
                         self.leftDoor.frame = leftFrame;
                         self.rightDoor.frame = rightFrame;
                     }
                     completion:^(BOOL finished){
                         if (finished) {
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 // this tells the system that we are done
                                 [[NSNotificationCenter defaultCenter] postNotificationName:kD3DoorsAnimatedOffScreenNotification object:self];
                             });
                         }
                     }];
}


#pragma mark - UITextField

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.accountTextField resignFirstResponder];
    [self findAccount];
    return YES;
}


#pragma mark - Notifications

- (void)keyboardWillShow:(NSNotification*)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSValue *boundsValue = [userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey];
    if (boundsValue) {
        CGRect keyboardRect = CGRectZero;
        [boundsValue getValue:&keyboardRect];
        CGFloat keyboardHeight = keyboardRect.size.width;
        CGFloat adjustmentHeght = keyboardHeight / 2.0f;
        CGRect newFrame = self.view.frame;
        newFrame.origin.y = -1.0f * adjustmentHeght;
        
        [UIView animateWithDuration:kD3SystemAnimationDuration
                              delay:0
                            options:kNilOptions
                         animations:^{
                             self.view.frame = newFrame;
                         }
                         completion:^(BOOL finished){
                             
                         }];
    }
}


- (void)keyboardWillHide:(NSNotification*)notification {
    CGRect newFrame = self.view.frame;
    newFrame.origin.y = 0;
    
    [UIView animateWithDuration:kD3SystemAnimationDuration
                          delay:0
                        options:kNilOptions
                     animations:^{
                         self.view.frame = newFrame;
                     }
                     completion:^(BOOL finished){
                         
                     }];
}


@end
