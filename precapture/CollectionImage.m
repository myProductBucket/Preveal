//
//  CollectionImage.m
//  precapture
//
//  Created by Randy Crafton on 3/10/12.
//  Copyright (c) 2012 TouchSpring Design. All rights reserved.
//

#import "CollectionImage.h"
#import "Collection.h"
#import "GestureHandler.h"
#import "Scalinator.h"
#import <QuartzCore/QuartzCore.h>
#import <math.h>

@implementation CollectionImage

@synthesize imageType, width, height, x, y, useBorder, originalFrame, myCollection;
@synthesize myGestureHandler, delegate, imageView, container, sizeLabel, _lightboxLastScale;


- (NSDictionary *)renderAsDictionary
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];    
    [dict setObject:[NSString stringWithFormat:@"%@", width] forKey:@"width"];
    [dict setObject:[NSString stringWithFormat:@"%@", height] forKey:@"height"];
    [dict setObject:[NSString stringWithFormat:@"%@", x] forKey:@"x"];
    [dict setObject:[NSString stringWithFormat:@"%@", y] forKey:@"y"];
    
    [dict setObject:[NSString stringWithFormat:@"%d", useBorder] forKey:@"use_border"];
    [dict setObject:imageType forKey:@"type"];
    [dict setObject:@"CollectionImage" forKey:@"class"];
    return [NSDictionary dictionaryWithDictionary:dict];
}

- (void)loadFromDictionary:(NSDictionary *)values
{
    self.height = [NSDecimalNumber decimalNumberWithString:[values valueForKey:@"height"]];
    self.width = [NSDecimalNumber decimalNumberWithString:[values valueForKey:@"width"]];
    self.x = [NSDecimalNumber decimalNumberWithString:[values valueForKey:@"x"]];
    self.y = [NSDecimalNumber decimalNumberWithString:[values valueForKey:@"y"]];
    
    self.imageType = [values valueForKey:@"type"];
    [self setInitialFrame];
    self.multipleTouchEnabled = NO;
    self.userInteractionEnabled = NO;

    [self configureViewDetails];

}

- (void) configureViewDetails
{
    self.backgroundColor = [UIColor whiteColor];
    [self.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [self.layer setBorderWidth:1.0];
    [self.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [self.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    [self.layer setShadowRadius:3.0];
    [self.layer setShadowOpacity:.7];
}

- (void) setInitialFrame
{
    self.frame = CGRectMake([x floatValue], [y floatValue], [width floatValue], [height floatValue]);
    
    self.originalFrame = self.frame;

}
- (void)addSizeLabel
{

    if (self.sizeLabel != nil) {
        [self.sizeLabel removeFromSuperview];
        self.sizeLabel = nil;
    }
    self.sizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, self.frame.size.height - 30, self.frame.size.width, 30)];
    sizeLabel.text = [self getSizeAsString];
    sizeLabel.textAlignment = NSTextAlignmentCenter;
    sizeLabel.adjustsFontSizeToFitWidth = YES;
    sizeLabel.font = [UIFont fontWithName:@"Arial" size:20.0];
    sizeLabel.textColor = [UIColor grayColor];
    sizeLabel.backgroundColor = [UIColor clearColor];
    [self.container addSubview:sizeLabel];
}

- (NSString *) getSizeAsString
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *unitOfMeasure = [defaults objectForKey:@"unitOfMeasure"];

    NSDecimalNumber *myWidth = self.width;
    NSDecimalNumber *myHeight = self.height;
    if ([unitOfMeasure isEqualToString:@"metric"]) {
        myWidth = [width decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"2.54"]];
        myHeight = [height decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"2.54"]];
        NSDecimalNumberHandler *handler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain
                                                                                                 scale:1
                                                                                      raiseOnExactness:NO
                                                                                       raiseOnOverflow:NO
                                                                                      raiseOnUnderflow:NO
                                                                                   raiseOnDivideByZero:NO];
        myWidth = [myWidth decimalNumberByRoundingAccordingToBehavior:handler];
        myHeight = [myHeight decimalNumberByRoundingAccordingToBehavior:handler];
    }
    return [NSString stringWithFormat:@"%@ x %@", myWidth, myHeight];
}

- (void)doneResizingWithScalinator: (Scalinator *)scalinator
{
    self.container = [[UIView alloc] initWithFrame:self.frame];
    container.center = [self.superview convertPoint:self.center toView:self];
    [self addSubview:container];
    container.clipsToBounds = YES;
    [self addMask];
}

- (void)setImage: (UIImage *) newImage
{
    if (self.imageView != nil) {
        [imageView removeFromSuperview];
        self.imageView = nil;
    }    

    self.imageView = [[UIImageView alloc] initWithImage:newImage];
    self.layer.borderColor = [[UIColor clearColor] CGColor];
    [container addSubview:imageView];
    self.sizeLabel.hidden = YES;
}

- (UIImage *)image
{
    return imageView.image;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return [myCollection activeInDemo];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)configureGestureRecognizers
{
    self.userInteractionEnabled = YES;
    self.multipleTouchEnabled = YES;
    imageView.userInteractionEnabled = YES;
    imageView.multipleTouchEnabled = YES;

    UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc] initWithTarget:self 
                                                                             action:@selector(touched:)];
    [self addGestureRecognizer:tapper];
}


- (void)removeGestureRecognizers
{
    NSEnumerator *e = [self.gestureRecognizers objectEnumerator];
    UIGestureRecognizer *gestureRecognizer;
    while (gestureRecognizer = [e nextObject]) {
        [self removeGestureRecognizer:gestureRecognizer];
    }
}

- (void)setCollection:(Collection *)collection
{
    self.myCollection = collection;
}

- (void)touched:(id) sender
{
    [delegate didTouchCollectionImage:self];
}


- (CGFloat) getMinimumScaleForImage
{
    if (imageView == nil || imageView.image == nil) {
        return 0.0;
    }
        
    CGFloat horizontalRatio = container.bounds.size.width / imageView.image.size.width;
    CGFloat verticalRatio = container.bounds.size.height / imageView.image.size.height;
    return MAX(horizontalRatio, verticalRatio);
}

- (void)addMask
{
    return;
}

- (CollectionImage *) duplicate
{
    CollectionImage *duplicate = [[CollectionImage alloc] init];
    duplicate.width = self.width;
    duplicate.height = self.height;
    duplicate.x = self.x;
    duplicate.y = self.y;
    duplicate.imageType = imageType;
    return duplicate;
}

- (NSString *) description
{
    return [NSString stringWithFormat:@"Collection Image:\nx: %@, y: %@, w: %@, h:%@", x, y, width, height];
}
- (id) copyWithZone:(NSZone *)zone
{
    CollectionImage *another = [[CollectionImage alloc] init];
    another.x = [self.x copyWithZone:zone];
    another.y = [self.y copyWithZone:zone];
    another.width = [self.width copyWithZone:zone];
    another.height = [self.height copyWithZone:zone];
    another.imageType = [self.imageType copyWithZone:zone];
    
    return another;
}


@end
