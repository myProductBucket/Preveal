//
//  MyDropbox.h
//  precapture
//
//  Created by Daniel Muller on 21/04/16.
//  Copyright © 2016 JSA Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DropboxSDK/DropboxSDK.h>

@interface MyDropbox : NSObject {
//    DBFilesystem *dbFilesystem;
    DBRestClient *dbRestClient;
}

//@property (nonatomic, retain) DBFilesystem *dbFilesystem;
@property (nonatomic, retain) DBRestClient *dbRestClient;


+ (MyDropbox *) sharedInstance;
//- (DBFilesystem *) getDBFilesystem;
- (DBRestClient *)getRestClient;

@end
