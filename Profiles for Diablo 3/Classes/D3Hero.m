//
//  Hero.m
//  Diablo
//
//  Created by Ryan Nystrom on 6/14/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

#import "D3Hero.h"

@implementation D3Hero

+ (D3Hero*)heroFromPreviewJSON:(NSDictionary*)json
{
    D3Hero *hero = nil;
    if ([json isKindOfClass:[NSDictionary class]]) {
        hero = [[D3Hero alloc] init];
        
        hero.isFullyLoaded = NO;
        hero.className = json[@"class"];
        hero.gender = [json[@"gender"] isEqual:[NSNumber numberWithInt:0]] ? @"Male" : @"Female";
        hero.name = json[@"name"];
        
        NSString *hardcoreString = json[@"hardcore"];
        hero.hardcore = hardcoreString.boolValue;
        
        NSString *levelString = json[@"level"];
        hero.level = levelString.integerValue;
        
        NSString *idString = json[@"level"];
        hero.ID = idString.integerValue;
        
        NSString *secondsString = json[@"lastUpdated"];
        if (secondsString) {
            NSTimeInterval seconds = secondsString.doubleValue;
            hero.lastUpdated = [NSDate dateWithTimeIntervalSince1970:seconds];
        }
    }
    return hero;
}

//+ (D3Hero*)requestHeroFromCareer:(D3Career*)career ID:(NSInteger)ID
+ (D3Hero*)request
{
    // Check that this is NOT being run on the main thread
    if (! [NSThread isMainThread]) {
        // normally would request URL based on accountName
        // for now we just get dummy data based on Blizzard's
        // API sampling
        NSString *path = [[NSBundle mainBundle] pathForResource:@"hero" ofType:@"json"];
        NSError *error;
        NSData *careerData = [NSData dataWithContentsOfFile:path];
        if (error) {
            NSLog(@"%@",error.localizedDescription);
            return nil;
        }
        
        NSError *parsingError;
        NSDictionary *heroResponseDictionary = [NSJSONSerialization JSONObjectWithData:careerData options:kNilOptions error:&parsingError];
        if (parsingError) {
            NSLog(@"%@",parsingError.localizedDescription);
            return nil;
        }
        
        D3Hero *hero = [[D3Hero alloc] init];
        NSTimeInterval seconds = ((NSString*)heroResponseDictionary[@"last-updated"]).doubleValue;
        hero.lastUpdated = [NSDate dateWithTimeIntervalSince1970:seconds];
        hero.ID = ((NSNumber*)heroResponseDictionary[@"id"]).floatValue;
        hero.name = heroResponseDictionary[@"name"];
        hero.level = ((NSNumber*)heroResponseDictionary[@"level"]).integerValue;
        hero.gender = ((NSNumber*)heroResponseDictionary[@"gender"]).integerValue == GenderMale ? @"male" : @"female";
        hero.hardcore = ((NSNumber*)heroResponseDictionary[@"hardcore"]).boolValue;
        hero.className = heroResponseDictionary[@"class"];
        
        NSDictionary *skillsDictionary = heroResponseDictionary[@"skills"];
        NSMutableArray *mutActiveSkills = [NSMutableArray array];
        if ([skillsDictionary[@"active"] isKindOfClass:[NSArray class]]) {
            for (NSDictionary *activeSkillDict in (NSArray*)skillsDictionary[@"active"]) {
                D3Skill *skill = [D3Skill activeSkillFromJSON:activeSkillDict];
                if (skill) {
                    [mutActiveSkills addObject:skill];
                }
            }
        }
        hero.activeSkills = mutActiveSkills;
        
        NSMutableArray *mutPassiveSkills = [NSMutableArray array];
        if ([skillsDictionary[@"passive"] isKindOfClass:[NSArray class]]) {
            for (NSDictionary *passiveSkillDict in (NSArray*)skillsDictionary[@"passive"]) {
                D3Skill *skill = [D3Skill passiveSkillFromJSON:passiveSkillDict];
                if (skill) {
                    [mutPassiveSkills addObject:skill];
                }
            }
        }
        hero.passiveSkills = mutPassiveSkills;
        
        NSDictionary *itemsDictionary = heroResponseDictionary[@"items"];
        if ([itemsDictionary isKindOfClass:[NSDictionary class]]) {
            hero.head = [D3Item itemFromJSON:itemsDictionary[@"head"] withType:ItemGeneralTypeArmor];
            hero.torso = [D3Item itemFromJSON:itemsDictionary[@"torso"] withType:ItemGeneralTypeArmor];
            hero.feet = [D3Item itemFromJSON:itemsDictionary[@"feet"] withType:ItemGeneralTypeArmor];
            hero.hands = [D3Item itemFromJSON:itemsDictionary[@"hands"] withType:ItemGeneralTypeArmor];
            hero.shoulders = [D3Item itemFromJSON:itemsDictionary[@"shoulders"] withType:ItemGeneralTypeArmor];
            hero.legs = [D3Item itemFromJSON:itemsDictionary[@"legs"] withType:ItemGeneralTypeArmor];
            hero.bracers = [D3Item itemFromJSON:itemsDictionary[@"bracers"] withType:ItemGeneralTypeArmor];
            hero.waist = [D3Item itemFromJSON:itemsDictionary[@"waist"] withType:ItemGeneralTypeArmor];
            
            hero.rightFinger = [D3Item itemFromJSON:itemsDictionary[@"rightFinger"] withType:ItemGeneralTypeTrinket];
            hero.leftFinger = [D3Item itemFromJSON:itemsDictionary[@"leftFinger"] withType:ItemGeneralTypeTrinket];
            hero.neck = [D3Item itemFromJSON:itemsDictionary[@"neck"] withType:ItemGeneralTypeTrinket];
            
            hero.mainHand = [D3Item itemFromJSON:itemsDictionary[@"mainHand"] withType:ItemGeneralTypeWeapon];
            hero.offHand = [D3Item itemFromJSON:itemsDictionary[@"offHand"] withType:ItemGeneralTypeWeapon];
            
            // DUMMY DATA
            // Remove when API goes live
            hero.head.fileName = @"item_magic_helm";
            hero.torso.fileName = @"item_rare_pants";
            hero.feet.fileName = @"item_rare_pants";
            hero.hands.fileName = @"item_rare_pants";
            hero.shoulders.fileName = @"item_rare_pants";
            hero.legs.fileName = @"item_magic_helm";
            hero.bracers.fileName = @"item_magic_helm";
            hero.waist.fileName = @"item_rare_pants";
            hero.rightFinger.fileName = @"item_rare_ring";
            hero.leftFinger.fileName = @"item_rare_ring";
            hero.neck.fileName = @"item_rare_ring";
            hero.mainHand.fileName = @"item_weapon_legendary";
            hero.offHand.fileName = @"item_weapon_legendary";
            
            hero.itemsArray = @[
                hero.head,
                hero.shoulders,
                hero.neck,
                hero.hands,
                hero.bracers,
                hero.leftFinger,
                hero.rightFinger,
                hero.waist,
                hero.legs,
                hero.mainHand,
                hero.offHand,
                hero.feet,
                hero.torso
            ];
        }
                
        NSDictionary *followersDictionary = heroResponseDictionary[@"followers"];
        if ([followersDictionary isKindOfClass:[NSDictionary class]]) {
            hero.templar = [D3Follower followerFromJSON:followersDictionary[@"templar"]];
            hero.enchantress = [D3Follower followerFromJSON:followersDictionary[@"enchantress"]];
            hero.scoundrel = [D3Follower followerFromJSON:followersDictionary[@"scoundrel"]];
        }
        
        NSDictionary *statsDictionary = heroResponseDictionary[@"stats"];
        if ([statsDictionary isKindOfClass:[NSDictionary class]]) {
            hero.damageIncrease = ((NSNumber*)statsDictionary[@"damageIncrease"]).floatValue;
            hero.damageReduction = ((NSNumber*)statsDictionary[@"damageReduction"]).floatValue;
            hero.critChance = ((NSNumber*)statsDictionary[@"critChance"]).floatValue;
            hero.life = ((NSNumber*)statsDictionary[@"life"]).integerValue;
            hero.strength = ((NSNumber*)statsDictionary[@"strength"]).integerValue;
            hero.dexterity = ((NSNumber*)statsDictionary[@"dexterity"]).integerValue;
            hero.intelligence = ((NSNumber*)statsDictionary[@"intelligence"]).integerValue;
            hero.vitality = ((NSNumber*)statsDictionary[@"vitality"]).integerValue;
            hero.armor = ((NSNumber*)statsDictionary[@"armor"]).integerValue;
            hero.coldResist = ((NSNumber*)statsDictionary[@"coldResist"]).integerValue;
            hero.fireResist = ((NSNumber*)statsDictionary[@"fireResist"]).integerValue;
            hero.lightningResist = ((NSNumber*)statsDictionary[@"lightningResist"]).integerValue;
            hero.poisonResist = ((NSNumber*)statsDictionary[@"poisonResist"]).integerValue;
            hero.arcaneResist = ((NSNumber*)statsDictionary[@"arcaneResist"]).integerValue;
            hero.damage = ((NSNumber*)statsDictionary[@"damage"]).floatValue;
        }
        
        NSDictionary *progressDictionary = heroResponseDictionary[@"progress"];
        if ([progressDictionary isKindOfClass:[NSDictionary class]]) {
            // store this in case we want to access it again
            hero.progress = progressDictionary;
            // NSNumber %s for each act
            __block NSMutableArray *actsProgression;
            
            NSDictionary *normalDictionary = progressDictionary[@"normal"];
            NSDictionary *nightmareDictionary = progressDictionary[@"nightmare"];
            NSDictionary *hellDictionary = progressDictionary[@"hell"];
            NSDictionary *infernoDictionary = progressDictionary[@"inferno"];
            
            NSArray *difficulties = @[ infernoDictionary, hellDictionary, nightmareDictionary, normalDictionary ];
            __block NSArray *difficultyTitles = @[ @"Inferno", @"Hell", @"Nightmare", @"Normal" ];
            [difficulties enumerateObjectsUsingBlock:^(NSDictionary *json, NSUInteger idx, BOOL *stop){
                // for later use
                __block BOOL *blockStop = stop;
                
                hero.progressHighestDifficulty = difficultyTitles[idx];
                
                if ([json isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *act1 = json[@"act1"];
                    NSDictionary *act2 = json[@"act2"];
                    NSDictionary *act3 = json[@"act3"];
                    NSDictionary *act4 = json[@"act4"];
                    
                    NSArray *acts = @[ act1, act2, act3, act4 ];
                    actsProgression = [NSMutableArray array];
                    [acts enumerateObjectsUsingBlock:^(NSDictionary *actsJSON, NSUInteger actsIdx, BOOL *actsStop){
                        NSArray *quests = actsJSON[@"quests"];
                        if ([quests isKindOfClass:[NSArray class]]) {
                            NSNumber *completed = actsJSON[@"completed"];
                            // save some parsing time
                            if (completed.boolValue) {
                                *blockStop = YES;
                                [actsProgression addObject:[NSNumber numberWithFloat:1.0f]];
                            }
                            else {
                                CGFloat totalQuests = [quests count];
                                __block CGFloat completedQuests = 0.0f;
                                [quests enumerateObjectsUsingBlock:^(NSDictionary *questsJSON, NSUInteger questsIdx, BOOL *questsStop){
                                    NSNumber *completedQuest = questsJSON[@"completed"];
                                    completedQuests += completedQuest.floatValue;
                                }];
                                if (completedQuests > 0.0f) {
                                    *blockStop = YES;
                                }
                                [actsProgression addObject:[NSNumber numberWithFloat:(completedQuests / totalQuests)]];
                            }
                        }
                    }];
                }
            }];
            hero.progressionCompletion = actsProgression;
        }
        
        return hero;
    }
    return nil;
}

+ (D3Hero*)fallenHeroFromJSON:(NSDictionary*)json
{
    return nil;
}


#pragma mark - Loading

- (void)finishLoadingWithSuccess:(D3HeroRequestSuccess)success failure:(D3HeroRequestFailure)failure {
    [[D3HTTPClient sharedClient] getHeroWithID:self.ID success:^(AFJSONRequestOperation *operation, id responseObject) {
        NSData *jsonData = (NSData*)responseObject;
        NSError *parsingError = nil;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&parsingError];
        if (parsingError && failure) {
            failure(parsingError);
        }
        else {
            [self parseFullJSON:json];
            if (success) {
                success(self);
            }
        }
    } failure:^(AFJSONRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


#pragma mark - Parsing

- (void)parseFullJSON:(NSDictionary*)json {
    if ([json isKindOfClass:[NSDictionary class]]) {
        self.isFullyLoaded = YES;
    }
}


- (UIImage*)getClassImage
{
    if (self.className) {
        return [UIImage imageNamed:[NSString stringWithFormat:@"%@-icon.png",self.className]];
    }
    return nil;
}

@end
