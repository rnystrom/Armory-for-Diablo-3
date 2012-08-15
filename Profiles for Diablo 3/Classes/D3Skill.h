//
//  Skill.h
//  Diablo
//
//  Created by Ryan Nystrom on 6/17/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

#import "D3Rune.h"

@class D3Skill;

@protocol SkillButtonDelegate <NSObject>

@required
-(void)skillImageDidLoad:(UIImage*)image;

@end

@protocol SkillTooltipDelegate <NSObject>

@required
-(void)skillTooltipDidLoad:(D3Skill*)skill;

@end

@interface D3Skill : NSObject

+ (D3Skill*)activeSkillFromJSON:(NSDictionary*)json;
+ (D3Skill*)passiveSkillFromJSON:(NSDictionary*)json;

@property (strong, nonatomic) NSOperationQueue *queue;

@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSString *simpleDescription;
@property (strong, nonatomic) NSString *flavor;
@property (strong, nonatomic) NSString *iconString;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *slug;
@property (strong, nonatomic) NSString *tooltipParams;

@property (strong, nonatomic) D3Rune *rune;

@property (assign, nonatomic) BOOL isActive;

@property (strong, nonatomic) UIImage *icon;

@property (weak, nonatomic) NSObject <SkillButtonDelegate> *delegate;
@property (weak, nonatomic) NSObject <SkillTooltipDelegate> *tooltipDelegate;

- (void)requestTooltip;
//- (void)requestImage;

@end
