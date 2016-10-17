//
//  TemplateCreationViewController.m
//  precapture
//
//  Created by Randy Crafton on 1/17/13.
//  Copyright (c) 2013 Preveal. All rights reserved.
//

#import "TemplateCreationViewController.h"
#import "PreCaptureSessionDetails.h"
#import "Collection.h"
#import "Collections.h"
#import "CollectionImage.h"
#import "CollectionFramedImage.h"
#import "Scalinator.h"
#import "CreatedCollectionHandler.h"
#import "CollectionDetailEditViewController.h"
#import "FrameOptionsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "DemoRoomViewController.h"
#import "PrevealColors.h"
#import "PrevealSlidingViewController.h"
#import "DemoRoomViewController.h"

@interface TemplateCreationViewController ()

@end

@implementation TemplateCreationViewController

@synthesize backgroundView, horizontalGuide, horizontalGuideHold, verticalGuide, verticalGuideHold, sizeLabel, frameOptionsButton;
@synthesize openings, selectedOpening, collection, openingRemoverButton, openingResizerView, saveCollectionButton;
@synthesize frameOptionsView, frameSlider, noFrameButton, whiteFrameButton, blackFrameButton, woodFrameButton;
@synthesize openingPan, horizontalGuidePan, verticalGuidePan, openingResizer, movingGuide, doneEditing;
@synthesize smoochMessageButton;

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setBadgeNumber];
    
    if (self.doneEditing == YES) {
        PrevealSlidingViewController *slidingViewController = [self.navigationController.viewControllers objectAtIndex:0];
        [(DemoRoomViewController *)slidingViewController.topViewController setShouldLoadLastMyTemplate:YES];

        [self.navigationController popViewControllerAnimated:YES];
    } else {
        if ([openings count] == 0) {
            [self addOpeningButtonPressed:self];
        } else {
            
            collection.imageLayout = [NSArray arrayWithArray:openings];
            Scalinator *scalinator = [[PreCaptureSessionDetails sharedInstance] scalinator];
            float collectionWidth = [[scalinator getAdjustedSize:[[NSDecimalNumber alloc] initWithFloat:[collection totalWidth]]] floatValue];
            float collectionHeight = [[scalinator getAdjustedSize:[[NSDecimalNumber alloc] initWithFloat:[collection totalHeight]]] floatValue];
            for (CollectionImage *opening in openings) {
                opening.sizeLabel.text = @"";
                [self configureNewCollectionImage:opening];
                [self scaleOpeningFromInitialFrame:opening];
                
                // Center relative to the collection.
                opening.frame = CGRectMake(opening.frame.origin.x+self.view.center.x-(collectionWidth/2),
                                           opening.frame.origin.y+self.view.center.y-(collectionHeight/2),
                                           opening.frame.size.width,
                                           opening.frame.size.height);
                [self.view addSubview:opening];
            }
           
        }
        self.saveCollectionButton.enabled = YES;
    }

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.doneEditing = NO;
    /** Init stuff **/
    UIImage *roomImage =[[PreCaptureSessionDetails sharedInstance] roomImage];
    [backgroundView setContentMode:UIViewContentModeScaleAspectFit];
    backgroundView.image = roomImage;
    if (self.openings == nil) {
        self.openings = [[NSMutableArray alloc] init];
    }
    self.collection = [[Collection alloc] init];
    collection.activeInDemo = YES;

    /** Gesture recognizer setup **/
    horizontalGuideHold.userInteractionEnabled = YES;
    
    [horizontalGuideHold addGestureRecognizer:horizontalGuidePan];
    
    verticalGuideHold.userInteractionEnabled = YES;
    
    [verticalGuideHold addGestureRecognizer:verticalGuidePan];
    
    openingResizerView.userInteractionEnabled = YES;
    
    [openingResizerView addGestureRecognizer:openingResizer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setBadgeNumber) name:SKTConversationUnreadCountDidChangeNotification object:nil];

}

