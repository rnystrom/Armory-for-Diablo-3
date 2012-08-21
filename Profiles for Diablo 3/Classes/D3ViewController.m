//
//  D3ViewController.m
//  Profiles for Diablo 3
//
//  Created by Ryan Nystrom on 8/17/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

#import "D3ViewController.h"

@interface D3ViewController ()

@property (strong, nonatomic) NSArray *requestOperations;

@end

@implementation D3ViewController

- (void)addOperation:(AFHTTPRequestOperation *)operation {
    if (! self.requestOperations) {
        self.requestOperations = [NSArray array];
    }
    if (! [self.requestOperations containsObject:operation] && [operation isMemberOfClass:[NSOperation class]]) {
        NSMutableArray *mutOperations = [self.requestOperations mutableCopy];
        [mutOperations addObject:operation];
        self.requestOperations = [mutOperations copy];
    }
}


- (void)addOperations:(NSArray*)operations {
    if ([operations isMemberOfClass:[NSArray class]] && [operations count] > 0) {
        [operations enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [self addOperation:obj];
        }];
    }
}


- (void)cancelAllOperations {
    if (self.requestOperations && [self.requestOperations count] > 0) {
        [self.requestOperations enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isMemberOfClass:[NSOperation class]]) {
                [(NSOperation*)obj cancel];
            }
        }];
    }
    self.requestOperations = [NSArray array];
}

@end
