//
//  ManageTemplateCollectionViewCell.h
//  precapture
//
//  Created by Randy Crafton on 4/2/15.
//  Copyright (c) 2015 Preveal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ManageTemplateCellDelegate.h"

@class Collection;

@interface ManageTemplateCollectionViewCell : UICollectionViewCell <UIAlertViewDelegate>

@property(nonatomic, weak) IBOutlet id<ManageTemplateCellDelegate> delegate;


@property (nonatomic, retain) IBOutlet Collection *collection;
@property (nonatomic, retain) IBOutlet UIButton *collectionVisibleButton;
@property (nonatomic, retain) IBOutlet UIButton *collectionFavoritedButton;
@property (nonatomic, retain) IBOutlet UIButton *editDetailsButton;
@property (nonatomic, retain) IBOutlet UIButton *deleteButton;
@property (nonatomic, retain) IBOutlet UILabel *templateNameLabel;

@property (nonatomic, retain) IBOutlet UIView *templateView;
@property (nonatomic, retain) UIActivityIndicatorView *activityView;

- (void) setMyCollection:(Collection *)myCollection;

- (IBAction)didTouchFavoriteButton:(id)sender;
- (IBAction)didTouchDeleteButton:(id)sender;
- (IBAction)didTouchShowButton:(id)sender;
- (IBAction)didTouchEditButton:(id)sender;
- (IBAction)putInWaitingState:(id)sender;
- (void) clearActivityView;
@end