- (IBAction)smoochMessageTouchUp:(UIButton *)sender {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:0] forKey:BADGE_NUMBER];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [Smooch showConversationFromViewController:self];
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

- (IBAction)chooseTemplateButtonTouched:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)deleteOpeningButtonPressed:(id)sender
{
    [openings removeObject:selectedOpening];
    [selectedOpening removeFromSuperview];
    self.selectedOpening = nil;
    [self removeOpeningControls];
    self.saveCollectionButton.enabled = [openings count] > 0;
}

- (IBAction)addOpeningButtonPressed:(id)sender
{
    CollectionImage *newOpening = [self getNewCollectionImage];
    [self.view addSubview:newOpening];
    [openings addObject:newOpening];
    self.selectedOpening = newOpening;
    
    [self scaleOpeningFromInitialFrame:selectedOpening];
    selectedOpening.center = self.view.center;

    [self didTouchCollectionImage:newOpening];
    [self positionOpeningControls];
    self.saveCollectionButton.enabled = YES;
    self.sizeLabel.text = [selectedOpening getSizeAsString];
    [self.view bringSubviewToFront:sizeLabel];
    sizeLabel.hidden = NO;
}

- (IBAction)duplicateCurrentOpeningButtonTouched:(id)sender
{
    if (selectedOpening == nil) {
        return;
    }
    
    CollectionImage *newOpening = [selectedOpening duplicate];
    
    [self configureNewCollectionImage:newOpening];
    CGPoint newCenter = CGPointMake(selectedOpening.center.x + [self getPixelScale], selectedOpening.center.y + [self getPixelScale]);
    self.selectedOpening = newOpening;

    [openings addObject:selectedOpening];
    [self.view addSubview:selectedOpening];
    [self scaleOpeningFromInitialFrame:selectedOpening];
    selectedOpening.center = newCenter;
    [self didTouchCollectionImage:selectedOpening];

}

- (IBAction)rotateCurrnetOpeningButtonTouched:(id)sender
{
    CGPoint currentOrigin = selectedOpening.frame.origin;

    NSDecimalNumber *height = selectedOpening.height;
    selectedOpening.height = selectedOpening.width;
    selectedOpening.width = height;
    
    if ([selectedOpening class] == [CollectionFramedImage class]) {
        CollectionFramedImage *duplicate = [(CollectionFramedImage *)selectedOpening duplicate];
        [duplicate configureViewDetails];
        duplicate.frameHeight = [(CollectionFramedImage *)selectedOpening frameWidth];
        duplicate.frameWidth = [(CollectionFramedImage *)selectedOpening frameHeight];
        
        [selectedOpening removeFromSuperview];
        
        [openings removeObject:selectedOpening];
        self.selectedOpening = duplicate;
        [openings addObject:selectedOpening];
        [self.view addSubview:selectedOpening];
        [self configureNewCollectionImage:selectedOpening];
    }
    
    
    [self scaleOpeningFromInitialFrame:selectedOpening];
    selectedOpening.frame = CGRectMake(currentOrigin.x, currentOrigin.y, selectedOpening.frame.size.width, selectedOpening.frame.size.height);
    [self positionOpeningControls];
}


- (CollectionImage *) getNewCollectionImage
{
    CollectionImage *newOpening = [[CollectionImage alloc] init];
    newOpening.x = [NSDecimalNumber decimalNumberWithString:@"0.0"];
    newOpening.y = [NSDecimalNumber decimalNumberWithString:@"0.0"];
    if ([self doMetric]) {
        newOpening.width = [NSDecimalNumber decimalNumberWithString:@"19.685"];
        newOpening.height = [NSDecimalNumber decimalNumberWithString:@"29.9213"];
    } else {
        newOpening.width = [NSDecimalNumber decimalNumberWithString:@"20.0"];
        newOpening.height = [NSDecimalNumber decimalNumberWithString:@"30.0"];

    }
    newOpening.imageType = @"canvas";

    [self configureNewCollectionImage:newOpening];

    
    return newOpening;
}

