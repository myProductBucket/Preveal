//
//  MyDropbox.m
//  precapture
//
//  Created by Daniel Muller on 21/04/16.
//  Copyright © 2016 JSA Technologies. All rights reserved.
//

#import "MyDropbox.h"

@implementation MyDropbox

static MyDropbox *sharedInstance = nil;

//@synthesize dbFilesystem;
@synthesize dbRestClient;

+ (MyDropbox *) sharedInstance {
    if (sharedInstance == nil) {
        sharedInstance = [[MyDropbox alloc] init];
        
    }
    return sharedInstance;
}

//- (DBFilesystem *)getDBFilesystem {
//    if (dbFilesystem == nil) {
//        DBAccount *account = [[[DBAccountManager sharedManager] linkedAccounts] objectAtIndex:0];
//        
//        dbFilesystem = [[DBFilesystem alloc] initWithAccount:account];
//    }
//    return dbFilesystem;
//}

- (DBRestClient *)getRestClient {
//    if (dbRestClient != nil) {
//        dbRestClient = nil;
//    }
//    dbRestClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
//    if (dbRestClient == nil) {
//        dbRestClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
//    }
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:DROPBOX_RECONNECT] || ([[NSUserDefaults standardUserDefaults] objectForKey:DROPBOX_RECONNECT] == [NSNumber numberWithBool:YES])) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:DROPBOX_RECONNECT];
        dbRestClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
    }else{
        if (dbRestClient == nil) {
            dbRestClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        }
    }
    
    self.dbRestClient = dbRestClient;
    return dbRestClient;
}

@end
