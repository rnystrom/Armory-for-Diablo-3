//
//  Career.h
//  Diablo
//
//  Created by Ryan Nystrom on 6/14/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

#import "D3Hero.h"

@protocol CareerDelegate <NSObject>

@required

- (void)careerDidLoad;
- (void)requestDidFailWithError:(NSString*)error;

@end

static NSString * const careerRequestDid404 = @"CareerRequestDid404";

@interface D3Career : NSObject

@property (strong, nonatomic) NSOperationQueue *queue;

@property (weak, nonatomic) NSObject <CareerDelegate> *delegate;

@property (strong, nonatomic) NSString *accountName;
@property (strong, nonatomic) NSString *battleNetNumber;

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

// singleton method
+ (id)sharedInstance;

// request methods
- (void)getAccount:(NSString*)accountName;

@end
