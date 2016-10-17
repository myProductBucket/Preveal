//
//  TemplateCreationViewController.h
//  precapture
//
//  Created by Randy Crafton on 1/17/13.
//  Copyright (c) 2013 Preveal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionImageDelegateProtocol.h"



#define kPrevealSnapThreshold 6


@class CollectionImage;
@class Collection;

@interface TemplateCreationViewController : UIViewController <UIGestureRecognizerDelegate, CollectionImageDelegateProtocol> {
    IBOutlet UIImageView *backgroundView;
    IBOutlet UIImageView *horizontalGuideHold;
    IBOutlet UIImageView *verticalGuideHold;
    IBOutlet UIView *horizontalGuide;
    IBOutlet UIView *verticalGuide;
    
    IBOutlet UIImageView *openingResizerView;
    IBOutlet UIButton *openingRemoverButton;
    IBOutlet UIButton *saveCollectionButton;

    IBOutlet UIView *frameOptionsView;
    IBOutlet UIButton *noFrameButton;
    IBOutlet UIButton *blackFrameButton;
    IBOutlet UIButton *woodFrameButton;
    IBOutlet UIButton *whiteFrameButton;
    IBOutlet UISlider *frameSlider;
    
    IBOutlet UILabel *sizeLabel;
    IBOutlet UIButton *frameOptionsButton;
    
    IBOutlet UIPanGestureRecognizer *horizontalGuidePan;
    IBOutlet UIPanGestureRecognizer *verticalGuidePan;
    IBOutlet UIPanGestureRecognizer *openingPan;
    IBOutlet UIPanGestureRecognizer *openingResizer;
    UIView *movingGuide;
    
    NSMutableArray *openings;
    CollectionImage *selectedOpening;
    Collection *collection;
    CGPoint copiedCollectionDimensions;
    
    BOOL doneEditing;
    /*** Panning Stuff ***/
    CGFloat _firstX;
	CGFloat _firstY;
    CGFloat _lastScale;
    CGFloat _lastX;
    CGFloat _lastY;

}

@property (nonatomic, retain) IBOutlet UIImageView *backgroundView;
@property (nonatomic, retain) IBOutlet UIImageView *horizontalGuideHold;
@property (nonatomic, retain) IBOutlet UIImageView *verticalGuideHold;
@property (nonatomic, retain) IBOutlet UIView *horizontalGuide;
@property (nonatomic, retain) IBOutlet UIView *verticalGuide;

@property (nonatomic, retain) IBOutlet UIImageView *openingResizerView;
@property (nonatomic, retain) IBOutlet UIButton *openingRemoverButton;
@property (nonatomic, retain) IBOutlet UIButton *saveCollectionButton;

@property (nonatomic, retain) IBOutlet UIView *frameOptionsView;
@property (nonatomic, retain) IBOutlet UIButton *noFrameButton;
@property (nonatomic, retain) IBOutlet UIButton *blackFrameButton;
@property (nonatomic, retain) IBOutlet UIButton *woodFrameButton;
@property (nonatomic, retain) IBOutlet UIButton *whiteFrameButton;
@property (nonatomic, retain) IBOutlet UISlider *frameSlider;

@property (nonatomic, retain) IBOutlet UILabel *sizeLabel;
@property (nonatomic, retain) IBOutlet UIButton *frameOptionsButton;

@property (nonatomic, retain) IBOutlet UIPanGestureRecognizer *horizontalGuidePan;
@property (nonatomic, retain) IBOutlet UIPanGestureRecognizer *verticalGuidePan;
@property (nonatomic, retain) IBOutlet UIPanGestureRecognizer *openingPan;
@property (nonatomic, retain) IBOutlet UIPanGestureRecognizer *openingResizer;
@property (nonatomic, retain) UIView *movingGuide;

@property (weak, nonatomic) IBOutlet MIBadgeButton *smoochMessageButton;

@property (nonatomic, retain) NSMutableArray *openings;
@property (nonatomic, retain) CollectionImage *selectedOpening;
@property (nonatomic, retain) Collection *collection;

@property (nonatomic, assign) BOOL doneEditing;

- (IBAction)addOpeningButtonPressed:(id)sender;
- (IBAction)deleteOpeningButtonPressed:(id)sender;
- (IBAction)chooseTemplateButtonTouched:(id)sender;
- (IBAction)duplicateCurrentOpeningButtonTouched:(id)sender;
- (IBAction)rotateCurrnetOpeningButtonTouched:(id)sender;

- (IBAction)frameOptionsButtonPressed:(id)sender;
- (IBAction)noFrameButtonPressed:(id)sender;
- (IBAction)blackFrameButtonPressed:(id)sender;
- (IBAction)whiteFrameButtonPressed:(id)sender;
- (IBAction)woodFrameButtonPressed:(id)sender;
- (IBAction)frameSliderChanged:(id)sender;



- (IBAction)moveSelectedOpening:(id)sender;
- (IBAction)moveGuide:(id)sender;
- (IBAction)resizeSelectedOpening:(id)sender;


@end
