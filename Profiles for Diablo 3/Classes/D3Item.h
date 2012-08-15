//
//  Item.h
//  Diablo
//
//  Created by Ryan Nystrom on 6/16/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

enum ItemType {
    ItemTypeHead = 0,
    ItemTypeShoulders = 1,
    ItemTypeNeck = 2,
    ItemTypeHands = 3,
    ItemTypeBracers = 4,
    ItemTypeLeftFinger = 5,
    ItemTypeRightFinger = 6,
    ItemTypeWaist = 7,
    ItemTypeLegs = 8,
    ItemTypeMainHand = 9,
    ItemTypeOffHand = 10,
    ItemTypeFeet = 11,
    ItemTypeTorso = 12
};

enum ItemGeneralType {
    ItemGeneralTypeWeapon = 0,
    ItemGeneralTypeArmor = 1,
    ItemGeneralTypeTrinket = 2
};

@class D3Item;

// used in to load and set the button image
@protocol ItemButtonDelegate <NSObject>

@required
- (void)itemImageDidLoad:(UIImage*)image;

@end

// used to load tooltip info
@protocol ItemTooltipDelegate <NSObject>

@required
- (void)itemTooltipDidLoad:(D3Item*)item;

@end

@interface D3Item : NSObject

+ (D3Item*)itemFromJSON:(NSDictionary*)json withType:(NSInteger)type;

// REMOVE WHEN API IS LIVE
@property (strong, nonatomic) NSString *fileName;

@property (strong, nonatomic) NSOperationQueue *queue;

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *colorString;
@property (strong, nonatomic) NSString *tooltipParams;
@property (strong, nonatomic) NSString *flavorText;
@property (strong, nonatomic) NSString *iconString;
@property (getter = getDisplayValue, nonatomic, readonly) NSString *displayValue;
@property (getter = getDisplayValueUnit, nonatomic, readonly) NSString *displayValueUnit;
@property (getter = getRequiredLevelString, nonatomic, readonly) NSString *requiredLevelString;

@property (getter = displayColorFromDictionary, nonatomic, readonly) UIColor *displayColor;

@property (assign, nonatomic) NSInteger requiredLevel;
@property (assign, nonatomic) NSInteger itemLevel;
@property (assign, nonatomic) NSInteger itemType;
@property (assign, nonatomic) NSInteger armor;
@property (assign, nonatomic) NSInteger minDamage;
@property (assign, nonatomic) NSInteger maxDamage;

@property (assign, nonatomic) CGFloat dps;
@property (assign, nonatomic) CGFloat attacksPerSecond;

@property (strong, nonatomic) NSArray *attributes;
@property (strong, nonatomic) NSArray *socketEffects;

@property (strong, nonatomic) UIImage *icon;

@property (weak, nonatomic) NSObject <ItemButtonDelegate> *delegate;
@property (weak, nonatomic) NSObject <ItemTooltipDelegate> *tooltipDelegate;

//@property (assign, nonatomic) BOOL isArmor;

//- (void)requestImageWithHero:(D3Hero*)hero;
- (void)requestTooltip;

@end