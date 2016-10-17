//
//  PR_ScalinatorSettingsViewController.m
//  preveal
//
//  Created by Randy Crafton on 6/24/14.
//  Copyright (c) 2014 Chris and Adrienne Scott. All rights reserved.
//

#import "MeasurementSettingsViewController.h"

@interface MeasurementSettingsViewController ()

@end

@implementation MeasurementSettingsViewController

@synthesize a4Button, letterButton, inchesButton, metricButton, currencySymbol, nextButton, saveButton;
@synthesize smoochMessageButton;
@synthesize backButton;


- (void) viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setBadgeNumber) name:SKTConversationUnreadCountDidChangeNotification object:nil];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *paperSize = [defaults objectForKey:@"paperSize"];
    if (paperSize == nil) {
        paperSize = @"letter";
        [defaults setObject:paperSize forKey:@"paperSize"];
        [defaults synchronize];
    }
    
    if ([paperSize isEqualToString:@"letter"]) {
        letterButton.selected = YES;
    } else {
        a4Button.selected = YES;
    }
    NSString *unitOfMeasure = [defaults objectForKey:@"unitOfMeasure"];
    if (unitOfMeasure == nil) {
        unitOfMeasure = @"inches";
        [defaults setObject:unitOfMeasure forKey:@"unitOfMeasure"];
        [defaults synchronize];
    }
    
    if ([unitOfMeasure isEqualToString:@"inches"]) {
        inchesButton.selected = YES;
    } else {
        metricButton.selected = YES;
    }
    
    NSString *currentCurrencySymbol = [defaults objectForKey:@"currencySymbol"];
    if (currentCurrencySymbol == nil) {
        currentCurrencySymbol = @"$";
    }
    currencySymbol.text = currentCurrencySymbol;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setBadgeNumber];
}

- (IBAction)smoochMessageTouchUp:(UIButton *)sender {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:0] forKey:BADGE_NUMBER];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [Smooch showConversationFromViewController:self];
}

- (IBAction)backTouchUp:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)setBadgeNumber {
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if ([[NSUserDefaults standardUserDefaults] objectForKey:BADGE_NUMBER] && [[NSUserDefaults standardUserDefaults] objectForKey:BADGE_NUMBER] != 0) {
            [smoochMessageButton setBadgeBackgroundColor:[UIColor redColor]];
            [smoochMessageButton setBadgeTextColor:[UIColor whiteColor]];
            
            if (![[NSUserDefaults standardUserDefaults] objectForKey:BADGE_NUMBER] || [[[NSUserDefaults standardUserDefaults] objectForKey:BADGE_NUMBER] integerValue] == 0) {
                [smoochMessageButton setBadgeString:nil];
            }else{
                [smoochMessageButton setBadgeString:[NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:BADGE_NUMBER]]];
            }
        }
    });
}

- (IBAction)a4ButtonPressed:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *paperSize = @"a4";
    [defaults setObject:paperSize forKey:@"paperSize"];
    [defaults synchronize];
    letterButton.selected = NO;
    a4Button.selected = YES;
}

- (IBAction)letterButtonPressed:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *paperSize = @"letter";
    [defaults setObject:paperSize forKey:@"paperSize"];
    [defaults synchronize];
    letterButton.selected = YES;
    a4Button.selected = NO;
}


- (IBAction)metricButtonPressed:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *unitOfMeasure = @"metric";
    [defaults setObject:unitOfMeasure forKey:@"unitOfMeasure"];
    [defaults synchronize];
    inchesButton.selected = NO;
    metricButton.selected = YES;
}

- (IBAction)inchesButtonPressed:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *unitOfMeasure = @"inches";
    [defaults setObject:unitOfMeasure forKey:@"unitOfMeasure"];
    [defaults synchronize];
    inchesButton.selected = YES;
    metricButton.selected = NO;
}


- (IBAction)saveButtonPressed:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *currentCurrencySymbol = currencySymbol.text;
    if (currentCurrencySymbol == nil) {
        currentCurrencySymbol = @"$";
    }
    [defaults setObject:currentCurrencySymbol forKey:@"currencySymbol"];
    [defaults synchronize];
    [self.currencySymbol endEditing:YES];
    [UIView animateWithDuration:.5 animations:^{
        self.saveButton.alpha =.3;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.5 animations:^{
            self.saveButton.alpha = 1.0;
        } completion:NULL];
    }];
}
- (IBAction)dismissLaunchButtonPressed:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *currentCurrencySymbol = currencySymbol.text;
    if (currentCurrencySymbol == nil) {
        currentCurrencySymbol = @"$";
    }
    [defaults setObject:currentCurrencySymbol forKey:@"currencySymbol"];
    [defaults synchronize];
    
//    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
//    AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UINavigationController *prevealRootNC = [mainSB instantiateViewControllerWithIdentifier:@"PrevealRootNavigationController"];
    [prevealRootNC setNavigationBarHidden:YES];
//    del.window.rootViewController = prevealRootNC;
    [self.navigationController presentViewController:prevealRootNC animated:YES completion:nil];
}

@end
