//
//  CollectionRotator.h
//  precapture
//
//  Created by Randy Crafton on 12/2/12.
//  Copyright (c) 2012 Preveal. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Collection;
@interface CollectionRotator : NSObject

+ (Collection *) rotateCollection: (Collection *)collection;

+ (CGFloat) convertDegreesToRadians: (CGFloat) degrees;

+ (CGFloat)minimumScaleForImage: (UIImage *)image inBounds:(CGSize)bounds;

@end
