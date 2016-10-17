//
//  CollectionDetailEditViewController.h
//  precapture
//
//  Created by Randy Crafton on 6/20/12.
//  Copyright (c) 2012 Preveal. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Collection;

@interface CollectionDetailEditViewController : UIViewController 



@property (nonatomic, retain) IBOutlet UITextField *nameField;
@property (nonatomic, retain) IBOutlet UITextView *descriptionField;
@property (nonatomic, retain) IBOutlet UITextField *priceDescriptionField;
@property (nonatomic, retain) IBOutlet UITextField *price2DescriptionField;
@property (nonatomic, retain) IBOutlet UITextField *price3DescriptionField;
@property (nonatomic, retain) IBOutlet UITextField *price4DescriptionField;

@property (nonatomic, retain) IBOutlet UITextField *priceField;
@property (nonatomic, retain) IBOutlet UITextField *price2Field;
@property (nonatomic, retain) IBOutlet UITextField *price3Field;
@property (nonatomic, retain) IBOutlet UITextField *price4Field;
@property (nonatomic, retain) IBOutlet UITextField *otherPriceField;

@property (nonatomic, retain) IBOutlet UIView *collectionPreviewView;
@property (nonatomic, retain) Collection *currentCollection;
@property (nonatomic, assign) CGPoint originalCenter;
@property (nonatomic, retain) IBOutlet UISwitch *showCollectionSwitch;
@property (nonatomic, retain) IBOutlet UISwitch *favoriteSwitch;

@property (nonatomic, retain) IBOutlet UIImageView *uploadText;
@property (nonatomic, retain) IBOutlet UISwitch *uploadSwitch;
@property (nonatomic, assign) BOOL showUpload;
@property (nonatomic, retain) UIViewController *previousViewController;
@property (nonatomic, retain) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet MIBadgeButton *smoochMessageButton;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;
@end