- (void) configureNewCollectionImage: (CollectionImage *) newOpening
{
    [newOpening configureViewDetails];
    
    newOpening.myCollection = collection; // Kind of a hack...
    newOpening.delegate = self;
    [newOpening configureGestureRecognizers];
}

- (void) scaleOpeningFromInitialFrame: (CollectionImage *) opening
{
    [opening setInitialFrame];
    
    Scalinator *scalinator = [[PreCaptureSessionDetails sharedInstance] scalinator];
    opening.frame = [scalinator getAdjustedFrame:opening.frame];
    [opening doneResizingWithScalinator:scalinator];
    self.sizeLabel.text = [selectedOpening getSizeAsString];


}

#pragma mark -
#pragma mark gesture actions

- (IBAction)moveSelectedOpening:(id)sender {
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.view];
    
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        _firstX = [selectedOpening center].x;
        _firstY = [selectedOpening center].y;
    }
    
    translatedPoint = CGPointMake(_firstX+translatedPoint.x, _firstY+translatedPoint.y);
    
    // Now check proximity to vertical guide
    CGFloat halfWidth = selectedOpening.frame.size.width / 2;
    if (translatedPoint.x - halfWidth >= verticalGuide.frame.origin.x - kPrevealSnapThreshold &&
        translatedPoint.x - halfWidth <= verticalGuide.frame.origin.x + kPrevealSnapThreshold) {
        translatedPoint.x = verticalGuide.frame.origin.x + halfWidth;
    } else if ((translatedPoint.x + halfWidth) >= verticalGuide.frame.origin.x - kPrevealSnapThreshold &&
               (translatedPoint.x + halfWidth) <= verticalGuide.frame.origin.x + kPrevealSnapThreshold) {
        translatedPoint.x = verticalGuide.frame.origin.x - halfWidth;
    }
    
    // Now check proximity to horizontal guide
    CGFloat halfHeight = selectedOpening.frame.size.height / 2;
    if (translatedPoint.y - halfHeight >= horizontalGuide.frame.origin.y - kPrevealSnapThreshold &&
        translatedPoint.y - halfHeight <= horizontalGuide.frame.origin.y + kPrevealSnapThreshold) {
        translatedPoint.y = horizontalGuide.frame.origin.y + halfHeight;
    } else if ((translatedPoint.y + halfHeight) >= horizontalGuide.frame.origin.y - kPrevealSnapThreshold &&
               (translatedPoint.y + halfHeight) <= horizontalGuide.frame.origin.y + kPrevealSnapThreshold) {
        translatedPoint.y = horizontalGuide.frame.origin.y - halfHeight;
    }
    
    [selectedOpening setCenter:translatedPoint];
    [self positionOpeningControls];
}


- (IBAction)moveGuide:(id)sender {
    
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.view];
    
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        _firstX = [movingGuide center].x;
        _firstY = [movingGuide center].y;
    }
    
    translatedPoint = CGPointMake(_firstX+translatedPoint.x, _firstY+translatedPoint.y);
    
    if (movingGuide == horizontalGuideHold) {
        horizontalGuide.center = CGPointMake(horizontalGuide.center.x, translatedPoint.y);
        horizontalGuideHold.center = CGPointMake(horizontalGuideHold.center.x, translatedPoint.y);
    } else {
        verticalGuide.center = CGPointMake(translatedPoint.x, verticalGuide.center.y);
        verticalGuideHold.center = CGPointMake(translatedPoint.x, verticalGuideHold.center.y);
    }
}

