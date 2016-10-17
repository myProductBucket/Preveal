//
//  VersionManager.h
//  precapture
//
//  Created by Randy Crafton on 7/28/12.
//  Copyright (c) 2012 Preveal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VersionManager : NSObject {
    NSString *docDir;
}

@property (nonatomic, retain) NSString *docDir;


+ (void) performUpdates;
- (void) performUpdatesFor1_1;
- (void) performUpdatesFor1_2;
- (void) performUpdatesFor1_3;

@end
