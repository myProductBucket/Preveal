//
//  PrevealSlidingViewController.m
//  precapture
//
//  Created by Randy Crafton on 3/21/15.
//  Copyright (c) 2015 Preveal. All rights reserved.
//

#import "PrevealSlidingViewController.h"
#import "HamburglerMenuViewController.h"
#import "DemoRoomViewController.h"
#import "Collection.h"

#import "HomeScreenViewController.h"

@interface PrevealSlidingViewController ()

@end

@implementation PrevealSlidingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.peakAmount = 320;
    
    
//    HomeScreenViewController *homeScreenVC = [[HomeScreenViewController alloc] init];
//    self.topViewController = homeScreenVC;
    self.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeScreenViewController"];
    self.leftSideViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HamburglerMenuViewController"];
    self.topViewOffsetY = 0; // Had to do this in the  SCSlidingViewController source. Don't love that.
    [self.view removeGestureRecognizer:self.panGesture];
    /**
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
     **/
}

- (void)didChangeTopViewController {
    [super didChangeTopViewController];
    [(HamburglerMenuViewController *)self.leftSideViewController reloadData];

}

- (void) willBeginSliding
{
    [(HamburglerMenuViewController *)self.leftSideViewController resetBackgroundViews];

}

- (void)snapToOrigin;
{
    // Adding in a method hook.
    [self willBeginSliding];
    [super snapToOrigin];
    
    // More nasty coupling for now.
    [(HamburglerMenuViewController *)self.leftSideViewController reloadData];
    
    // This is nasty business..
    if ([self.topViewController isKindOfClass:[DemoRoomViewController class]]){
        Collection *previousCollection = [(DemoRoomViewController *)self.topViewController previousCollection];
        [NSTimer scheduledTimerWithTimeInterval:.4 target:previousCollection selector:@selector(unhide) userInfo:nil repeats:NO];
       // previousCollection.hidden = NO;
    }
}

- (void) keyboardDidShow:(NSNotification *)aNotification
{

}

- (void) keyboardDidHide:(NSNotification *)aNotification
{

}
@end
