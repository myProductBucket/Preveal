//
//  CollectionUploader.m
//  precapture
//
//  Created by Randy Crafton on 3/23/13.
//  Copyright (c) 2013 Preveal. All rights reserved.
//

#import "CollectionUploader.h"
#import "Collection.h"
#import "PrevealCommunityUrls.h"


@implementation CollectionUploader

@synthesize currentCollection;


+ (void) saveCollectionToServer: (Collection *) collection
{
    collection.groupName = @"community";
    NSURL *url = [PrevealCommunityUrls getSaveDocumentUrl];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];

    NSData *jsonData = [collection asCleanJSONData];

    [request setHTTPBody: jsonData];
    [NSURLConnection connectionWithRequest:request delegate:[[CollectionUploader alloc] init]];

}

@end

