//
//  SetRoomImageViewController.m
//  precapture
//
//  Created by Randy Crafton on 3/9/12.
//  Copyright (c) 2012 TouchSpring Design. All rights reserved.
//

#import "SetRoomImageViewController.h"
#import "PreCaptureSessionDetails.h"
#import "Scalinator.h"
#import "SCSlidingViewController.h"
#import "DemoRoomViewController.h"
#import "PrevealImageScaler.h"
#import "DropboxBrowserViewController.h"
//#import <Dropbox/Dropbox.h>


@interface SetRoomImageViewController ()

@end

@implementation SetRoomImageViewController

@synthesize imagePickerController, popoverController, photoLibraryButton, cameraButton, dropBoxButton, acceptButton;
@synthesize roomImageView, scalerRectView, logoImageView, shouldSaveToCameraRoll;
@synthesize actualSizeOfScale, _lastRotation, _lastScale, _firstX, _firstY, _totalRotation, initialRotationTransform;

@synthesize buildVersionLabel;
@synthesize smoochMessageButton;


#pragma mark -

- (IBAction)smoochMessageTouchUp:(UIButton *)sender {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:0] forKey:BADGE_NUMBER];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [Smooch showConversationFromViewController:self];
}


#pragma mark Setting things up
- (void) viewDidLoad
{
    shouldSaveToCameraRoll = NO;
    _totalRotation = 0.0;
    
    [buildVersionLabel setText:[NSString stringWithFormat:@"VERSION %@(%@)", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"], [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setBadgeNumber) name:SKTConversationUnreadCountDidChangeNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (scalerRectView == nil) {
        [self setupScalerRectView];
    }
    
    [self setBadgeNumber];
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

- (void) setupScalerRectView
{
    [scalerRectView removeFromSuperview];
    self.scalerRectView = nil;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *paperSize = [defaults objectForKey:@"paperSize"];
    if (paperSize == nil) {
        paperSize = @"letter";
        [defaults setObject:paperSize forKey:@"paperSize"];
        [defaults synchronize];
    }
    
    if ([paperSize isEqualToString:@"letter"]) {
        actualSizeOfScale = 11.0;
        scalerRectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 110, 85)];
    } else if ([paperSize isEqualToString:@"a4"]) {
        actualSizeOfScale = 11.7;
        scalerRectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 117, 83)];
    }
    
    
    scalerRectView.center = self.view.center;
    scalerRectView.backgroundColor = [UIColor blackColor];
    scalerRectView.alpha = .3;
    scalerRectView.layer.borderColor = [[UIColor redColor] CGColor];
    scalerRectView.layer.borderWidth = 2;
    scalerRectView.hidden = YES;
    [self.view addSubview:scalerRectView];
    
}



#pragma mark -
#pragma mark Room Setting Buttons

- (IBAction)setRoomImageFromPhotoLibraryButtonPressed:(id)sender
{
    if ([popoverController isPopoverVisible]) {
        [popoverController dismissPopoverAnimated:YES];
        return;
    }
    
    self.imagePickerController = nil;
    
    self.imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.allowsEditing = NO;
    imagePickerController.delegate = self;
    
    self.popoverController = [[UIPopoverController alloc] initWithContentViewController:imagePickerController];
    
    [popoverController presentPopoverFromRect:photoLibraryButton.frame
                                       inView:photoLibraryButton.superview
                     permittedArrowDirections:UIPopoverArrowDirectionDown
                                     animated:YES];
}

- (IBAction)setRoomImageFromCameraButtonPressed:(id)sender
{
    if (([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera] == NO)) {
        NSLog(@"No camera available");
        return;
    }
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    cameraUI.allowsEditing = NO;
    
    cameraUI.delegate = self;
    [self presentViewController:cameraUI animated:YES completion:nil];
}

- (IBAction)setRoomImageFromDropBoxButtonPressed:(id)sender
{
//    if ([[[DBAccountManager sharedManager] linkedAccounts] count] > 0) {
//        [self performSegueWithIdentifier:@"dropboxModalSegue" sender:sender];
//    } else {
//        [[DBAccountManager sharedManager] linkFromController:self];
//    }
    
    if ([[DBSession sharedSession] isLinked]) {
        [self performSegueWithIdentifier:@"dropboxModalSegue" sender:sender];
    }else{
        [[DBSession sharedSession] linkFromController:self];
    }
}

#pragma mark - 
#pragma mark Setting the scale

- (void) showCalibrationTools
{
    self.roomImageView.hidden = NO;
    logoImageView.hidden = YES;
    [buildVersionLabel setHidden:YES];
    self.scalerRectView.hidden = NO;
    self.acceptButton.hidden = NO;
    [self.view bringSubviewToFront:acceptButton];
}

