//
//  FrameOptionsViewController.m
//  precapture
//
//  Created by Randy Crafton on 4/6/13.
//  Copyright (c) 2013 Preveal. All rights reserved.
//

#import "FrameOptionsViewController.h"
#import "TemplateCreationViewController.h"
#import "Collection.h"


@implementation FrameOptionsViewController

@synthesize templateViewController, slider, sliderLabel, sliderEnabled, sliderInitialValue, lastSliderValue;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.contentSizeForViewInPopover = CGSizeMake(190, 125);
    self.preferredContentSize = CGSizeMake(190, 125);

    [self.navigationController setNavigationBarHidden:YES];
}
 - (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    sliderLabel.text = @"0";
    slider.enabled = sliderEnabled;
    if (sliderEnabled == YES) {
        slider.value = sliderInitialValue*1.0;
        [self setSliderLabelText];
    }
}


- (IBAction)doneButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)noFrameButtonPressed:(id)sender
{
    slider.value = 0;
    slider.enabled = NO;
    sliderLabel.text = @"0";
    [templateViewController noFrameButtonPressed:sender];
}
- (IBAction)blackFrameButtonPressed:(id)sender
{
    [self enableSlider];
    [templateViewController blackFrameButtonPressed:sender];
}
- (IBAction)brownFrameButtonPressed:(id)sender
{
    [self enableSlider];
    [templateViewController woodFrameButtonPressed:sender];
    
}
- (IBAction)whiteFrameButtonPressed:(id)sender
{
    [self enableSlider];
    [templateViewController whiteFrameButtonPressed:sender];
    
}
- (IBAction)matteSizeSliderChanged:(id)sender
{
    if (lastSliderValue != round(slider.value)) {
        [self setSliderLabelText];
        [templateViewController frameSliderChanged:sender];
        lastSliderValue = round(slider.value);
    }
}

- (void) setSliderLabelText
{
    NSDecimalNumber *matWidth = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%d", (int) round(slider.value -1.)]];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults objectForKey:@"unitOfMeasure" ] isEqualToString:@"metric"])
    {
        matWidth = [matWidth decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"2.54"]];
        
        NSDecimalNumberHandler *handler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain
                                                                                                 scale:1
                                                                                      raiseOnExactness:NO
                                                                                       raiseOnOverflow:NO
                                                                                      raiseOnUnderflow:NO
                                                                                   raiseOnDivideByZero:NO];
        matWidth = [matWidth decimalNumberByRoundingAccordingToBehavior:handler];

        sliderLabel.text = [NSString stringWithFormat:@"%@ cm", matWidth];
    } else {
        sliderLabel.text = [NSString stringWithFormat:@"%@ in", matWidth];
    }
}
- (void) enableSlider
{
    if (slider.enabled == NO) {
        slider.value = 3.0;
        slider.enabled = YES;
        [self setSliderLabelText];
        self.lastSliderValue = slider.value;
    }
    
}

@end
