//
//  D3ItemButton.m
//  Profiles for Diablo 3
//
//  Created by Ryan Nystrom on 8/15/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

#import "D3ItemButton.h"
#import <QuartzCore/QuartzCore.h>

@interface D3ItemButton()

@end

@implementation D3ItemButton

#pragma mark - Helpers

- (void)setupView {
    CALayer *layer = self.layer;
    layer.shadowColor = self.item.displayColor.CGColor;
    layer.shadowOffset = CGSizeZero;
    layer.shadowRadius = 10.0f;
    layer.shadowOpacity = 1.0f;
    layer.shouldRasterize = YES;
    
    if (self.item.sockets > 0) {
        CGSize socketImageSize = [UIImage imageNamed:@"socket"].size;
        CGFloat socketHeight = socketImageSize.height / 2.0f * self.item.sockets;
        CGPoint center = CGPointMake(self.frame.size.width / 2.0f, self.frame.size.height / 2.0f - socketHeight / 2.0f);
        NSMutableArray *socketViews = [NSMutableArray array];
        for (int i = 0; i < self.item.sockets; ++i) {
            UIImageView *socketView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, socketImageSize.width, socketImageSize.height)];
            socketView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"socket"]];
            socketView.center = center;
            [self addSubview:socketView];
            [socketViews addObject:socketView];
            
            center.y += socketImageSize.height;
        }
        NSMutableArray *socketImageRequests = [NSMutableArray array];
        [self.item.gems enumerateObjectsUsingBlock:^(D3Gem *gem, NSUInteger idx, BOOL *stop) {
            // no failure handling, just leave it blank
            // no image processing because the API returns a 64x64 image (only need 32x32)
            AFImageRequestOperation *operation = [gem requestGemIconWithImageProcessingBlock:NULL success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIImageView *socketView = socketViews[idx];
                    socketView.image = image;
                });
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
#ifdef D3_LOGGING_MODE
                NSLog(@"Request: %@\nError: %@\nResponse: %@",request.URL,error.localizedDescription,response);
#endif
            }];
            if (operation) {
                [socketImageRequests addObject:operation];
            }
        }];
        // no completion handling
        [[D3HTTPClient sharedClient] enqueueBatchOfHTTPRequestOperations:socketImageRequests progressBlock:NULL completionBlock:NULL];
    }
}


#pragma mark - Setters

- (void)setItem:(D3Item *)item {
    _item = item;
    if (item.isFullyLoaded) {
        [self setupView];
    }
    else {
        [item addObserver:self forKeyPath:@"isFullyLoaded" options:NSKeyValueObservingOptionNew context:NULL];
    }
}


#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"isFullyLoaded"]) {
        [self setupView];
    }
}


@end
