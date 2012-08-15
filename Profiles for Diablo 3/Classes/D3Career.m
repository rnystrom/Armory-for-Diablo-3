//
//  Career.m
//  Diablo
//
//  Created by Ryan Nystrom on 6/14/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

#import "D3Career.h"

@implementation D3Career

// singleton
static D3Career *sharedInstance = nil;

#pragma mark - Singleton methods

+ (D3Career*)sharedInstance 
{
    if (sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedInstance];
}

- (id)copyWithZone:(NSZone*)zone
{
    return self;
}

#pragma mark - Instance methods

- (id)init
{
    if (self = [super init]) {
        _queue = [[NSOperationQueue alloc] init];
    }
    return self;
}

// dummy data for now, ignores accountName parameter
- (void)getAccount:(NSString*)accountName
{
    NSBlockOperation *operation = [[NSBlockOperation alloc] init];
    // weak reference to prevent retain cycle
    __weak NSBlockOperation *weakOperation = operation;
    [operation addExecutionBlock:^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"career" ofType:@"json"];
        NSError *error;
        NSData *careerData = [NSData dataWithContentsOfFile:path];
        if (error) {
            NSLog(@"%@",error.localizedDescription);
            [self errorToDelegate:error.localizedDescription];
            return;
        }
        
        NSError *parsingError;
        NSDictionary *careerResponseDictionary = [NSJSONSerialization JSONObjectWithData:careerData options:kNilOptions error:&parsingError];
        if (parsingError) {
            NSLog(@"%@",parsingError.localizedDescription);
            [self errorToDelegate:parsingError.localizedDescription];
            return;
        }
        
        NSString *secondsString = careerResponseDictionary[@"last-update"];
        if (secondsString) {
            NSTimeInterval seconds = secondsString.doubleValue;
            self.lastUpdated = [NSDate dateWithTimeIntervalSince1970:seconds];
        }
        
        NSMutableArray *mutArtisans = [NSMutableArray array];
        if ([careerResponseDictionary[@"artisans"] isKindOfClass:[NSArray array]]) {
            for (id json in careerResponseDictionary[@"artisans"]) {
                if ([json isKindOfClass:[NSDictionary class]]) {
                    D3Artisan *artisan = [D3Artisan artisanWithJSON:json];
                    if (artisan) {
                        [mutArtisans addObject:artisan];
                    }
                }
            }
        }

        NSMutableArray *mutHCArtisans = [NSMutableArray array];
        if ([careerResponseDictionary[@"hardcore-artisans"] isKindOfClass:[NSArray class]]) {
            for (NSDictionary *json in careerResponseDictionary[@"hardcore-artisans"]) {
                if ([json isKindOfClass:[NSDictionary class]]) {
                    D3Artisan *artisan = [D3Artisan artisanWithJSON:json];
                    if (artisan) {
                        [mutHCArtisans addObject:artisan];
                    }
                }
            }
        }
        
        NSMutableArray *mutHeroes = [NSMutableArray array];
        for (NSDictionary *json in (NSArray*)careerResponseDictionary[@"heroes"]) {
//            NSInteger heroID = ((NSNumber*)[json objectForKey:@"id"]).integerValue;
            if ([weakOperation isCancelled]) return;
//            D3Hero *hero = [D3Hero requestHeroFromCareer:self ID:heroID];
            D3Hero *hero = nil;
            if (hero) {
                [mutHeroes addObject:hero];
            }
        }
        
        NSMutableArray *mutFallenHeroes = [NSMutableArray array];
        if ([careerResponseDictionary[@"fallenHeroes"] isKindOfClass:[NSArray array]]) {
            for (NSDictionary *json in (NSArray*)careerResponseDictionary[@"fallenHeroes"]) {
                D3Hero *fallenHero = [D3Hero fallenHeroFromJSON:json];
                if (fallenHero) {
                    [mutFallenHeroes addObject:fallenHero];
                }
            }
        }
        
        NSDictionary *timeDictionary = careerResponseDictionary[@"time-played"];
        
        NSInteger lastPlayedID = ((NSString*)careerResponseDictionary[@"last-hero-played"]).integerValue;
        D3Hero *lastHeroPlayed = nil;
        for (D3Hero *hero in mutHeroes) {
            if (hero.ID == lastPlayedID) {
                lastHeroPlayed = hero;
                break;
            }
        }
        
        NSDictionary *killsDictionary = careerResponseDictionary[@"kills"];
        self.killsMonsters = ((NSString*)killsDictionary[@"monsters"]).integerValue;
        self.killsElites = ((NSString*)killsDictionary[@"elites"]).integerValue;
        self.killsHardcoreMonsters = ((NSString*)killsDictionary[@"hardcoreMonsters"]).integerValue;
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            // set everything in the main queue because UI elements depend on them
            self.artisans = mutArtisans;
            self.lastHeroPlayed = lastHeroPlayed;
            self.hardcoreArtisans = mutHCArtisans;
            self.heroes = mutHeroes;
            self.fallenHeros = mutFallenHeroes;
            self.progression = careerResponseDictionary[@"progression"];
            
            self.timePlayedBarbarian = ((NSString*)timeDictionary[@"barbarian"]).floatValue;
            self.timePlayedDemonHunter = ((NSString*)timeDictionary[@"demon-hunter"]).floatValue;
            self.timePlayedMonk = ((NSString*)timeDictionary[@"monk"]).floatValue;
            self.timePlayedWitchDoctor = ((NSString*)timeDictionary[@"witch-doctor"]).floatValue;
            self.timePlayedWizard = ((NSString*)timeDictionary[@"wizard"]).floatValue;
            self.timePlayedArray = @[
            @(self.timePlayedBarbarian),
            @(self.timePlayedDemonHunter),
            @(self.timePlayedMonk),
            @(self.timePlayedWitchDoctor),
            @(self.timePlayedWizard)
            ];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(careerDidLoad)]) {
                [self.delegate careerDidLoad];
            }
        }];
    }];
    [self.queue addOperation:operation];
}

// get on the main thread and send an error to the delegate
// space saving method
- (void)errorToDelegate:(NSString*)error
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(requestDidFailWithError:)]) {
            [self.delegate requestDidFailWithError:error];
        }
    }];
}

@end
