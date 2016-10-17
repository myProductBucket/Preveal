//
//  CommunityCollectionInfoViewController.m
//  precapture
//
//  Created by Randy Crafton on 5/22/13.
//  Copyright (c) 2013 Preveal. All rights reserved.
//

#import "CommunityCollectionInfoViewController.h"
#import "Collection.h"
#import <QuartzCore/QuartzCore.h>
#import "Scalinator.h"
#import "PrevealCommunityUrls.h"
#import "LoginManager.h"
#import "CollectionManagementViewController.h"
#import "Collections.h"


@interface CommunityCollectionInfoViewController ()

@end


@implementation CommunityCollectionInfoViewController

@synthesize collectionTitle, collectionTitle2, studioName, studioURL, collectionView, currentCollection;
@synthesize closeButton, flagButton, downloadButton, previousViewController;

- (void) viewDidLoad
{
    collectionView.layer.cornerRadius = 5.0;
    collectionTitle.text = currentCollection.name;
    collectionTitle2.text = currentCollection.name;
    studioName.text = currentCollection.studioName;
    studioURL.text = currentCollection.studioUrl;
    

    if (currentCollection.layoutLoaded != YES) {
        [currentCollection addLayout];
    }
    Scalinator *scalinator = [[Scalinator alloc] init];
    CGFloat referenceSize = 60.0;
    scalinator.actualSize = [NSDecimalNumber decimalNumberWithString:@"11"];
    BOOL fits = NO;
    while (fits == NO) {
        scalinator.referenceSize = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f", referenceSize]];
        
        [currentCollection scaleViewToRoom:scalinator];
        if (currentCollection.frame.size.width <= collectionView.frame.size.width
            && currentCollection.frame.size.height <= collectionView.frame.size.height) {
            fits = YES;
        } else {
            referenceSize = referenceSize - 5.0;
            scalinator.ratio = nil;
            currentCollection.scaled = NO;
        }
        if (referenceSize <= 1) { fits = YES; } //halt if the scaling fails
    }
       
    currentCollection.center = collectionView.center;//CGPointMake(collectionView.center.x, collectionView.center.y);
    currentCollection.center = [collectionView convertPoint:collectionView.center fromView:self.view];
    [collectionView addSubview:currentCollection];
}

- (IBAction)closeButtonTouched:(id)sender
{
    [previousViewController viewWillAppear:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)downloadButtonTouched:(id)sender
{
    // Make this the last in "My Collections"
    NSError *error = nil;
    Collections *myCollections = [[Collections alloc] init];
    [myCollections setAllCollections:[(CollectionManagementViewController *) previousViewController collections].allCollections];
    [myCollections setCurrentGroupName:kPrevealMyCollectionsGroupName error:&error];
    if (error == nil) {
        currentCollection.order = [NSString stringWithFormat:@"%lu", [myCollections.currentGroup count] + 1];
    }
    [(CollectionManagementViewController *) previousViewController setShouldLoadLastTemplateInPreviousViewController];

    
    // Anal cleansing
    myCollections.allCollections = nil;
    myCollections.currentGroup = nil;
    myCollections = nil;
    
    
    // Set the group name to the my collections group.
    currentCollection.groupName = kPrevealMyCollectionsGroupName;
    [currentCollection saveToFile];
    
    // Increment the download count for popularity rankings.
    dispatch_async(dispatch_get_main_queue(), ^{
        NSURL *url = [PrevealCommunityUrls getDownloadedDocumentPathForDocumentWithId:currentCollection.file_name];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
        [request setHTTPMethod:@"PUT"];
        
        [NSURLConnection connectionWithRequest:request delegate:nil];
    });
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)flagButtonTouched:(id)sender
{
    NSURL *url = [PrevealCommunityUrls getFlagDocumentPathForDocumentWithId:currentCollection.file_name
                                                                   userName:[[LoginManager sharedInstance] getSavedUserName]
                                                                  andReason:@""];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"PUT"];
    
    [NSURLConnection connectionWithRequest:request delegate:nil];
    [[self presentingViewController] viewWillAppear:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

@end
