//
//  CollectionRotator.m
//  precapture
//
//  Created by Randy Crafton on 12/2/12.
//  Copyright (c) 2012 Preveal. All rights reserved.
//

#import "CollectionRotator.h"
#import "Collection.h"
#import "CollectionImage.h"
#import "CollectionFramedImage.h"
#import "PreCaptureSessionDetails.h"
#import "Scalinator.h"

@implementation CollectionRotator


+ (Collection *) rotateCollection: (Collection *)collection
{
    Scalinator *scalinator = [[PreCaptureSessionDetails sharedInstance] scalinator];

    Collection *newCollection = [[Collection alloc] init];
    [newCollection loadFromDictionary:[collection renderAsDictionary]];
    [newCollection scaleViewToRoom:scalinator addSizeLabels:NO];
    newCollection.frame = CGRectMake(newCollection.frame.origin.x, newCollection.frame.origin.y, collection.frame.size.height, collection.frame.size.width);
    newCollection.center = collection.center;
    
    NSUInteger len = [collection.imageLayout count];
    
    for (int i=0; i<len; i++) {
        CollectionImage *newCollectionImage = [newCollection.imageLayout objectAtIndex:i];
        CollectionImage *oldCollectionImage = [collection.imageLayout objectAtIndex:i];
        
        newCollectionImage.height = oldCollectionImage.width;
        newCollectionImage.width = oldCollectionImage.height;
        newCollectionImage.x = oldCollectionImage.y;
        newCollectionImage.y = oldCollectionImage.x;
        
        newCollectionImage.frame = CGRectMake(collection.frame.size.height - (oldCollectionImage.frame.origin.y + oldCollectionImage.frame.size.height), oldCollectionImage.frame.origin.x, oldCollectionImage.frame.size.height, oldCollectionImage.frame.size.width);
        if ([oldCollectionImage isKindOfClass:[CollectionFramedImage class]]) {
            newCollectionImage.container.frame = CGRectMake(oldCollectionImage.container.frame.origin.y,
                                                  oldCollectionImage.container.frame.origin.x,
                                                  oldCollectionImage.container.frame.size.height,
                                                  oldCollectionImage.container.frame.size.width);
            newCollectionImage.container.center = [newCollectionImage.superview convertPoint:newCollectionImage.center toView:newCollectionImage];
           
            [(CollectionFramedImage *)newCollectionImage setFrameHeight:[(CollectionFramedImage *)oldCollectionImage frameWidth]];
            [(CollectionFramedImage *)newCollectionImage setFrameWidth:[(CollectionFramedImage *)oldCollectionImage frameHeight]];
            [(CollectionFramedImage *)newCollectionImage setFrameX:[(CollectionFramedImage *)oldCollectionImage frameY]];
            [(CollectionFramedImage *)newCollectionImage setFrameY:[(CollectionFramedImage *)oldCollectionImage frameX]];
            
        } else {
            newCollectionImage.height = oldCollectionImage.width;
            newCollectionImage.width = oldCollectionImage.height;
            
            newCollectionImage.container.frame = newCollectionImage.frame;
            newCollectionImage.container.center = [newCollectionImage.superview convertPoint:newCollectionImage.center toView:newCollectionImage];
        }
        [newCollectionImage addSizeLabel];
        
        if (oldCollectionImage.imageView != nil && oldCollectionImage.imageView.image != nil) {
            [newCollectionImage setImage:oldCollectionImage.imageView.image];
            CGFloat scale = [newCollectionImage getMinimumScaleForImage];
            
            CGAffineTransform currentTransform = newCollectionImage.imageView.transform;
            CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);

            [newCollectionImage.imageView setTransform:newTransform];

            newCollectionImage.imageView.center = [newCollectionImage convertPoint:newCollectionImage.container.center toView:newCollectionImage.container];
            
            oldCollectionImage.imageView.image = nil;
            
        }
        
    }
    [collection.superview addSubview:newCollection];
    [collection removeFromSuperview];


    return newCollection;
}

+ (CGFloat)minimumScaleForImage: (UIImage *)image inBounds:(CGSize)bounds
{
    CGFloat horizontalRatio = bounds.width / image.size.width;
    CGFloat verticalRatio = bounds.height / image.size.height;
    return MAX(horizontalRatio, verticalRatio);
}



+ (CGFloat) convertDegreesToRadians: (CGFloat) degrees
{
    return degrees * (M_PI / 180);
}
@end
