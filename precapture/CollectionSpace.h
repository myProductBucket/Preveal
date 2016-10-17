//
//  CollectionSpace.h
//  precapture
//
//  Created by Randy Crafton on 3/10/12.
//  Copyright (c) 2012 TouchSpring Design. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CollectionElementProtocol.h"


@class Collection;

@interface CollectionSpace : UIView <CollectionElementProtocol>
{
    NSString *spaceType;
    int width;
    int height;
    int x;
    int y;
    int spaceShift;
    CGRect originalFrame;
    Collection *myCollection;
}

@property (nonatomic, retain) NSString *spaceType;
@property (nonatomic, assign) int width;
@property (nonatomic, assign) int height;
@property (nonatomic, assign) int x;
@property (nonatomic, assign) int y;


@property (nonatomic, assign) int spaceShift;
@property (nonatomic, assign) CGRect originalFrame;
@property (nonatomic, retain) Collection *myCollection;


@end
