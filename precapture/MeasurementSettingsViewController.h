//
//  PR_ScalinatorSettingsViewController.h
//  preveal
//
//  Created by Randy Crafton on 6/24/14.
//  Copyright (c) 2014 Chris and Adrienne Scott. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrevealBaseViewController.h"

@interface MeasurementSettingsViewController : PrevealBaseViewController {
    IBOutlet UIButton *a4Button;
    IBOutlet UIButton *letterButton;
    IBOutlet UIButton *inchesButton;
    IBOutlet UIButton *metricButton;
    IBOutlet UITextField *currencySymbol;
}

@property (nonatomic, retain) IBOutlet UIButton *a4Button;
@property (nonatomic, retain) IBOutlet UIButton *letterButton;
@property (nonatomic, retain) IBOutlet UIButton *inchesButton;
@property (nonatomic, retain) IBOutlet UIButton *metricButton;
@property (nonatomic, retain) IBOutlet UITextField *currencySymbol;
@property (nonatomic, retain) IBOutlet UIButton *nextButton;
@property (nonatomic, retain) IBOutlet UIButton *saveButton;

@property (weak, nonatomic) IBOutlet MIBadgeButton *smoochMessageButton;

@property (weak, nonatomic) IBOutlet UIButton *backButton;

- (IBAction)a4ButtonPressed:(id)sender;
- (IBAction)letterButtonPressed:(id)sender;
- (IBAction)metricButtonPressed:(id)sender;
- (IBAction)inchesButtonPressed:(id)sender;

- (IBAction)dismissLaunchButtonPressed:(id)sender;
- (IBAction)saveButtonPressed:(id)sender;
@end