//
//  CollectionImage.h
//  precapture
//
//  Created by Randy Crafton on 3/10/12.
//  Copyright (c) 2012 TouchSpring Design. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CollectionElementProtocol.h"
#import "CollectionImageDelegateProtocol.h"


@class Collection;
@class GestureHandler;

@interface CollectionImage : UIView <CollectionElementProtocol, UIGestureRecognizerDelegate, UIScrollViewDelegate, NSCopying>
{
    NSString *imageType;

    NSDecimalNumber *width;
    NSDecimalNumber *height;
    NSDecimalNumber *x;
    NSDecimalNumber *y;
    int useBorder;
    id <CollectionImageDelegateProtocol> delegate;
    UIImageView *imageView;
    UIView *container;
    UILabel *sizeLabel;
    
    CGRect originalFrame;
    Collection *myCollection;
    GestureHandler *myGestureHandler;
    
    /*** Panning Stuff ***/
    CGFloat _lastScale;
    CGFloat _firstX;
	CGFloat _firstY;
    
    CGFloat _draggingFirstX;
    CGFloat _lightboxLastScale;

}

@property (nonatomic, retain) NSString *imageType;

@property (nonatomic, retain) NSDecimalNumber *width;
@property (nonatomic, retain) NSDecimalNumber *height;
@property (nonatomic, retain) NSDecimalNumber *x;
@property (nonatomic, retain) NSDecimalNumber *y;


@property (nonatomic, assign) int useBorder;
@property (nonatomic, assign) CGRect originalFrame;
@property (nonatomic, retain) Collection *myCollection;
@property (nonatomic, retain) GestureHandler *myGestureHandler;
@property (nonatomic, retain) id <CollectionImageDelegateProtocol> delegate;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UIView *container;
@property (nonatomic, retain) UILabel *sizeLabel;
@property (nonatomic, assign) CGFloat _lightboxLastScale;



- (void)configureGestureRecognizers;
- (void)removeGestureRecognizers;
- (void)touched:(id) sender;
- (void)setImage: (UIImage *) newImage;
- (UIImage *)image;
- (NSString *) getSizeAsString;
- (CGFloat) getMinimumScaleForImage;
- (void)addMask;
- (void) setInitialFrame;
- (void) configureViewDetails;
- (CollectionImage *) duplicate;
@end
