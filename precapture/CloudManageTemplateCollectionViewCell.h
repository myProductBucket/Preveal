//
//  CloudManageTemplateCollectionViewCell.h
//  precapture
//
//  Created by Randy Crafton on 4/4/15.
//  Copyright (c) 2015 Preveal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ManageTemplateCollectionViewCell.h"

@interface CloudManageTemplateCollectionViewCell : ManageTemplateCollectionViewCell
@property (nonatomic, retain) IBOutlet UIButton *downloadButton;
@property (nonatomic, retain) IBOutlet UIButton *infoButton;

- (IBAction)downloadButtonTouched:(id)sender;
- (IBAction)infoButtonTouched:(id)sender;
- (void) setDownloadButtonImageToDownloadedState;

@end