#pragma mark -
#pragma mark Accepting scale
- (IBAction)setRoomScaleButtonPressed:(id)sender
{
    PreCaptureSessionDetails *session = [PreCaptureSessionDetails sharedInstance];
    session.roomImage = roomImageView.image;
    session.scalinator.referenceSize = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f", scalerRectView.frame.size.width]];
    
    session.scalinator.actualSize = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f", actualSizeOfScale]];
    session.scalinator.ratio = nil;
    
    if (self.shouldSaveToCameraRoll == YES) {
        UIImageWriteToSavedPhotosAlbum(roomImageView.image, nil, nil, nil);
    }
    
    DemoRoomViewController *destinationController =  [self.storyboard instantiateViewControllerWithIdentifier:@"demoRoomViewController"];
    [self.slidingViewController setTopViewController:destinationController];
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate Methods
- (void) imagePickerController: (UIImagePickerController *) picker  didFinishPickingMediaWithInfo: (NSDictionary *) info
{
    [self dismissImagePickerController:picker];
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        shouldSaveToCameraRoll = YES;
    }
    
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    UIImage *newImage = [image fixOrientation]; //[UIImage imageWithCGImage:[image CGImage] scale:[image scale] orientation: UIImageOrientationUp];
    
    
    switch (newImage.imageOrientation) {
        case UIImageOrientationDown:
            NSLog(@"180");
            break;
        case UIImageOrientationUp:
            NSLog(@"0");
            break;
        case UIImageOrientationLeft:
            NSLog(@"90");
            break;
        case UIImageOrientationRight:
            NSLog(@"-90");
            break;
            
        default:
            break;
    }

    self.roomImageView.image = [PrevealImageScaler scaleImage:newImage];
    [self.roomImageView setContentMode:UIViewContentModeScaleAspectFit];
    [self showCalibrationTools];
}

- (void) dismissImagePickerController: (UIImagePickerController *)picker
{
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        
        [popoverController dismissPopoverAnimated:YES];
        
    } else if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        
        [picker dismissViewControllerAnimated:YES completion:nil];
        
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissImagePickerController:picker];
}

#pragma mark -

#pragma mark DropboxViewControllerDelegateMethods


- (void)didSelectImageFromDropbox:(UIImage *)image
{
    self.roomImageView.image = [PrevealImageScaler scaleImage:image];
    [self showCalibrationTools];
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"dropboxModalSegue"]) {
        UINavigationController *nc = [segue destinationViewController];
        UIViewController *vc = nc.topViewController;
        [(DropboxBrowserViewController *) vc setDelegate:self];
    }
}

#pragma mark -
#pragma mark UIGestureRegognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (scalerRectView.hidden == NO || [gestureRecognizer isKindOfClass:[UISwipeGestureRecognizer class]]) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - Switching Actual Size Of Scale

- (void) switchActualSizeOfScale
{
    if (actualSizeOfScale == 11.0) {
        actualSizeOfScale = 8.5;
    } else if (actualSizeOfScale == 11.7) {
        actualSizeOfScale = 8.3;
    } else if (actualSizeOfScale == 8.3) {
        actualSizeOfScale = 11.7;
    } else {
        actualSizeOfScale = 11.0;
    }
}


#pragma mark Handle Gestures

- (IBAction)scale:(id)sender
{
    if([(UIPinchGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        _lastScale = 1.0;
    }
    
    CGFloat scale = 1.0 - (_lastScale - [(UIPinchGestureRecognizer*)sender scale]);
    
    CGAffineTransform currentTransform = scalerRectView.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    
    [scalerRectView setTransform:newTransform];
    
    _lastScale = [(UIPinchGestureRecognizer*)sender scale];
}

- (IBAction)move:(id)sender
{
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:roomImageView];
    
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        _firstX = [scalerRectView center].x;
        _firstY = [scalerRectView center].y;
    }
    
    translatedPoint = CGPointMake(_firstX+translatedPoint.x, _firstY+translatedPoint.y);
    
    [scalerRectView setCenter:translatedPoint];
}

- (IBAction)rotate:(id)sender
{
    CGAffineTransform newTransform;
    if([(UIRotationGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        self.initialRotationTransform = scalerRectView.transform;
    }
    if([(UIRotationGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        NSInteger rotations = 0;
        if (_lastRotation >= 0.78535) {
            rotations = ceil(_lastRotation / 1.57079633);
            newTransform = CGAffineTransformRotate(initialRotationTransform, rotations * 1.57079633);
        } else if (_lastRotation <= -0.78535) {
            rotations = floor(_lastRotation / 1.57079633);
            newTransform = CGAffineTransformRotate(initialRotationTransform, rotations * 1.57079633);
        } else {
            newTransform = initialRotationTransform;
        }
        
        [UIView animateWithDuration:0.4 animations:^{
            [scalerRectView setTransform:newTransform];
        }];
        
        // If the number of rotations is even we didn't actually change orientation
        if (rotations % 2 != 0) {
            [self switchActualSizeOfScale];
        }
        
        _lastRotation = 0.0;
        return;
    }
    CGFloat rotation = 0.0 - (_lastRotation - [(UIRotationGestureRecognizer*)sender rotation]);
    
    _totalRotation = _totalRotation + rotation;
    CGAffineTransform currentTransform = scalerRectView.transform;
    newTransform = CGAffineTransformRotate(currentTransform,rotation);
    
    [scalerRectView setTransform:newTransform];
    
    _lastRotation = [(UIRotationGestureRecognizer*)sender rotation];
}
    
@end
