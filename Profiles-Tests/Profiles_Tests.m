//
//  Profiles_Tests.m
//  Profiles-Tests
//
//  Created by Ryan Nystrom on 8/15/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

#import "Profiles_Tests.h"
#import "TestSemaphor.h"
#import "D3Defines.h"
#import "D3HTTPClient.h"

@implementation Profiles_Tests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

#pragma mark - D3HTTPClient

//- (void)testCorrectAccountName
//{
//    D3HTTPClient *client = [[D3HTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kD3BaseURL]];
//    [client getCareerWithAccount:@"rnystrom#1254"
//                         success:^(AFJSONRequestOperation *operation, id responseObject){
//                             STAssertNotNil(responseObject, @"Response object is nil");
//                         }
//                         failure:^(AFJSONRequestOperation *operation, NSError *error){
//                             NSLog(@"%@",error.localizedDescription);
//                             STAssertNotNil(error, @"Error is nil");
//                         }];
//}

@end
