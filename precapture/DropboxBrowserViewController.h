//
//  DropboxBrowserViewController.h
//  precapture
//
//  Created by Randy Crafton on 4/5/15.
//  Copyright (c) 2015 Preveal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropboxViewControllerDelegateProtocol.h"

@class DBFilesystem;
@class DBPath;

@interface DropboxBrowserViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, DBRestClientDelegate>

@property (nonatomic, retain) IBOutlet UICollectionView *collectionView;
@property (nonatomic, retain) DBFilesystem *filesystem;
@property (nonatomic, retain) DBPath *root;
@property (nonatomic, retain) DBPath *currentPath;
@property (nonatomic, retain) NSTimer *myReloadTimer;

@property (nonatomic, retain) NSArray *currentDirectoryContents;
@property (nonatomic, retain) id <DropboxViewControllerDelegateProtocol> delegate;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *backButton;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *acticityView;
@property (nonatomic, retain) IBOutlet UIView *activityViewBackground;

@property (nonatomic, strong) DBRestClient *restClient;

- (IBAction)touchedBackButton:(id)sender;
- (IBAction)touchedCloseButton:(id)sender;
@end