- (IBAction)resizeSelectedOpening:(id)sender
{
    
    CGPoint initialTranslatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.view];
    CGFloat pixelScale = [self getPixelScale];
    /*
    NSLog(@"%f", pixelScale);
    if ([self doMetric]) {
        pixelScale = pixelScale * 0.39370;
    }
    NSLog(@"%f", pixelScale);
*/
    BOOL changed = NO;
    
    
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        _firstX = [openingResizerView center].x;
        _firstY = [openingResizerView center].y;
        _lastX = _firstX;
        _lastY = _firstY;
    }
    
    CGPoint translatedPoint = CGPointMake(_firstX+initialTranslatedPoint.x, _firstY+initialTranslatedPoint.y);
    
    
    
    // Have we moved horizontally enough to justify an increment in width?

    if (translatedPoint.x > _lastX && translatedPoint.x - _lastX > pixelScale) { // Widening - pulling right
        changed = YES;
        selectedOpening.width = [selectedOpening.width decimalNumberByAdding:[NSDecimalNumber decimalNumberWithString:@"1"]];
        if ([selectedOpening class] == [CollectionFramedImage class]) {
            [(CollectionFramedImage *)selectedOpening setFrameWidth:[[(CollectionFramedImage *)selectedOpening frameWidth] decimalNumberByAdding:[NSDecimalNumber decimalNumberWithString:@"1"]]];
        }
        _lastX = translatedPoint.x;
    } else if (translatedPoint.x < _lastX && _lastX - translatedPoint.x > pixelScale && [selectedOpening.width floatValue] > 1) { // narrowing - pulling left
        changed = YES;
        selectedOpening.width = [selectedOpening.width decimalNumberBySubtracting:[NSDecimalNumber decimalNumberWithString:@"1"]];
        if ([selectedOpening class] == [CollectionFramedImage class]) {
            [(CollectionFramedImage *)selectedOpening setFrameWidth:[[(CollectionFramedImage *)selectedOpening frameWidth] decimalNumberBySubtracting:[NSDecimalNumber decimalNumberWithString:@"1"]]];
        }
        _lastX = translatedPoint.x;

    }
    
    // Have we moved vertically enough to justify an increment in height?
    if (translatedPoint.y > _lastY && translatedPoint.y - _lastY > pixelScale) { // lengthening - pulling down
        changed = YES;
        selectedOpening.height = [selectedOpening.height decimalNumberByAdding:[NSDecimalNumber decimalNumberWithString:@"1"]];
        if ([selectedOpening class] == [CollectionFramedImage class]) {
            [(CollectionFramedImage *)selectedOpening setFrameHeight:[[(CollectionFramedImage *)selectedOpening frameHeight] decimalNumberByAdding:[NSDecimalNumber decimalNumberWithString:@"1"]]];
        }
        _lastY = translatedPoint.y;
    } else if (translatedPoint.y < _lastY && _lastY - translatedPoint.y > pixelScale && [selectedOpening.height floatValue] > 1) { // shortening - pulling up
        changed = YES;
        selectedOpening.height = [selectedOpening.height decimalNumberBySubtracting:[NSDecimalNumber decimalNumberWithString:@"1"]];
        if ([selectedOpening class] == [CollectionFramedImage class]) {
            [(CollectionFramedImage *)selectedOpening setFrameHeight:[[(CollectionFramedImage *)selectedOpening frameHeight] decimalNumberBySubtracting:[NSDecimalNumber decimalNumberWithString:@"1"]]];
        }
        _lastY = translatedPoint.y;
    }

    
    
    if (changed == YES) {
        CGPoint currentOrigin = selectedOpening.frame.origin;
        if ([selectedOpening class] == [CollectionFramedImage class]) {
            CollectionFramedImage *duplicate = [(CollectionFramedImage *)selectedOpening duplicate];
            [duplicate configureViewDetails];
            [selectedOpening removeFromSuperview];
            [openings removeObject:selectedOpening];
            self.selectedOpening = duplicate;
            [openings addObject:selectedOpening];
            [self.view addSubview:selectedOpening];
            [self configureNewCollectionImage:selectedOpening];
        }
        [self scaleOpeningFromInitialFrame:selectedOpening];
        selectedOpening.frame = CGRectMake(currentOrigin.x, currentOrigin.y, selectedOpening.frame.size.width, selectedOpening.frame.size.height);
        [self positionOpeningControls];
        
    }

}

