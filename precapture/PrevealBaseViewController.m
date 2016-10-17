//
//  PrevealBaseViewController.m
//  precapture
//
//  Created by Randy Crafton on 3/20/15.
//  Copyright (c) 2015 Preveal. All rights reserved.
//

#import "PrevealBaseViewController.h"
#import "PrevealRootNavigationController.h"
#import "SCSlidingViewController.h"

@interface PrevealBaseViewController ()

@end

@implementation PrevealBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)toggleHamburgler:(id)sender
{
    
    [self.slidingViewController slideRight];
}

- (SCSlidingViewController *)slidingViewController
{
    UIViewController *viewController = self.parentViewController;
    while (!(viewController == nil || [viewController isKindOfClass:[SCSlidingViewController class]])) {
        viewController = viewController.parentViewController;
    }
    if ([self.parentViewController isKindOfClass:[PrevealRootNavigationController class]] &&
        (viewController == nil || ![viewController isKindOfClass:[SCSlidingViewController class]])) {
        PrevealRootNavigationController *rootController = (PrevealRootNavigationController *)self.parentViewController;
        for (UIViewController *controller in rootController.viewControllers) {
            if ([controller isKindOfClass:[SCSlidingViewController class]]) {
                viewController = controller;
                break;
            }
        }
    }
    
    return (SCSlidingViewController *)viewController;
}

@end
