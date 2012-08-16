//
//  D3HTTPClient.m
//  Profiles for Diablo 3
//
//  Created by Ryan Nystrom on 8/15/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

#import "D3HTTPClient.h"

@implementation D3HTTPClient {
    dispatch_queue_t _callbackQueue;
}

#pragma mark - Singleton

+ (D3HTTPClient*)sharedClient {
	static D3HTTPClient *sharedClient = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedClient = [[[self class] alloc] initWithBaseURL:[NSURL URLWithString:kD3BaseURL]];
	});
	return sharedClient;
}


#pragma mark - NSObject

- (id)init {
    if (self = [super init]) {
        _callbackQueue = dispatch_queue_create("com.nystromproductions.profiles.network-callback-queue", 0);
    }
    return self;
}


- (void)dealloc {
    dispatch_release(_callbackQueue);
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - AFHTTPClient

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters {
	NSMutableURLRequest *request = [super requestWithMethod:method path:path parameters:parameters];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
#ifdef D3_LOGGING_MODE
    NSLog(@"%@",request.URL);
#endif
	return request;
}


- (void)enqueueHTTPRequestOperation:(AFHTTPRequestOperation *)operation {
	operation.successCallbackQueue = _callbackQueue;
	operation.failureCallbackQueue = _callbackQueue;
	[super enqueueHTTPRequestOperation:operation];
}


#pragma mark - Career

- (void)getCareerWithAccount:(NSString*)account success:(void (^)(AFJSONRequestOperation *operation, id responseObject))success failure:(void (^)(AFJSONRequestOperation *operation, NSError *error))failure {
    // fail immediately if our account name does not have a #-sign in it
    if (! [D3Career accountNameIsValid:account]) {
        if (failure) {
            NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
            [errorDetail setValue:@"A valid account name and number is required." forKey:NSLocalizedDescriptionKey];
            NSError *error = [[NSError alloc] initWithDomain:@"com.nystromproductions.error" code:100 userInfo:errorDetail];
            failure(NULL, error);
        }
    }
    else {
        NSString *careerPath = [D3Career apiParamFromAccount:account];
        
        [self getPath:careerPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (success) {
                success((AFJSONRequestOperation *)operation, responseObject);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (failure) {
                failure((AFJSONRequestOperation *)operation, error);
            }
        }];
    }
}


#pragma mark - Hero

- (void)getHeroWithID:(NSInteger)ID success:(void (^)(AFJSONRequestOperation *operation, id responseObject))success failure:(void (^)(AFJSONRequestOperation *operation, NSError *error))failure {
    NSString *careerParam = [D3Career apiParamFromAccount:self.career.battleTag];
    NSString *heroParam = [NSString stringWithFormat:@"%@/%@/%i",careerParam,kD3APIHeroParam,ID];
    [[D3HTTPClient sharedClient] getPath:heroParam parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success((AFJSONRequestOperation *)operation, responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure((AFJSONRequestOperation *)operation, error);
        }
    }];
}


@end