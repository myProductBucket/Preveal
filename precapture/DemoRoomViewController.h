//
//  DemoRoomViewController.h
//  precapture
//
//  Created by Randy Crafton on 3/10/12.
//  Copyright (c) 2012 TouchSpring Design. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

#import "CollectionImageDelegateProtocol.h"
#import "DropboxViewControllerDelegateProtocol.h"
#import "PrevealBaseViewController.h"

@class Collection;
@class Collections;
@class CollectionImage;


@interface DemoRoomViewController : PrevealBaseViewController <UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CollectionImageDelegateProtocol, DropboxViewControllerDelegateProtocol, MFMailComposeViewControllerDelegate> {
    IBOutlet UIImageView *roomImageView;
    IBOutlet UIView *lightboxView;
    IBOutlet UIView *lightboxDimmerView;
    IBOutlet UIView *imageSettingControlsView;
    IBOutlet UIButton *imageSettingControlsDropboxButton;

    IBOutlet UIButton *chooseTemplateButton;
    IBOutlet UIButton *shareTemplateButton;
    IBOutlet UIButton *acceptButton;
    IBOutlet UIButton *rotateButton;
    IBOutlet UIButton *prevealGroupButton;
    IBOutlet UIButton *singleImageGroupButton;
    IBOutlet UIButton *prodpiGroupButton;
    IBOutlet UIButton *bayphotoGroupButton;
    IBOutlet UIButton *favoritesGroupButton;
    IBOutlet UIButton *inspireGuideCanvasGroupButton;
    IBOutlet UIButton *da1CanvasGroupButton;
    IBOutlet UIButton *myTemplatesGroupButton;
    IBOutlet UIButton *lastGroupButton;
    IBOutlet UILabel *sizeLabel;
    
    
    IBOutlet UIView *groupButtonRibbon;
    IBOutlet UIView *shareButtonRibbon;
    IBOutlet UIButton *facebookButton;
    
    NSString *currentGroupName;
    NSArray *groupIndexes;

    MFMailComposeViewController *emailView;

    
    Collections *collections;
    Collection *currentCollection;
    Collection *previousCollection;
    Collection *nextCollection;
    CollectionImage *currentImage;
    int currentCollectionIndex;
    
    BOOL useCurrentTemplateForBuilding;

    UIPopoverController *popover;
    UIPopoverController *infoPopover;

    IBOutlet UIGestureRecognizer *leftSwipe;
    IBOutlet UIGestureRecognizer *rightSwipe;
    IBOutlet UIGestureRecognizer *collectionPanGestureRecognizer;
    IBOutlet UIGestureRecognizer *collectionImagePanGestureRecognizer;
    IBOutlet UIGestureRecognizer *collectionImagePinchGestureRecognizer;
    IBOutlet UITapGestureRecognizer *collectionImageTapGestureRecognizer;

    BOOL shouldLoadLastMyTemplate;
    /** Gesture shenanigans **/
    BOOL inImageSettingMode;
    /*** Panning Stuff ***/
    CGFloat _firstX;
	CGFloat _firstY;
    
    /*** Rotation stuff ***/
    CGFloat _lastRotation; 
    CGFloat _totalRotation;
    CGAffineTransform initialRotationTransform;

    
    CGFloat _draggingFirstX;
    
    /** Lightbox Gesture Shenanigans **/
    CGFloat _lightboxLastScale;
	CGFloat _lightboxLastRotation;  
	CGFloat _lightboxFirstX;
	CGFloat _lightboxFirstY;
    CGFloat _lightboxMimimumScale;
    

}

@property (nonatomic, retain) IBOutlet UIImageView *roomImageView;
@property (nonatomic, retain) IBOutlet UIView *lightboxView;
@property (nonatomic, retain) IBOutlet UIView *lightboxDimmerView;
@property (nonatomic, retain) IBOutlet UIView *imageSettingControlsView;
@property (nonatomic, retain) IBOutlet UIButton *chooseTemplateButton;
@property (nonatomic, retain) IBOutlet UIButton *shareTemplateButton;
@property (nonatomic, retain) IBOutlet UIButton *acceptButton;
@property (nonatomic, retain) IBOutlet UIButton *rotateButton;

