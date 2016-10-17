//
//  Collection.h
//  precapture
//
//  Created by Randy Crafton on 3/10/12.
//  Copyright (c) 2012 TouchSpring Design. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CollectionElementProtocol.h"
#import "CollectionDelegate.h"

@class CollectionImage;
@class CollectionSpace;
@class Scalinator;


@interface Collection : UIView <UIGestureRecognizerDelegate, NSCopying> {
    /* ------- From Collection Definition --------- */
    NSString *name;
    NSString *price;
    NSString *file_name;
    NSString *description;
    NSString *purchased;
    NSString *free;
    NSString *order;
    NSString *type;
    NSString *inAppPrice;
    NSString *show;
    NSString *price2;
    NSString *price3;
    NSString *price4;
    NSString *priceDescription;
    NSString *price2Description;
    NSString *pirce3Description;
    NSString *price4Description;
    NSString *groupName;
    NSString *isFavorite;
    NSString *initialRotation;
    
    NSArray *imageLayout;
    
    CGFloat currentRotation;
    
    NSString *studioName;
    NSString *studioUrl;
    NSString *createdBy;
    
    /* ------- View related --------- */
    CGRect originalFrame;
    BOOL activeInDemo;
    BOOL layoutLoaded;
    BOOL scaled;
    
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *price;
@property (nonatomic, retain) NSString *file_name;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *purchased;
@property (nonatomic, retain) NSString *free;
@property (nonatomic, retain) NSString *order;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *inAppPrice;
@property (nonatomic, retain) NSString *show;
@property (nonatomic, retain) NSString *price2;
@property (nonatomic, retain) NSString *price3;
@property (nonatomic, retain) NSString *price4;
@property (nonatomic, retain) NSString *priceDescription;
@property (nonatomic, retain) NSString *price2Description;
@property (nonatomic, retain) NSString *price3Description;
@property (nonatomic, retain) NSString *price4Description;
@property (nonatomic, retain) NSString *groupName;
@property (nonatomic, retain) NSString *isFavorite;
@property (nonatomic, retain) NSString *initialRotation;

@property (nonatomic, retain) NSArray *imageLayout;
@property (nonatomic, assign) CGRect originalFrame;
@property (nonatomic, assign) BOOL activeInDemo;
@property (nonatomic, assign) BOOL layoutLoaded;
@property (nonatomic, assign) BOOL scaled;
@property (nonatomic, assign) CGFloat currentRotation;

@property (nonatomic, retain) NSString *studioName;
@property (nonatomic, retain) NSString *studioUrl;
@property (nonatomic, retain) NSString *createdBy;

- (BOOL)isAvailableForUse;
- (void)saveToFile;
- (NSData *) asJSONData;
- (NSData *) asCleanJSONData;
- (void)addLayout;
- (void)scaleViewToRoom:(Scalinator *)scalinator addSizeLabels: (BOOL) addSizeLables;
- (void)scaleViewToRoom: (Scalinator *)scalinator;
- (void)setLayoutImageDelegates:(id) imageDelegate;
- (void) addImageGestures;
- (void) removeImageGestures;
- (void)loadFromDictionary: (NSDictionary *) definition;
- (NSDictionary *)renderAsDictionary;
- (UIImage*) renderToImage;
- (float) totalWidth;
- (float) totalHeight;
- (void) permanentlyDelete;
- (void) unhide;
@end
