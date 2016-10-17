//
//  CollectionFramedImage.h
//  precapture
//
//  Created by Randy Crafton on 7/11/12.
//  Copyright (c) 2012 Preveal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionImage.h"

@interface CollectionFramedImage : CollectionImage {
    NSDecimalNumber *frameWidth;
    NSDecimalNumber *frameHeight;
    NSDecimalNumber *frameX;
    NSDecimalNumber *frameY;
    UIImageView *frameView;
    NSString *frameColor;
}

@property (nonatomic, retain) NSDecimalNumber *frameWidth;
@property (nonatomic, retain) NSDecimalNumber *frameHeight;
@property (nonatomic, retain) NSDecimalNumber *frameX;
@property (nonatomic, retain) NSDecimalNumber *frameY;
@property (nonatomic, retain) UIImageView *frameView;
@property (nonatomic, retain) NSString *frameColor;

- (CollectionFramedImage *) duplicate;
@end
