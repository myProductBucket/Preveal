//
//  CommunityCollectionInfoViewController.h
//  precapture
//
//  Created by Randy Crafton on 5/22/13.
//  Copyright (c) 2013 Preveal. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Collection;
@class CollectionManagementViewController;
@interface CommunityCollectionInfoViewController : UIViewController {
    IBOutlet UIView *collectionView;
    IBOutlet UILabel *collectionTitle;
    IBOutlet UILabel *collectionTitle2;
    IBOutlet UILabel *studioName;
    IBOutlet UILabel *studioURL;
    IBOutlet UIBarButtonItem *closeButton;
    IBOutlet UIButton *flagButton;
    IBOutlet UIButton *downloadButton;
    Collection *currentCollection;
    CollectionManagementViewController *previousViewController;
}

@property (nonatomic, retain) IBOutlet UIView *collectionView;
@property (nonatomic, retain) IBOutlet UILabel *collectionTitle;
@property (nonatomic, retain) IBOutlet UILabel *collectionTitle2;
@property (nonatomic, retain) IBOutlet UILabel *studioName;
@property (nonatomic, retain) IBOutlet UILabel *studioURL;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *closeButton;
@property (nonatomic, retain) IBOutlet UIButton *flagButton;
@property (nonatomic, retain) IBOutlet UIButton *downloadButton;
@property (nonatomic, retain) Collection *currentCollection;
@property (nonatomic, retain) CollectionManagementViewController *previousViewController;


- (IBAction)closeButtonTouched:(id)sender;
- (IBAction)downloadButtonTouched:(id)sender;
- (IBAction)flagButtonTouched:(id)sender;
@end