- (CGFloat) getPixelScale
{
    return [[[[PreCaptureSessionDetails sharedInstance] scalinator] getRatio] floatValue];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    BOOL shouldBegin = NO;
    CGPoint touchedPoint;
    
    // Move around the selected opening
    if (gestureRecognizer == openingPan && self.selectedOpening != nil) {
        shouldBegin = YES;
    }
    
    // Resize the selected opening
    if (gestureRecognizer == openingResizer && self.selectedOpening != nil) {
        touchedPoint = [gestureRecognizer locationInView:openingResizerView];
        if ([openingResizerView pointInside:touchedPoint withEvent:nil]) {
            shouldBegin = YES;
        }
    }
    
    // Drag the horizontal alignment tool
    if (gestureRecognizer == horizontalGuidePan) {
        touchedPoint = [gestureRecognizer locationInView:horizontalGuideHold];
        if ([horizontalGuideHold pointInside:touchedPoint withEvent:nil]) {
            shouldBegin = YES;
            self.movingGuide = horizontalGuideHold;
        }
    }
    
    // Drag the vertical alignment tool
    if (gestureRecognizer == verticalGuidePan) {
        touchedPoint = [gestureRecognizer locationInView:verticalGuideHold];
        if ([verticalGuideHold pointInside:touchedPoint withEvent:nil]) {
            shouldBegin = YES;
            self.movingGuide = verticalGuide;
        }
    }
    
    return shouldBegin;
}

- (void) didTouchCollectionImage:(CollectionImage *)collectionImage
{
    [self removeOpeningControls];
    self.selectedOpening = collectionImage;
    [self.view bringSubviewToFront:selectedOpening];
    [self addOpeningControls];
    self.sizeLabel.text = [selectedOpening getSizeAsString];
    sizeLabel.hidden = NO;
}

- (IBAction)doneEditingCollectionImage:(id)sender
{
    [self removeOpeningControls];
    self.selectedOpening = nil;
}

- (void) addOpeningControls
{
    [self positionOpeningControls];
    
    openingResizerView.hidden = NO;
    openingRemoverButton.hidden = NO;
}

- (void) positionOpeningControls
{
    [self.view bringSubviewToFront:openingRemoverButton];
    [self.view bringSubviewToFront:openingResizerView];
    [self.view bringSubviewToFront:frameOptionsView];
    openingRemoverButton.center = selectedOpening.frame.origin;
    openingResizerView.center = CGPointMake(selectedOpening.frame.origin.x+selectedOpening.frame.size.width,
                                            selectedOpening.frame.origin.y+selectedOpening.frame.size.height);

}

- (void) removeOpeningControls
{
    openingRemoverButton.hidden = YES;
    openingResizerView.hidden = YES;
    //frameOptionsView.hidden = YES;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"editDetailsModal"]) {
        [self removeOpeningControls];

        CreatedCollectionHandler *handler = [[CreatedCollectionHandler alloc] init];
        self.collection = [handler handleCollectionCreationWithOpenings:openings];
        
        CollectionDetailEditViewController * vc = (CollectionDetailEditViewController *)[segue destinationViewController];
        [vc setCurrentCollection: [collection copy]];
        [vc setPreviousViewController:self];
        vc.showUpload = YES;


    } else if ([segue.identifier isEqualToString:@"frameOptionsSegue"]) {
        UINavigationController *nc = (UINavigationController *) [segue destinationViewController];
        FrameOptionsViewController *vc = (FrameOptionsViewController *) [[nc viewControllers] objectAtIndex:0];
        vc.templateViewController = self;
        vc.sliderEnabled = NO;
        vc.sliderInitialValue = 0;
        if ([selectedOpening class] == [CollectionFramedImage class]) {
            CollectionFramedImage *opening = (CollectionFramedImage *)selectedOpening;
            vc.sliderEnabled = YES;
            vc.sliderInitialValue = (int) round([opening.x floatValue]);
        }
    }
        
    
}

