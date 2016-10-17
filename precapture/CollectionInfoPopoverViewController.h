//
//  CollectionInfoPopoverViewController.h
//  precapture
//
//  Created by Randy Crafton on 6/20/12.
//  Copyright (c) 2012 Preveal. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Collection;
@class DemoRoomViewController;

@interface CollectionInfoPopoverViewController : UIViewController {
    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *descriptionLabel;
    IBOutlet UILabel *priceLabel;
    IBOutlet UILabel *price2Label;
    IBOutlet UILabel *price3Label;
    IBOutlet UILabel *price4Label;
    IBOutlet UILabel *priceDescriptionLabel;
    IBOutlet UILabel *price2DescriptionLabel;
    IBOutlet UILabel *price3DescriptionLabel;
    IBOutlet UILabel *price4DescriptionLabel;
    IBOutlet UIButton *faveButton;
    
    Collection *currentCollection;
    DemoRoomViewController *demoController;
}

@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, retain) IBOutlet UILabel *priceLabel;
@property (nonatomic, retain) IBOutlet UILabel *price2Label;
@property (nonatomic, retain) IBOutlet UILabel *price3Label;
@property (nonatomic, retain) IBOutlet UILabel *price4Label;
@property (nonatomic, retain) IBOutlet UILabel *priceDescriptionLabel;
@property (nonatomic, retain) IBOutlet UILabel *price2DescriptionLabel;
@property (nonatomic, retain) IBOutlet UILabel *price3DescriptionLabel;
@property (nonatomic, retain) IBOutlet UILabel *price4DescriptionLabel;
@property (nonatomic, retain) IBOutlet UIButton *faveButton;


@property (nonatomic, retain) Collection *currentCollection;
@property (nonatomic, retain) DemoRoomViewController *demoController;

- (IBAction)faveButtonTouched:(id)sender;
- (IBAction)buildButtonTouched:(id)sender;


@end
