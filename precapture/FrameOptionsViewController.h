//
//  FrameOptionsViewController.h
//  precapture
//
//  Created by Randy Crafton on 4/6/13.
//  Copyright (c) 2013 Preveal. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TemplateCreationViewController;
@class Collection;

@interface FrameOptionsViewController : UIViewController {
    TemplateCreationViewController *templateViewController;
    IBOutlet UISlider *slider;
    IBOutlet UILabel *sliderLabel;
    BOOL sliderEnabled;
    int sliderInitialValue;
    float lastSliderValue;
}

@property (nonatomic, retain) TemplateCreationViewController *templateViewController;
@property (nonatomic, retain) IBOutlet UISlider *slider;
@property (nonatomic, retain) IBOutlet UILabel *sliderLabel;
@property (nonatomic, assign) BOOL sliderEnabled;
@property (nonatomic, assign) int sliderInitialValue;
@property (nonatomic, assign) float lastSliderValue;

- (IBAction)doneButtonPressed:(id)sender;

- (IBAction)noFrameButtonPressed:(id)sender;
- (IBAction)blackFrameButtonPressed:(id)sender;
- (IBAction)brownFrameButtonPressed:(id)sender;
- (IBAction)whiteFrameButtonPressed:(id)sender;
- (IBAction)matteSizeSliderChanged:(id)sender;
@end
