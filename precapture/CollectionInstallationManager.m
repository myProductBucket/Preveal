//
//  CollectionInstallationManager.m
//  precapture
//
//  Created by Randy Crafton on 3/11/12.
//  Copyright (c) 2012 TouchSpring Design. All rights reserved.
//

#import "CollectionInstallationManager.h"

@implementation CollectionInstallationManager


+ (void)copyCollectionsIfNeeded
{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Collections"];
    NSString *userCollectionsDirectory = [documentsDirectory stringByAppendingPathComponent:@"Collections"];
    [CollectionInstallationManager createCollectionsDirectory:userCollectionsDirectory];
    
    NSError *error = nil;
    NSDirectoryEnumerator *dirEnum =   [[NSFileManager defaultManager] enumeratorAtPath:sourcePath];
    
    NSString *filePath;
    while (filePath = [dirEnum nextObject]) {
        if ([[filePath pathExtension] isEqualToString: @"txt"]) {
            if ([[NSFileManager defaultManager] fileExistsAtPath:[userCollectionsDirectory stringByAppendingPathComponent:filePath]] == NO)
            {
                [[NSFileManager defaultManager] copyItemAtPath:[sourcePath stringByAppendingPathComponent:filePath]
                                                        toPath:[userCollectionsDirectory stringByAppendingPathComponent:filePath]
                                                         error:&error];
                if (error != nil) {
                    NSLog(@"Error installing collection from file path: %@", filePath);
                    NSLog(@"Error description-%@ \n", [error localizedDescription]);
                    NSLog(@"Error reason-%@", [error localizedFailureReason]);
                }
            }
        }
        error = nil;
    }

}

+ (void)createCollectionsDirectory:(NSString *) dirPath
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:dirPath] == NO) {
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:dirPath
                                  withIntermediateDirectories:NO
                                                   attributes:nil
                                                        error:&error];
        if (error != nil) {
            NSLog(@"Error creating collections directory");
            NSLog(@"Error description-%@ \n", [error localizedDescription]);
            NSLog(@"Error reason-%@", [error localizedFailureReason]);
        }
    }
}

@end
