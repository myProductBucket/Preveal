//
//  CollectionInstallationManager.h
//  precapture
//
//  Created by Randy Crafton on 3/11/12.
//  Copyright (c) 2012 TouchSpring Design. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CollectionInstallationManager : NSObject


+ (void)copyCollectionsIfNeeded;
+ (void)createCollectionsDirectory:(NSString *) dirPath;
@end
