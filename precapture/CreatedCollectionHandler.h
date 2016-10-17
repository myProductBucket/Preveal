//
//  CreatedCollectionSaver.h
//  precapture
//
//  Created by Randy Crafton on 1/19/13.
//  Copyright (c) 2013 Preveal. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Collection;

@interface CreatedCollectionHandler : NSObject {
    Collection *collection;
    NSMutableArray *openings;
}

@property (nonatomic, retain) Collection *collection;
@property (nonatomic, retain) NSMutableArray *openings;


- (Collection *) handleCollectionCreationWithOpenings: (NSMutableArray *) withOpenings;



@end
