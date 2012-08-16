//
//  Item.m
//  Diablo
//
//  Created by Ryan Nystrom on 6/16/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

#import "D3Item.h"

@interface D3Item ()

@end

@implementation D3Item

+ (D3Item*)itemFromJSON:(NSDictionary*)json withType:(NSInteger)type {
    D3Item *item = [[D3Item alloc] init];
    if ([json isKindOfClass:[NSDictionary class]]) {
        item.colorString = json[@"displayColor"];
        item.name = json[@"name"];
        item.iconString = json[@"icon"];
        item.tooltipParams = json[@"tooltipParams"];
        item.itemType = type;
    }
    return item;
}


- (id)init {
    if (self = [super init]) {
        // i dont like this because its stored for *every* Item
        _queue = [[NSOperationQueue alloc] init];
        _name = @"Not Available";
        _requiredLevel = 0;
        _itemLevel = 0;
        _itemType = D3ItemGeneralTypeArmor;
        _armor = 0;
        _minDamage = 0;
        _maxDamage = 0;
    }
    return self;
}


#pragma mark - Getters

- (UIColor*)displayColorFromDictionary {
    if (self.colorString) {
        return @{
        @"white"    : [UIColor whiteColor],
        @"blue"     : [UIColor blueColor],
        @"yellow"   : [UIColor yellowColor],
        @"orange"   : [UIColor orangeColor],
        @"null"     : [UIColor redColor]
        }[self.colorString];
    }
    return [UIColor redColor];
}


- (NSString*)getDisplayValue {
    switch (self.itemType) {
        case D3ItemGeneralTypeArmor:
            return [NSString stringWithFormat:@"%i",self.armor];
            break;
        case D3ItemGeneralTypeWeapon:
            return [NSString stringWithFormat:@"%.1f",self.dps];
            break;
    }
    return nil;
}


- (NSString*)getRequiredLevelString {
    return [NSString stringWithFormat:@"Required Level: %i",self.requiredLevel];
}


- (NSString*)getDisplayValueUnit {
    if (self.itemType == D3ItemGeneralTypeArmor) {
        return @"Armor";
    }
    else if (self.itemType == D3ItemGeneralTypeWeapon) {
        return [NSString stringWithFormat:@"Damage Per Second\n%i-%i Damage\n%.2f Attacks Per Second",self.minDamage,self.maxDamage,self.attacksPerSecond];
    }
    return @"";
}


#pragma mark - Loading

// return a request so we can batch all of the items into one burst
- (AFImageRequestOperation*)requestForItemIconWithHeroType:(NSString*)heroType imageProcessingBlock:(UIImage* (^)(UIImage *image))imageProcessingBlock success:(void (^)(NSURLRequest*, NSHTTPURLResponse*, UIImage*))success failure:(void (^)(NSURLRequest*, NSHTTPURLResponse*, NSError*))failure {
    if (! self.iconString) {
        return nil;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@_%@.png",kD3MediaURL,kD3ItemParam,self.iconString,heroType];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    return [AFImageRequestOperation imageRequestOperationWithRequest:request imageProcessingBlock:imageProcessingBlock success:success failure:failure];
}


@end
