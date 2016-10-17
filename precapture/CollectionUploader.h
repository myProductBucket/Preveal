//
//  CollectionUploader.h
//  precapture
//
//  Created by Randy Crafton on 3/23/13.
//  Copyright (c) 2013 Preveal. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Collection;

@interface CollectionUploader : NSObject <NSURLConnectionDelegate>
{
    Collection *currentCollection;
}

@property (nonatomic, retain) Collection *currentCollection;

+ (void) saveCollectionToServer: (Collection *) collection;

@end