#pragma mark -
#pragma mark frame shenanigans

- (IBAction)frameOptionsButtonPressed:(id)sender
{
    if (self.selectedOpening != nil) {
        [self performSegueWithIdentifier:@"frameOptionsSegue" sender:self.frameOptionsButton];
    }
}

- (IBAction)noFrameButtonPressed:(id)sender
{
    [self convertSelectedOpeningToNoFrame];
}

- (void) convertSelectedOpeningToNoFrame
{
    if ([selectedOpening class] == [CollectionFramedImage class]) {
        CollectionFramedImage *oldOpening = (CollectionFramedImage *)selectedOpening;
        CollectionImage *newOpening = [[CollectionImage alloc] init];
        newOpening.x = oldOpening.frameX;
        newOpening.y = oldOpening.frameY;
        newOpening.width = oldOpening.width;
        newOpening.height = oldOpening.height;
        newOpening.imageType = @"canvas";

        [newOpening configureViewDetails];
        [self configureNewCollectionImage:newOpening];

        newOpening.myCollection = collection; // Kind of a hack...
        newOpening.delegate = self;
        [newOpening configureGestureRecognizers];
    
        
        [self scaleOpeningFromInitialFrame:newOpening];
        
        newOpening.center = selectedOpening.center;
        
 /*       // Switch!
        [selectedOpening removeFromSuperview];
        [openings removeObject:selectedOpening];
        self.selectedOpening = newOpening;
        [self.view addSubview:newOpening];
        [openings addObject:newOpening];
   */     
        [selectedOpening removeFromSuperview];
        [openings removeObject:selectedOpening];
        self.selectedOpening = newOpening;
        [self.view addSubview:selectedOpening];
        [openings addObject:newOpening];
        
        
        [self didTouchCollectionImage:newOpening];
        self.saveCollectionButton.enabled = YES;
        self.sizeLabel.text = [selectedOpening getSizeAsString];
        [self.view bringSubviewToFront:sizeLabel];
        sizeLabel.hidden = NO;
        [self addOpeningControls];

        
    }
}

- (IBAction)blackFrameButtonPressed:(id)sender
{
    [self convertSelectedOpeningToFrame];
    [(CollectionFramedImage *)self.selectedOpening setFrameColor:@"black"];
    selectedOpening.layer.borderColor = [[[PrevealColors sharedInstance] blackFrameColor] CGColor];
}

- (IBAction)whiteFrameButtonPressed:(id)sender
{
    [self convertSelectedOpeningToFrame];
    [(CollectionFramedImage *)self.selectedOpening setFrameColor:@"white"];
    selectedOpening.layer.borderColor = [[[PrevealColors sharedInstance] whiteFrameColor] CGColor];
}
- (IBAction)woodFrameButtonPressed:(id)sender
{
    [self convertSelectedOpeningToFrame];
    [(CollectionFramedImage *)self.selectedOpening setFrameColor:@"brown"];
    selectedOpening.layer.borderColor = [[[PrevealColors sharedInstance] woodFrameColor] CGColor];
}

- (IBAction)frameSliderChanged:(id)sender
{
    UISlider *slider = (UISlider *) sender;
    int matteWidth = (int) round(slider.value);
    [self changeMatteSizeOfSelectedOpeningTo:matteWidth];
}