@property (nonatomic, retain) IBOutlet UIButton *prevealGroupButton;
@property (nonatomic, retain) IBOutlet UIButton *singleImageGroupButton;
@property (nonatomic, retain) IBOutlet UIButton *prodpiGroupButton;
@property (nonatomic, retain) IBOutlet UIButton *bayphotoGroupButton;
@property (nonatomic, retain) IBOutlet UIButton *favoritesGroupButton;
@property (nonatomic, retain) IBOutlet UIButton *inspireGuideCanvasGroupButton;
@property (nonatomic, retain) IBOutlet UIButton *da1CanvasGroupButton;
@property (nonatomic, retain) IBOutlet UIButton *myTemplatesGroupButton;
@property (nonatomic, retain) IBOutlet UIButton *lastGroupButton;
@property (nonatomic, retain) IBOutlet UILabel *sizeLabel;

@property (nonatomic, retain) NSString *currentGroupName;
@property (nonatomic, retain) NSArray *groupIndexes;
@property (nonatomic, retain) IBOutlet UIButton *facebookButton;

@property (nonatomic, assign) BOOL useCurrentTemplateForBuilding;

@property (weak, nonatomic) IBOutlet MIBadgeButton *smoochMessageButton;

@property (nonatomic, retain) MFMailComposeViewController *emailView;

@property (nonatomic, retain) IBOutlet UIGestureRecognizer *leftSwipe;
@property (nonatomic, retain) IBOutlet UIGestureRecognizer *rightSwipe;
@property (nonatomic, retain) IBOutlet UIGestureRecognizer *collectionPanGestureRecognizer;
@property (nonatomic, retain) IBOutlet UIGestureRecognizer *collectionImagePanGestureRecognizer;
@property (nonatomic, retain) IBOutlet UIGestureRecognizer *collectionImagePinchGestureRecognizer;
@property (nonatomic, retain) IBOutlet UITapGestureRecognizer *collectionImageTapGestureRecognizer;
@property (nonatomic, retain) Collections *collections;
@property (nonatomic, retain) Collection *currentCollection;
@property (nonatomic, retain) Collection *nextCollection;
@property (nonatomic, retain) Collection *previousCollection;
@property (nonatomic, retain) CollectionImage *currentImage;
@property (nonatomic, retain) UIPopoverController *popover;
@property (nonatomic, retain) UIPopoverController *infoPopover;
@property (nonatomic, assign) int currentCollectionIndex;
@property (nonatomic, assign) BOOL inImageSettingMode;
@property (nonatomic, assign) CGAffineTransform initialRotationTransform;
@property (nonatomic, retain) IBOutlet UIButton *imageSettingControlsDropboxButton;


@property (nonatomic, retain) IBOutlet UIView *groupButtonRibbon;
@property (nonatomic, retain) IBOutlet UIView *shareButtonRibbon;

@property (nonatomic, assign) BOOL shouldLoadLastMyTemplate;

- (IBAction)move:(id)sender;
- (IBAction)moveCollectionImage:(id)sender;
- (IBAction)scaleCollectionImage:(id)sender;
- (IBAction)homeButtonPressed:(id)sender;
- (IBAction)emailButtonPressed:(id)sender;


- (IBAction)rotateCollectionsForward:(id)sender;
- (IBAction)rotateCollectionsBackward:(id)sender;
- (IBAction)doneEditingCollectionImage:(id)sender;
- (IBAction)setImageFromGalleryButtonPushed:(id) sender;
- (IBAction)backToSetRoomVC:(id)sender;
- (IBAction)rotate:(id)sender;
- (UIImage*) renderRoomViewToImage;
- (IBAction)rotateButtonPressed:(id)sender;
- (IBAction)groupButtonPressed:(id)sender;

- (IBAction)shareButtonPressed:(id)sender;
- (IBAction)chooseTemplateButtonPressed:(id)sender;
- (IBAction)shareToFacebookButtonPressed:(id)sender;
- (IBAction)shareToTwitterButtonPressed:(id)sender;
- (IBAction)shareToEmailButtonPressed:(id)sender;
- (IBAction)shareToCameraRollButtonPressed:(id)sender;
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
- (IBAction)shareToPintrestButtonPressed:(id)sender;
- (IBAction)buildTemplateBasedOnCurrent:(id)sender;
- (IBAction)communityButtonTouched:(id)sender;
- (IBAction)dropBoxButtonPressed:(id)sender;
@end
