//
//  D3ViewController.h
//  Profiles for Diablo 3
//
//  Created by Ryan Nystrom on 8/17/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "D3Theme.h"

@interface D3ViewController : UIViewController

@property (strong, nonatomic, readonly) NSArray *requestOperations;

- (void)addOperation:(AFHTTPRequestOperation*)operation;
- (void)addOperations:(NSArray*)operations;
- (void)cancelAllOperations;

@end
