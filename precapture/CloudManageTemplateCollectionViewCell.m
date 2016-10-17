//
//  CloudManageTemplateCollectionViewCell.m
//  precapture
//
//  Created by Randy Crafton on 4/4/15.
//  Copyright (c) 2015 Preveal. All rights reserved.
//

#import "CloudManageTemplateCollectionViewCell.h"
#import "Collection.h"
#import "ManageTemplateCollectionViewCell.h"
#import "Collections.h"
@implementation CloudManageTemplateCollectionViewCell

@synthesize downloadButton, infoButton;

- (void) setCollection:(Collection *)collection
{
    [super setCollection:collection];
    NSString *path = [[Collections getUserCollectionsDirectory] stringByAppendingPathComponent:collection.file_name];
    
    
    // Reset the button so we play nicer.
    CGRect newRect = CGRectMake(33, 111, 25, 25);
    [self.downloadButton removeFromSuperview];
    self.downloadButton = nil;
    UIButton *newButton = [[UIButton alloc] initWithFrame:newRect];
    [newButton setImage:[UIImage imageNamed:@"community-card-cloud-default.png"] forState:UIControlStateNormal];
    [newButton setImage:[UIImage imageNamed:@"community-card-cloud-active.png"] forState:UIControlStateSelected];
    [newButton setImage:[UIImage imageNamed:@"btn-template-icon-mine-off.png"] forState:UIControlStateDisabled];
    
    
    [newButton addTarget:self action:@selector(downloadButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    self.downloadButton = newButton;
    [self addSubview:self.downloadButton];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [self setDownloadButtonImageToDownloadedState];
    } else {
        [self setDownloadButtonImageToUndownloadedState];
    }
}

- (IBAction)downloadButtonTouched:(id)sender
{
    [self.delegate downloadCollection:self.collection];
    
    [UIView animateWithDuration:0.5f
                     animations:^{
                         NSLog(@"CLicked download: %@", self);
                         self.downloadButton.alpha = 0.3;
                        }
                     completion:^(BOOL finished) {
                        [UIView animateWithDuration:0.5
                                         animations:^{
                                             self.downloadButton.alpha = 1.0f;
                                        
                                         } completion:^(BOOL finished) {

                                             [self setDownloadButtonImageToDownloadedState];
                                         }];
                        }
     ];
}

- (void) setDownloadButtonImageToDownloadedState
{
    self.downloadButton.frame = CGRectMake(downloadButton.frame.origin.x, downloadButton.frame.origin.y, 25, 25);
    [self.downloadButton setImage:[UIImage imageNamed:@"btn-template-icon-mine-off.png"] forState:UIControlStateNormal];
    [self.downloadButton setImage:[UIImage imageNamed:@"btn-template-icon-mine-off.png"] forState:UIControlStateSelected];

    downloadButton.enabled = NO;
}

- (void) setDownloadButtonImageToUndownloadedState
{
    [self.downloadButton setImage:[UIImage imageNamed:@"community-card-cloud-default.png"] forState:UIControlStateNormal];
    [self.downloadButton setImage:[UIImage imageNamed:@"community-card-cloud-active.png"] forState:UIControlStateSelected];

    downloadButton.enabled = YES;
    self.downloadButton.frame = CGRectMake(downloadButton.frame.origin.x, downloadButton.frame.origin.y, 29, 20);
}
- (IBAction)infoButtonTouched:(id)sender
{
    [self.delegate showInfoForCommunityCollection:self.collection];
}

@end
