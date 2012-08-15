//
//  Artisan.h
//  Diablo
//
//  Created by Ryan Nystrom on 6/14/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

@interface D3Artisan : NSObject

@property (strong, nonatomic) NSString *slug;
@property (assign, nonatomic) NSInteger level;
@property (assign, nonatomic) NSInteger stepCurrent;
@property (assign, nonatomic) NSInteger stepMax;

+ (D3Artisan*)artisanWithJSON:(NSDictionary*)json;

@end
