//
//  SetRoomImageViewController.h
//  precapture
//
//  Created by Randy Crafton on 3/9/12.
//  Copyright (c) 2012 TouchSpring Design. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrevealBaseViewController.h"
#import "DropboxViewControllerDelegateProtocol.h"

@interface SetRoomImageViewController : PrevealBaseViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate, DropboxViewControllerDelegateProtocol>


@property (nonatomic, assign) CGFloat actualSizeOfScale;
/* -- Scaling Stuff -- */
@property (nonatomic, assign) CGFloat _lastScale;
@property (nonatomic, assign) CGFloat _lastRotation;
@property (nonatomic, assign) CGFloat _totalRotation;
@property (nonatomic, assign) CGFloat _firstX;
@property (nonatomic, assign) CGFloat _firstY;
@property (nonatomic, assign) CGAffineTransform initialRotationTransform;
@property (nonatomic, assign) BOOL shouldSaveToCameraRoll;


@property (nonatomic, retain) IBOutlet UIButton *photoLibraryButton;
@property (nonatomic, retain) IBOutlet UIButton *cameraButton;
@property (nonatomic, retain) IBOutlet UIButton *dropBoxButton;
@property (nonatomic, retain) IBOutlet UIButton *acceptButton;

@property (nonatomic, retain) IBOutlet UIImageView *logoImageView;
@property (nonatomic, retain) IBOutlet UIView *scalerRectView;
@property (nonatomic, retain) IBOutlet UIImageView *roomImageView;

@property (weak, nonatomic) IBOutlet UILabel *buildVersionLabel;
@property (weak, nonatomic) IBOutlet MIBadgeButton *smoochMessageButton;

@property (nonatomic, retain) UIImagePickerController *imagePickerController;
@property (nonatomic, retain) UIPopoverController *popoverController;


- (IBAction)setRoomImageFromPhotoLibraryButtonPressed:(id)sender;
- (IBAction)setRoomImageFromCameraButtonPressed:(id)sender;
- (IBAction)setRoomImageFromDropBoxButtonPressed:(id)sender;
- (IBAction)setRoomScaleButtonPressed:(id)sender;
- (void) switchActualSizeOfScale;

- (IBAction)scale:(id)sender;
- (IBAction)move:(id)sender;
- (IBAction)rotate:(id)sender;
@end
