//
//  MyDBMetadata.h
//  precapture
//
//  Created by Daniel Muller on 28/04/16.
//  Copyright © 2016 JSA Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyDBMetadata : NSObject {
    DBMetadata *metadata;
    NSString *thumbnailPath;//local path
}

@property (nonatomic, retain) DBMetadata *metadata;
@property (nonatomic, retain) NSString *thumbnailPath;//local path

//- (id)init;
- (id)initWithMetadata: (DBMetadata *)meta;
- (id)initWithMetadata: (DBMetadata *)meta andThumbnailPath: (NSString *)desPath;

@end
