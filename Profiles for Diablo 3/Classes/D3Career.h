//
//  Career.h
//  Diablo
//
//  Created by Ryan Nystrom on 6/14/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

@class D3Career;

typedef void (^D3CareerRequestSuccess)(D3Career*);
typedef void (^D3CareerRequestFailure)(NSError*);

#import "D3Hero.h"

@interface D3Career : NSObject

+ (D3Career*)careerFromJSON:(NSDictionary*)json;
+ (void)getCareerForAccount:(NSString*)account success:(D3CareerRequestSuccess)success failure:(D3CareerRequestFailure)failure;
+ (BOOL)accountNameIsValid:(NSString*)account;
+ (NSString*)accountNameDivider;
+ (NSString*)apiParamFromAccount:(NSString*)account;

@property (strong, nonatomic) NSString *battleTag;

@property (assign, nonatomic) D3Hero *lastHeroPlayed;

@property (strong, nonatomic) NSDate *lastUpdated;

@property (assign, nonatomic) NSInteger killsMonsters;
@property (assign, nonatomic) NSInteger killsElites;
@property (assign, nonatomic) NSInteger killsHardcoreMonsters;

@property (assign, nonatomic) CGFloat timePlayedBarbarian;
@property (assign, nonatomic) CGFloat timePlayedDemonHunter;
@property (assign, nonatomic) CGFloat timePlayedMonk;
@property (assign, nonatomic) CGFloat timePlayedWitchDoctor;
@property (assign, nonatomic) CGFloat timePlayedWizard;

@property (strong, nonatomic) NSArray *artisans;
@property (strong, nonatomic) NSArray *hardcoreArtisans;
@property (strong, nonatomic) NSArray *timePlayedArray;
@property (strong, nonatomic) NSArray *progression;
@property (strong, nonatomic) NSArray *heroes;
@property (strong, nonatomic) NSArray *fallenHeros;

@end