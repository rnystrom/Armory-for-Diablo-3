//
//  D3DropdownButton.h
//  Profiles for Diablo 3
//
//  Created by Ryan Nystrom on 9/8/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol D3DropdownButtonProtocol <NSObject>

- (NSInteger)numberOfRows;
- (NSString*)titleForButtonAtIndex:(NSInteger)index;
- (void)didSelectButtonAtIndex:(NSInteger)index;

@end

@interface D3DropdownButton : UIView

@property (weak, nonatomic) NSObject <D3DropdownButtonProtocol> *delegate;
@property (assign, nonatomic) NSInteger selectedIndex;

@end
