//
//  CollectionFramedImage.m
//  precapture
//
//  Created by Randy Crafton on 7/11/12.
//  Copyright (c) 2012 Preveal. All rights reserved.
//

#import "CollectionFramedImage.h"
#import "Scalinator.h"
#import "PreCaptureSessionDetails.h"
#import <QuartzCore/QuartzCore.h>
#import "Collection.h"
#import "PrevealColors.h"

@implementation CollectionFramedImage

@synthesize frameWidth, frameHeight, frameX, frameY, frameView, frameColor;

- (NSDictionary *)renderAsDictionary
{
    NSMutableDictionary *dict = [[super renderAsDictionary] mutableCopy];
    [self unnullify];
    [dict setObject:@"CollectionFramedImage" forKey:@"class"];
    [dict setObject:[NSString stringWithFormat:@"%@", self.frameWidth] forKey:@"frameWidth"];
    [dict setObject:[NSString stringWithFormat:@"%@", self.frameHeight] forKey:@"frameHeight"];
    [dict setObject:[NSString stringWithFormat:@"%@", self.frameX] forKey:@"frameX"];
    [dict setObject:[NSString stringWithFormat:@"%@", self.frameY] forKey:@"frameY"];
    [dict setObject:frameColor forKey:@"frameColor"];
    return [NSDictionary dictionaryWithDictionary:dict];
}

- (void) unnullify
{
    if (self.frameColor == nil) {
        self.frameColor = @"black";
    }
}
- (void)loadFromDictionary:(NSDictionary *)values
{
    [super loadFromDictionary:values];
    
    self.frameHeight = [NSDecimalNumber decimalNumberWithString:[values valueForKey:@"frameHeight"]];
    self.frameWidth = [NSDecimalNumber decimalNumberWithString:[values valueForKey:@"frameWidth"]];
    self.frameX = [NSDecimalNumber decimalNumberWithString:[values valueForKey:@"frameX"]];
    self.frameY = [NSDecimalNumber decimalNumberWithString:[values valueForKey:@"frameY"]];
    self.frameColor = [values valueForKey:@"frameColor"];

    [self setInitialFrame];
}

- (void) setInitialFrame
{
    self.frame = CGRectMake([frameX floatValue], [frameY floatValue], [frameWidth floatValue], [frameHeight floatValue]);
    
    self.originalFrame = self.frame;
    
    self.layer.borderColor = [[UIColor blackColor] CGColor];
    if ([frameColor isEqualToString:@"white"]) {
        self.layer.borderColor = [[[PrevealColors sharedInstance] whiteFrameColor] CGColor];
    } else if ([frameColor isEqualToString:@"brown"]) {
        self.layer.borderColor = [[[PrevealColors sharedInstance] woodFrameColor] CGColor];
    }
}



- (void)setImage: (UIImage *) newImage
{
    if (self.imageView != nil) {
        [imageView removeFromSuperview];
        self.imageView = nil;
    }
    
    self.imageView = [[UIImageView alloc] initWithImage:newImage];
    [container addSubview:imageView];
    imageView.center = [self convertPoint:container.center toView:container];
    self.sizeLabel.hidden = YES;
    
}

- (void) addSizeLabel
{
    [super addSizeLabel];
    self.sizeLabel.frame = CGRectMake(0.0, container.frame.size.height - 30 - [x floatValue], container.frame.size.width, 30);
}

- (void) doneResizingWithScalinator: (Scalinator *)scalinator
{
    // Don't leave residuals around to funktify screens that get resized a lot. 
    for (UIView *subview in self.subviews) {
        [subview removeFromSuperview];
    }
    [super doneResizingWithScalinator: (Scalinator *)scalinator];
    self.layer.borderColor = [[UIColor blackColor] CGColor];
    if ([frameColor isEqualToString:@"white"]) {
        self.layer.borderColor = [[[PrevealColors sharedInstance] whiteFrameColor] CGColor];
    } else if ([frameColor isEqualToString:@"brown"]) {
        self.layer.borderColor = [[[PrevealColors sharedInstance] woodFrameColor] CGColor];
    }
    self.layer.borderWidth = [[scalinator getAdjustedSize:[NSDecimalNumber decimalNumberWithString:@"1"]] floatValue];
    CGRect imageFrame = CGRectMake([x floatValue], [y floatValue], [width floatValue], [height floatValue]);

    imageFrame = [scalinator getAdjustedFrame:imageFrame];

    if ([self.container class] == [UIView class]) {
        [container removeFromSuperview];
    }
    self.container = [[UIView alloc] initWithFrame:imageFrame];
    container.layer.borderColor = [[UIColor blackColor] CGColor];
    container.layer.borderWidth = 1;

    [self addSubview:container];
    container.clipsToBounds = YES;
    
    [self bringSubviewToFront:frameView];        

}

- (CollectionFramedImage *) duplicate
{
    CollectionFramedImage *duplicate = [[CollectionFramedImage alloc] init];
    duplicate.width = self.width;
    duplicate.height = self.height;
    duplicate.x = self.x;
    duplicate.y = self.y;
    duplicate.frameWidth = frameWidth;
    duplicate.frameHeight = frameHeight;
    duplicate.frameX = frameX;
    duplicate.frameY = frameY;
    duplicate.frameColor = frameColor;
    
    duplicate.imageType = imageType;
    return duplicate;
}

- (NSString *) description
{
    return [NSString stringWithFormat:@"Collection Framed Image:\nFrameX: %@, FrameY: %@, FrameWidth: %@, FrameHeight: %@\n x: %@, y: %@, w: %@, h:%@",
            frameX, frameY, frameWidth, frameHeight, x, y, width, height];
}
@end