- (void) convertSelectedOpeningToFrame
{
    if ([selectedOpening class] == [CollectionImage class]) {
        CollectionFramedImage *newOpening = [[CollectionFramedImage alloc] init];
        newOpening.frameX = selectedOpening.x;
        newOpening.frameWidth = [selectedOpening.width decimalNumberByAdding:[NSDecimalNumber decimalNumberWithString:@"6"]];
        newOpening.frameY = selectedOpening.y;  
        newOpening.frameHeight = [selectedOpening.height decimalNumberByAdding:[NSDecimalNumber decimalNumberWithString:@"6"]];
        newOpening.x = [NSDecimalNumber decimalNumberWithString:@"3"];
        newOpening.y = [NSDecimalNumber decimalNumberWithString:@"3"];
        newOpening.width = selectedOpening.width;
        newOpening.height = selectedOpening.height;
        newOpening.imageType = @"frame";
        

        [newOpening configureViewDetails];
        [self configureNewCollectionImage:newOpening];
        [self scaleOpeningFromInitialFrame:newOpening];

        
        newOpening.myCollection = collection; // Kind of a hack...
        newOpening.delegate = self;
        [newOpening configureGestureRecognizers];


        newOpening.center = selectedOpening.center;

        // Switch!
        [selectedOpening removeFromSuperview];
        [openings removeObject:selectedOpening];
        self.selectedOpening = newOpening;
        [self.view addSubview:newOpening];
        [openings addObject:newOpening];

        
        
        [self didTouchCollectionImage:newOpening];
        self.saveCollectionButton.enabled = YES;
        self.sizeLabel.text = [selectedOpening getSizeAsString];
        [self.view bringSubviewToFront:sizeLabel];
        sizeLabel.hidden = NO;
        frameSlider.enabled = YES;
        [self addOpeningControls];
    }
}

- (void) changeMatteSizeOfSelectedOpeningTo: (int) newWidth
{
    NSDecimalNumber *newMatteWidth = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%d", newWidth]];
    NSDecimalNumber *newFrameTotalWidth = [NSDecimalNumber decimalNumberWithString: [NSString stringWithFormat:@"%d", newWidth * 2]];
    CollectionFramedImage *newOpening = [[CollectionFramedImage alloc] init];
    CollectionFramedImage *opening = (CollectionFramedImage *) selectedOpening;
    newOpening.frameX = opening.frameX;
    newOpening.frameWidth = [selectedOpening.width decimalNumberByAdding:newFrameTotalWidth];
    newOpening.frameY = opening.frameY;
    newOpening.frameHeight = [selectedOpening.height decimalNumberByAdding:newFrameTotalWidth];
    newOpening.x = newMatteWidth;
    newOpening.y = newMatteWidth;
    newOpening.width = selectedOpening.width;
    newOpening.height = selectedOpening.height;
    newOpening.imageType = @"frame";
    newOpening.frameColor = opening.frameColor;

    
    [newOpening configureViewDetails];
    [self configureNewCollectionImage:newOpening];
    [self scaleOpeningFromInitialFrame:newOpening];
    
    
    newOpening.myCollection = collection; // Kind of a hack...
    newOpening.delegate = self;
    [newOpening configureGestureRecognizers];
    
    
    newOpening.center = selectedOpening.center;
    
    // Switch!
    [selectedOpening removeFromSuperview];
    [openings removeObject:selectedOpening];
    self.selectedOpening = newOpening;
    [self.view addSubview:newOpening];
    [openings addObject:newOpening];
    [self addOpeningControls];
    
    if ([newOpening.frameColor isEqualToString:@"black"]) {
        newOpening.layer.borderColor = [[[PrevealColors sharedInstance] blackFrameColor] CGColor];
    } else if ([newOpening.frameColor isEqualToString:@"white"]) {
        newOpening.layer.borderColor = [[[PrevealColors sharedInstance] whiteFrameColor] CGColor];
    } else if ([newOpening.frameColor isEqualToString:@"brown"]) {
        newOpening.layer.borderColor = [[[PrevealColors sharedInstance] woodFrameColor] CGColor];
    }
}


#pragma mark -
#pragma mark misc

- (BOOL) doMetric
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return ([(NSString *)[defaults objectForKey:@"unitOfMeasure"] isEqualToString:@"metric"]);
}


- (BOOL)prefersStatusBarHidden {
    return YES;
}
@end
