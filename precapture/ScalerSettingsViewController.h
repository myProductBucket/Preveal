//
//  ScalerSettingsViewController.h
//  precapture
//
//  Created by Randy Crafton on 5/2/13.
//  Copyright (c) 2013 Preveal. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SetRoomImageViewController;

@interface ScalerSettingsViewController : UIViewController {
    SetRoomImageViewController *roomImageVC;
    IBOutlet UIButton *a4Button;
    IBOutlet UIButton *letterButton;
    IBOutlet UIButton *imperialButton;
    IBOutlet UIButton *metricButton;
}

@property (nonatomic, retain) SetRoomImageViewController *roomImageVC;
@property (nonatomic, retain) IBOutlet UIButton *a4Button;
@property (nonatomic, retain) IBOutlet UIButton *letterButton;
@property (nonatomic, retain) IBOutlet UIButton *imperialButton;
@property (nonatomic, retain) IBOutlet UIButton *metricButton;

- (IBAction)a4ButtonPressed:(id)sender;
- (IBAction)letterButtonPressed:(id)sender;
- (IBAction)metricButtonPressed:(id)sender;
- (IBAction)imperialButtonPressed:(id)sender;
@end
