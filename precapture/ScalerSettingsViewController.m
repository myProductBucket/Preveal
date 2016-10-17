//
//  ScalerSettingsViewController.m
//  precapture
//
//  Created by Randy Crafton on 5/2/13.
//  Copyright (c) 2013 Preveal. All rights reserved.
//

#import "ScalerSettingsViewController.h"
#import "SetRoomImageViewController.h"


@interface ScalerSettingsViewController ()

@end

@implementation ScalerSettingsViewController

@synthesize a4Button, letterButton, roomImageVC, imperialButton, metricButton;


- (void) viewDidLoad
{
    self.contentSizeForViewInPopover = CGSizeMake(270, 125);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *paperSize = [defaults objectForKey:@"paperSize"];
    if ([paperSize isEqualToString:@"letter"]) {
        letterButton.selected = YES;
    } else {
        a4Button.selected = YES;
    }
    NSString *unitOfMeasure = [defaults objectForKey:@"unitOfMeasure"];
    if (unitOfMeasure == nil) {
        unitOfMeasure = @"imperial";
        [defaults setObject:unitOfMeasure forKey:@"unitOfMeasure"];
        [defaults synchronize];
    }
    
    if ([unitOfMeasure isEqualToString:@"imperial"]) {
        imperialButton.selected = YES;
    } else {
        metricButton.selected = YES;
    }
}
#pragma mark - 
#pragma todo
- (IBAction)a4ButtonPressed:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *paperSize = @"a4";
    [defaults setObject:paperSize forKey:@"paperSize"];
    [defaults synchronize];
    /*
    [roomImageVC setupScalerRectView];
    roomImageVC.scalerRectView.hidden = NO;
    letterButton.selected = NO;
    a4Button.selected = YES;
     */
}

- (IBAction)letterButtonPressed:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *paperSize = @"letter";
    [defaults setObject:paperSize forKey:@"paperSize"];
    [defaults synchronize];
    /**
    [roomImageVC setupScalerRectView];
    roomImageVC.scalerRectView.hidden = NO;
     **/
    letterButton.selected = YES;
    a4Button.selected = NO;
}


- (IBAction)metricButtonPressed:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *unitOfMeasure = @"metric";
    [defaults setObject:unitOfMeasure forKey:@"unitOfMeasure"];
    [defaults synchronize];
    imperialButton.selected = NO;
    metricButton.selected = YES;
}
- (IBAction)imperialButtonPressed:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *unitOfMeasure = @"imperial";
    [defaults setObject:unitOfMeasure forKey:@"unitOfMeasure"];
    [defaults synchronize];
    imperialButton.selected = YES;
    metricButton.selected = NO;
}


@end
