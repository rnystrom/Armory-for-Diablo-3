//
//  D3AccountView.m
//  Profiles for Diablo 3
//
//  Created by Ryan Nystrom on 8/15/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

#import "D3AccountView.h"
#import "D3HTTPClient.h"
#import "D3RuneEmitterView.h"

@interface D3AccountView()
@property (strong, nonatomic) UIView *leftDoor;
@property (strong, nonatomic) UIView *rightDoor;
@property (strong, nonatomic) UIImageView *unlockView;
@property (strong, nonatomic) UITextField *accountTextField;
@property (strong, nonatomic) UIButton *enterAccountButton;
@end

@implementation D3AccountView {
    CGFloat splitWidth;
}

#pragma mark - View lifecycle

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
        self.backgroundColor = [UIColor clearColor];
        splitWidth = frame.size.width / 3.0f;
        CGRect leftDoorFrame = CGRectMake(0, 0, splitWidth, frame.size.height);
        CGRect rightDoorFrame = CGRectMake(splitWidth, 0, frame.size.width - splitWidth, self.frame.size.height);
        self.leftDoor = [[UIView alloc] initWithFrame:leftDoorFrame];
        self.rightDoor = [[UIView alloc] initWithFrame:rightDoorFrame];
        [self.leftDoor setBackgroundColor:[UIColor redColor]];
        [self.rightDoor setBackgroundColor:[UIColor grayColor]];
        [self addSubview:self.rightDoor];
        [self addSubview:self.leftDoor];
        
        CGFloat textFieldButtonPadding = 22.0f;
        self.accountTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, kD3AccountTextFieldWidth, kD3AccountTextFieldHeight)];
        [self.accountTextField setBackgroundColor:[UIColor whiteColor]];
        self.accountTextField.placeholder = @"AccountName#1234";
        self.accountTextField.delegate = self;
        
        self.enterAccountButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.enterAccountButton.frame = CGRectMake(0, 0, kD3AccountButtonWidth, kD3AccountButtonHeight);
        [self.enterAccountButton setTitle:@"Search" forState:UIControlStateNormal];
        [self.enterAccountButton addTarget:self action:@selector(onEnterAccount:) forControlEvents:UIControlEventTouchUpInside];
        
        CGFloat combinedWidth = textFieldButtonPadding + kD3AccountButtonWidth + kD3AccountTextFieldWidth;
        self.accountTextField.center = CGPointMake(rightDoorFrame.size.width / 2.0f - combinedWidth / 2.0f + kD3AccountTextFieldWidth / 2.0f, rightDoorFrame.size.height / 2.0f);
        self.enterAccountButton.center = CGPointMake(rightDoorFrame.size.width / 2.0f + combinedWidth / 2.0f - kD3AccountButtonWidth / 2.0f, rightDoorFrame.size.height / 2.0f);
        [self.rightDoor addSubview:self.accountTextField];
        [self.rightDoor addSubview:self.enterAccountButton];
        
        self.unlockView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rune"]];
        self.unlockView.center = CGPointMake(splitWidth, frame.size.height / 2.0f);
        [self.leftDoor addSubview:self.unlockView];
    }
    return self;
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    [D3Career getCareerForAccount:account success:^(D3Career *career) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            [activityIndicator stopAnimating];
            [activityIndicator removeFromSuperview];
            NSLog(@"%i",[career.heroes count]);
            [self spinRune];
        });
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
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
    rightFrame.origin.x = self.frame.size.width;
    
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
        CGRect newFrame = self.frame;
        newFrame.origin.y = -1.0f * adjustmentHeght;
        
        [UIView animateWithDuration:kD3SystemAnimationDuration
                              delay:0
                            options:kNilOptions
                         animations:^{
                             self.frame = newFrame;
                         }
                         completion:^(BOOL finished){
                             
                         }];
    }
}


- (void)keyboardWillHide:(NSNotification*)notification {
    CGRect newFrame = self.frame;
    newFrame.origin.y = 0;
    
    [UIView animateWithDuration:kD3SystemAnimationDuration
                          delay:0
                        options:kNilOptions
                     animations:^{
                         self.frame = newFrame;
                     }
                     completion:^(BOOL finished){
                         
                     }];
}

@end
