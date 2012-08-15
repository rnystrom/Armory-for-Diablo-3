//
//  Skill.m
//  Diablo
//
//  Created by Ryan Nystrom on 6/17/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

#import "D3Skill.h"

@interface D3Skill ()

+ (D3Skill*)skillFromJSON:(NSDictionary*)json;

@end

@implementation D3Skill

#pragma mark - Class methods

+ (D3Skill*)skillFromJSON:(NSDictionary *)json
{
    D3Skill *skill = [[D3Skill alloc] init];
    if ([json isKindOfClass:[NSDictionary class]]) {
        skill.description = json[@"description"];
        skill.simpleDescription = json[@"simpleDescription"];
        skill.flavor = json[@"flavor"];
        skill.iconString = json[@"icon"];
        skill.name = json[@"name"];
        skill.slug = json[@"slug"];
        skill.tooltipParams = json[@"tooltipParams"];
    }
    return skill;
}

+ (D3Skill*)activeSkillFromJSON:(NSDictionary*)json
{
    if (! [NSThread isMainThread]) {
        NSDictionary *skillJSON = json[@"skill"];
        NSDictionary *runeJSON = json[@"rune"];
        D3Skill *skill = [D3Skill skillFromJSON:skillJSON];
        skill.rune = [D3Rune runeFromJSON:runeJSON];
        skill.isActive = YES;
        return skill;
    }
    return nil;
}

+ (D3Skill*)passiveSkillFromJSON:(NSDictionary*)json;
{
    if (! [NSThread isMainThread]) {
        D3Skill *skill = [D3Skill skillFromJSON:json];
        skill.isActive = NO;
        return skill;
    }
    return nil;
}

#pragma mark - Instance methods

- (id)init
{
    if (self = [super init]) {
        _queue = [[NSOperationQueue alloc] init];
    }
    return self;
}

//- (void)requestImage
//{
//    if (self.iconString) {
//        NSURLRequest *request = [DiabloOperation requestSkill:self.iconString];
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
//                    CGContextSetInterpolationQuality(context, kCGInterpolationLow);
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
//                            [self.delegate skillImageDidLoad:self.icon];
//                        }
//                    }];
//                }];
//            }
//            else {
//                if (data && didComplete && [NSThread isMainThread]) {
//                    if ([image isKindOfClass:[UIImage class]]) {
//                        self.icon = image;
//                        if (self.delegate) {
//                            [self.delegate skillImageDidLoad:self.icon];
//                        }
//                    }
//                }
////            }
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
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{                
                if (self.tooltipDelegate) {
                    [self.tooltipDelegate skillTooltipDidLoad:self];
                }
            }];
        }];
        [self.queue addOperation:operation];
    }
}

@end
