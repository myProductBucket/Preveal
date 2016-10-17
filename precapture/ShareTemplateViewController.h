//
//  ShareTemplateViewController.h
//  precapture
//
//  Created by Randy Crafton on 8/12/12.
//  Copyright (c) 2012 Preveal. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DemoRoomViewController;

@interface ShareTemplateViewController : UITableViewController {
    DemoRoomViewController *demoRoomController;
    UIPopoverController *popoverController;
}

@property (nonatomic, retain) DemoRoomViewController *demoRoomController;
@property (nonatomic, retain) UIPopoverController *popoverController;

- (IBAction)emailButtonPressed:(id)sender;
- (IBAction)cameraRollButtonPressed:(id)sender;
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;

@end
