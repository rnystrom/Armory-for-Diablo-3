//
//  D3Defines.m
//  Profiles for Diablo 3
//
//  Created by Ryan Nystrom on 9/4/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

#import "D3Defines.h"

#pragma mark - Notifications

NSString * const kD3ShouldResetNotification = @"com.nystromproductions.profiles.app-should-reset";

#pragma mark - Keys

NSString * const kD3PreviouslyLoggedCareer = @"com.nystromproductions.profiles.previously-logged-career";
NSString * const kD3PreviouslyLoggedRegion = @"com.nystromproductions.profiles.previously-logged-region";

#pragma mark - Helpers

NSString * errorTitleForStatusCode(NSInteger statusCode) {
    NSString *statusCodeString = [NSString stringWithFormat:@"%i",statusCode];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"StatusCodeErrors" ofType:@"plist"];
    NSDictionary *statusCodes = [NSDictionary dictionaryWithContentsOfFile:path];
    NSDictionary *errorHandle = statusCodes[statusCodeString];
    if (errorHandle) {
        NSString *title = errorHandle[@"title"];
        if (title) {
            return title;
        }
    }
    return @"Unknown Error";
}


NSString * errorMessageForStatusCode(NSInteger statusCode) {
    NSString *statusCodeString = [NSString stringWithFormat:@"%i",statusCode];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"StatusCodeErrors" ofType:@"plist"];
    NSDictionary *statusCodes = [NSDictionary dictionaryWithContentsOfFile:path];
    NSDictionary *errorHandle = statusCodes[statusCodeString];
    if (errorHandle) {
        NSString *message = errorHandle[@"message"];
        if (message) {
            return message;
        }
    }
    return @"An unknown error has occured. Please try again later.";
}