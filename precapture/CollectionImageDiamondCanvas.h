//
//  CollectionImageDiamondCanvas.h
//  precapture
//
//  Created by Randy Crafton on 12/20/12.
//  Copyright (c) 2012 Preveal. All rights reserved.
//

#import "CollectionImage.h"

@class CollectionImageDiamondContainer;
@interface CollectionImageDiamondCanvas : CollectionImage{
    CollectionImageDiamondContainer *diamondContainer;
}

@property (nonatomic, retain) CollectionImageDiamondContainer *diamondContainer;
@end
