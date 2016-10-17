//
//  ShareTemplateViewController.m
//  precapture
//
//  Created by Randy Crafton on 8/12/12.
//  Copyright (c) 2012 Preveal. All rights reserved.
//

#import "ShareTemplateViewController.h"
#import "DemoRoomViewController.h"

@interface ShareTemplateViewController ()

@end

@implementation ShareTemplateViewController

@synthesize demoRoomController, popoverController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.contentSizeForViewInPopover = CGSizeMake(200, 90);

}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    [popoverController dismissPopoverAnimated:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Saved" message:@"The template was saved to your camera roll" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    [alert show];
}

- (IBAction)emailButtonPressed:(id)sender
{
    [popoverController dismissPopoverAnimated:YES];
    [demoRoomController emailButtonPressed:self];
}

- (IBAction)cameraRollButtonPressed:(id)sender
{
    UIImageWriteToSavedPhotosAlbum([demoRoomController renderRoomViewToImage], self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [self emailButtonPressed:self];
    } else if (indexPath.row == 1) {
        [self cameraRollButtonPressed:self];
    }

}

@end
