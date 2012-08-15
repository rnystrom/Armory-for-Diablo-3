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

+ (D3Item*)itemFromJSON:(NSDictionary*)json withType:(NSInteger)type
{
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

- (id)init
{
    if (self = [super init]) {
        // i dont like this because its stored for *every* Item
        _queue = [[NSOperationQueue alloc] init];
        _name = @"Not Available";
        _requiredLevel = 0;
        _itemLevel = 0;
        _itemType = ItemGeneralTypeArmor;
        _armor = 0;
        _minDamage = 0;
        _maxDamage = 0;
    }
    return self;
}

#pragma mark - Getters

- (UIColor*)displayColorFromDictionary
{
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

- (NSString*)getDisplayValue
{
    switch (self.itemType) {
        case ItemGeneralTypeArmor:
            return [NSString stringWithFormat:@"%i",self.armor];
            break;
        case ItemGeneralTypeWeapon:
            return [NSString stringWithFormat:@"%.1f",self.dps];
            break;
    }
    return nil;
}

- (NSString*)getRequiredLevelString
{
    return [NSString stringWithFormat:@"Required Level: %i",self.requiredLevel];
}

- (NSString*)getDisplayValueUnit
{
    if (self.itemType == ItemGeneralTypeArmor) {
        return @"Armor";
    }
    else if (self.itemType == ItemGeneralTypeWeapon) {
        return [NSString stringWithFormat:@"Damage Per Second\n%i-%i Damage\n%.2f Attacks Per Second",self.minDamage,self.maxDamage,self.attacksPerSecond];
    }
    return @"";
}

#pragma mark - Instance methods

//- (void)requestImageWithHero:(D3Hero*)hero
//{
//    if (self.iconString && hero.className && hero.gender) {
//        NSURLRequest *request = [DiabloOperation requestItem:self.iconString forClass:hero.className withGender:hero.gender];
//        DiabloOperation *operation = [[DiabloOperation alloc] initWithRequest:request completed:^(NSData *data, BOOL didComplete){
//            __block UIImage *image = [UIImage imageWithData:data];
            // check if we are on a retina device
//            if ([UIScreen mainScreen].scale > 1.0f) {
//                // adjust image on a new thread because
//                // this block is executed on main thread
//                __block CGImageRef imgRef = image.CGImage;
//                [self.queue addOperationWithBlock:^{
//                    CGFloat oldWidth = CGImageGetWidth(imgRef);
//                    CGFloat oldHeight = CGImageGetHeight(imgRef);
//                    CGSize oldSize = CGSizeMake(oldWidth, oldHeight);
//                    CGSize newSize = CGSizeMake(oldSize.width * 2.0f, oldSize.height * 2.0f);
//                    CGRect newRect = CGRectMake(0.0f, 0.0f, newSize.width, newSize.height);
//                    
//                    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0);
//                    CGContextRef context = UIGraphicsGetCurrentContext();
//                    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
//                    CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, newSize.height);
//                    
//                    CGContextConcatCTM(context, flipVertical);
//                    CGContextDrawImage(context, newRect, imgRef);
//                    CGImageRef newImgRef = CGBitmapContextCreateImage(context);
//                    
//                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                        // set the scale of the new image to prevent getting x2 uiimageviews
//                        UIImage *newImage = [UIImage imageWithCGImage:newImgRef scale:[UIScreen mainScreen].scale orientation:image.imageOrientation];
//                        self.icon = newImage;
//                        if (self.delegate) {
//                            [self.delegate itemImageDidLoad:self.icon];
//                        }
//                    }];
//                }];
//            }
//            else {
//                if (data && didComplete && [NSThread isMainThread]) {
//                    if ([image isKindOfClass:[UIImage class]]) {
//                        self.icon = image;
//                        if (self.delegate) {
//                            [self.delegate itemImageDidLoad:self.icon];
//                        }
//                    }
//                }
//            }
//        }];
//        [self.queue addOperation:operation];
//    }
//}

- (void)requestTooltip
{
    if (self.tooltipParams) {
        NSBlockOperation *operation = [[NSBlockOperation alloc] init];
        [operation addExecutionBlock:^{
            // THIS IS DUMMY DATA
            // Change this when the API goes live
            NSString *path = [[NSBundle mainBundle] pathForResource:self.fileName ofType:@"json"];
            NSError *error;
            NSData *itemData = [NSData dataWithContentsOfFile:path];
            if (error) {
                NSLog(@"%@",error.localizedDescription);
                return;
            }
            NSError *parsingError;
            NSDictionary *itemJSON = [NSJSONSerialization JSONObjectWithData:itemData options:kNilOptions error:&parsingError];
            if (parsingError) {
                NSLog(@"%@",parsingError.localizedDescription);
                return;
            }
            
            // if weapon
            NSDictionary *minDamage = itemJSON[@"minDamage"];
            NSDictionary *maxDamage = itemJSON[@"maxDamage"];
            NSDictionary *dps = itemJSON[@"dps"];
            NSDictionary *attacksPerSecond = itemJSON[@"attacksPerSecond"];
            
            // if armor
            NSDictionary *armor = itemJSON[@"armor"];
            
            NSString *requiredLevel = itemJSON[@"requiredLevel"];
            NSString *itemLevel = itemJSON[@"itemLevel"];
            NSString *flavorText = itemJSON[@"flavorText"];
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                switch (self.itemType) {
                    case ItemGeneralTypeArmor: {
                        if ([armor isKindOfClass:[NSDictionary class]]) {
                            self.armor = ((NSString*)armor[@"min"]).integerValue;
                        }
                    }
                        break;
                    case ItemGeneralTypeTrinket: {
                        
                    }
                        break;
                    case ItemGeneralTypeWeapon: {
                        if ([minDamage isKindOfClass:[NSDictionary class]]) {
                            self.minDamage = ((NSString*)minDamage[@"min"]).integerValue;
                        }
                        if ([maxDamage isKindOfClass:[NSDictionary class]]) {
                            self.maxDamage = ((NSString*)maxDamage[@"min"]).integerValue;
                        }
                        if ([dps isKindOfClass:[NSDictionary class]]) {
                            self.dps = ((NSString*)dps[@"min"]).floatValue;
                        }
                        if ([attacksPerSecond isKindOfClass:[NSDictionary class]]) {
                            self.attacksPerSecond = ((NSString*)attacksPerSecond[@"min"]).floatValue;
                        }
                    }
                        break;
                }
                
                self.attributes = itemJSON[@"attributes"];
                self.itemLevel = itemLevel.integerValue;
                self.requiredLevel = requiredLevel.integerValue;
                self.flavorText = flavorText;
                
                if (self.tooltipDelegate) {
                    [self.tooltipDelegate itemTooltipDidLoad:self];
                }
            }];
        }];
        [self.queue addOperation:operation];
    }
}

@end
