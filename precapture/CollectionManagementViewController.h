//
//  CollectionManagementViewController.h
//  precapture
//
//  Created by Randy Crafton on 7/3/12.
//  Copyright (c) 2012 Preveal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrevealBaseViewController.h"

@class Collection;
@class Collections;
@class CollectionMgmtView;
@class InAppPurchaseController;
@class CollectionMgmtQuickView;

@interface CollectionManagementViewController : PrevealBaseViewController <UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    IBOutlet UIScrollView *templateScrollView;
    Collections *collections;
    Collection *currentlyEditing;
    InAppPurchaseController *purchaser;
    IBOutlet UIPageControl *singlesPageControl;
    IBOutlet UILabel *textPageRepresentaion;
    IBOutlet UIView *singlesPageControlBackground;
    IBOutlet UIPageControl *collectionsPageControl;
    IBOutlet UIImageView *manageTitle;
    NSArray *manageTitleIndexes;
    
    IBOutlet UIView *groupRibbon;
    IBOutlet UIButton *prevealGroupButton;
    IBOutlet UIButton *singleImageGroupButton;
    IBOutlet UIButton *prodpiGroupButton;
    IBOutlet UIButton *bayphotoGroupButton;
    IBOutlet UIButton *dagBundle1GroupButton;
    IBOutlet UIButton *dagCollectionOneGroupButton;
    IBOutlet UIButton *favoritesGroupButton;
    IBOutlet UIButton *communityGroupButton;
    IBOutlet UIButton *myTemplatesGroupButton;
    IBOutlet UIButton *lastGroupButton;
    IBOutlet UIActivityIndicatorView *activityIndicator;
    NSString *selectedBundleIdentifier;
    NSArray *groupIndexes;

    IBOutlet UISegmentedControl *communitySortOptions;
    NSString *currentGroupName;
    NSInteger currentCommunitySortIndex;
    BOOL reverseCommunitySortDirection;
    
    BOOL communityOnlyMode;
    CollectionMgmtQuickView *quickView;
    
    IBOutlet UICollectionView *collectionView;
}

@property (nonatomic, retain) IBOutlet UIScrollView *templateScrollView;
@property (nonatomic, retain) Collections *collections;
@property (nonatomic, retain) Collection *currentlyEditing;
@property (nonatomic, retain) InAppPurchaseController *purchaser;
@property (nonatomic, retain) IBOutlet UIPageControl *singlesPageControl;
@property (nonatomic, retain) IBOutlet UILabel *textPageRepresentaion;
@property (nonatomic, retain) IBOutlet UIView *singlesPageControlBackground;
@property (nonatomic, retain) IBOutlet UIImageView *manageTitle;
@property (nonatomic, retain) NSArray *manageTitleIndexes;

@property (nonatomic, retain) NSString *selectedBundleIdentifier;
@property (nonatomic, retain) NSArray *groupIndexes;

@property (nonatomic, retain) IBOutlet UIView *groupRibbon;
@property (nonatomic, retain) IBOutlet UIButton *prevealGroupButton;
@property (nonatomic, retain) IBOutlet UIButton *singleImageGroupButton;
@property (nonatomic, retain) IBOutlet UIButton *prodpiGroupButton;
@property (nonatomic, retain) IBOutlet UIButton *bayphotoGroupButton;
@property (nonatomic, retain) IBOutlet UIButton *favoritesGroupButton;
@property (nonatomic, retain) IBOutlet UIButton *myTemplatesGroupButton;
@property (nonatomic, retain) IBOutlet UIButton *lastGroupButton;
@property (nonatomic, retain) IBOutlet UIButton *dagBundle1GroupButton;
@property (nonatomic, retain) IBOutlet UIButton *dagCollectionOneGroupButton;
@property (nonatomic, retain) IBOutlet UIButton *communityGroupButton;

@property (nonatomic, retain) CollectionMgmtQuickView *quickView;

@property (nonatomic, retain) IBOutlet UISegmentedControl *communitySortOptions;
@property (nonatomic, retain) NSString *currentGroupName;
@property (nonatomic, assign) NSInteger currentCommunitySortIndex;
@property (nonatomic, assign) BOOL reverseCommunitySortDirection;
@property (nonatomic, assign) BOOL shouldLoadLastMyCollectionsWhenExiting;

@property (nonatomic, assign) BOOL communityOnlyMode;
@property (nonatomic, retain) IBOutlet UIButton *homeButton;
@property (nonatomic, retain) IBOutlet UIButton *backButton;

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIView *fadeView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;

@property (nonatomic, retain) IBOutlet UICollectionView *collectionView;
@property (nonatomic, retain) NSIndexPath *mostRecentIndexPath;
@property (weak, nonatomic) IBOutlet MIBadgeButton *smoochMessageButton;

@property (nonatomic, retain) NSTimer *timer;

- (void)showEditViewForCollection;
- (void)showEditViewForCollection: (Collection *) collection;
- (IBAction)groupButtonPressed:(id)sender;
- (IBAction)didPressBackButton:(id)sender;
- (void) reloadData;
- (IBAction)sortOptionsChanged:(id)sender;
- (void) setShouldLoadLastTemplateInPreviousViewController;


- (void) receiveCollectionCommunicationCompleteNotification: (NSNotification *) notification;
- (void) receiveCollectionCommunicationErroredNotification: (NSNotification *) notification;
- (void) receiveCollectionCommunicationTimedOutNotification: (NSNotification *) notification;
@end
