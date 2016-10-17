//
//  DemoRoomViewController.m
//  precapture
//
//  Created by Randy Crafton on 3/10/12.
//  Copyright (c) 2012 TouchSpring Design. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import <Twitter/Twitter.h>
//#import <Dropbox/Dropbox.h>
#import <Social/Social.h>
#import "DemoRoomViewController.h"
#import "PreCaptureSessionDetails.h"
#import "Collections.h"
#import "Collection.h"
#import "CollectionImage.h"
#import "DropboxBrowserViewController.h"
#import "CollectionInfoPopoverViewController.h"
#import "ShareTemplateViewController.h"
#import "InAppPurchaseController.h"
#import "CollectionRotator.h"
#import "TemplateCreationViewController.h"
#import "PrevealCommunityUrls.h"
#import "CollectionManagementViewController.h"
#import "PrevealSlidingViewController.h"
#import "PrevealImageScaler.h"

@interface DemoRoomViewController ()

@end

@implementation DemoRoomViewController

@synthesize roomImageView, lightboxView, lightboxDimmerView, imageSettingControlsView, collections;
@synthesize currentCollection, nextCollection, previousCollection, currentCollectionIndex, chooseTemplateButton, shareTemplateButton;
@synthesize currentImage, popover, infoPopover, emailView, acceptButton, rotateButton;
@synthesize prevealGroupButton, singleImageGroupButton, prodpiGroupButton, bayphotoGroupButton, favoritesGroupButton, currentGroupName;
@synthesize myTemplatesGroupButton, lastGroupButton, da1CanvasGroupButton;
@synthesize sizeLabel, inspireGuideCanvasGroupButton, groupIndexes;
@synthesize leftSwipe, rightSwipe, collectionPanGestureRecognizer;
@synthesize collectionImagePanGestureRecognizer, collectionImagePinchGestureRecognizer, collectionImageTapGestureRecognizer;
@synthesize inImageSettingMode, initialRotationTransform, useCurrentTemplateForBuilding, imageSettingControlsDropboxButton;
@synthesize shareButtonRibbon, groupButtonRibbon, facebookButton, shouldLoadLastMyTemplate;

@synthesize smoochMessageButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setBadgeNumber) name:SKTConversationUnreadCountDidChangeNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setBadgeNumber];
    
    if (currentGroupName == nil) {

        self.view.autoresizesSubviews = YES;
        self.currentCollectionIndex = 0;
        self.inImageSettingMode = NO;

//        UIImage *roomImage =[[PreCaptureSessionDetails sharedInstance] roomImage];
//        [roomImageView setContentMode:UIViewContentModeScaleAspectFit];
//        roomImageView.image = roomImage; // [[PreCaptureSessionDetails sharedInstance] roomImage];
        [self setRoomImage];
        
        self.collections = [[Collections alloc] init];
        [collections loadCollectionsFromUserDocuments];
        NSError *error;
        
        [collections setCurrentGroupName:@"favorites" error:&error];
        if ([error localizedDescription] == nil) {
            self.lastGroupButton = self.favoritesGroupButton;
            favoritesGroupButton.selected = YES;
        } else {
            [collections setCurrentGroupName:@"preveal" error:nil];
            self.lastGroupButton = self.prevealGroupButton;
            prevealGroupButton.selected = YES;
        }
        [self resetTemplatesOnScreen];

    }
    if (currentGroupName == nil){
        [self loadGroupButtons];
        self.currentGroupName = @"preveal";
    }
    if (![self isFacebookAvailable]) {
        self.facebookButton.alpha = .6;
    }
    self.useCurrentTemplateForBuilding = NO;
    if (self.shouldLoadLastMyTemplate == YES) {
        NSError *error = nil;
        [collections loadCollectionsFromUserDocuments];
        [collections setCurrentGroupName:kPrevealMyCollectionsGroupName error:&error];
        if ([[collections currentGroup] count] > 0) {
            [self.collections loadCollectionsFromUserDocuments];
            [self groupButtonPressed:self.myTemplatesGroupButton];
            [self resetTemplatesOnScreen];
            for (int i=1; i<[collections.currentGroup count]; i++) {
                [self rotateCollectionsForward:self];

            }
        }
        self.shouldLoadLastMyTemplate = NO;
    }
    [self setButtonStates];
    imageSettingControlsDropboxButton.enabled = NO;
//    if ([[DBAccountManager sharedManager] linkedAccount] != nil) {
//        imageSettingControlsDropboxButton.enabled = YES;
//    }
    if ([[DBSession sharedSession] isLinked]) {
        imageSettingControlsDropboxButton.enabled = YES;
    }

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

- (void)setRoomImage {
    @try {
        UIImage *roomImage =[[PreCaptureSessionDetails sharedInstance] roomImage];
        if (roomImage == nil) {
            return;
        }
        CGFloat sw = roomImage.size.width;
        CGFloat sh = roomImage.size.height;
        CGFloat pw = self.view.frame.size.width;
        CGFloat ph = self.view.frame.size.height;
        
        if ((sw / sh) > (pw / ph)) {
            [roomImageView setFrame:CGRectMake(0, (ph - pw * sh / sw) / 2, pw, pw * sh / sw)];
        }else{
            [roomImageView setFrame:CGRectMake((pw - sw * ph / sh) / 2, 0, sw * ph / sh, ph)];
        }
        
        [roomImageView setContentMode:UIViewContentModeScaleAspectFit];
        roomImageView.image = roomImage; // [[PreCaptureSessionDetails
    }
    @catch (NSException *e){
        
    }
    @finally {
        
    }
}

- (void) loadGroupButtons
{
    self.groupIndexes = [NSArray arrayWithObjects:@"preveal",
                         @"com.chrisandadriennescott.preveal.inspireguide.canvas",
                         @"bayphoto",
                         @"favorites",
                         @"prodpi",
                         @"singles",
                         @"singlesFramed",
                         kPrevealMyCollectionsGroupName,
                         kPrevealCommunityGroupName, /* Not used */
                         kPrevealDA1Name,
                         nil];

    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSArray *purchasedBundles = [prefs objectForKey:@"purchasedBundles"];

    if (![purchasedBundles containsObject:[groupIndexes objectAtIndex:1]]) {
        [inspireGuideCanvasGroupButton setImage:[UIImage imageNamed:@"DA_PayUp.png"] forState:UIControlStateNormal];
        [inspireGuideCanvasGroupButton setImage:[UIImage imageNamed:@"DA_PayUp.png"] forState:UIControlStateSelected];
    }
    
    if (![purchasedBundles containsObject:kPrevealDA1Name]) {
        [da1CanvasGroupButton setImage:[UIImage imageNamed:@"DA1_PayUp.png"] forState:UIControlStateNormal];
        [da1CanvasGroupButton setImage:[UIImage imageNamed:@"DA1_PayUp.png"] forState:UIControlStateSelected];
    }
    

}

- (void) setButtonStates
{
    [prevealGroupButton setSelected:NO];
    [singleImageGroupButton setSelected:NO];
    [prodpiGroupButton setSelected:NO];
    [bayphotoGroupButton setSelected:NO];
    [favoritesGroupButton setSelected:NO];
    [inspireGuideCanvasGroupButton setSelected:NO];
    [prevealGroupButton setSelected:NO];
    [myTemplatesGroupButton setSelected:NO];
    [lastGroupButton setSelected:YES];
}

- (void) resetTemplatesOnScreen
{
    @try {
        [collections filterAvailable];
        [collections scaleAllAvailable];
        
        //checking whether collection item is shown or not?----detecting crash for this step
        if (![collections currentGroup] || [[collections currentGroup] count] <= currentCollectionIndex) {
            return;
        }
        
        //
        Collection *collection = [[collections currentGroup] objectAtIndex:currentCollectionIndex];
        
        if (self.currentCollection != nil) {
            [currentCollection removeFromSuperview];
            self.currentCollection = nil;
        }
        if (self.nextCollection != nil) {
            [nextCollection removeFromSuperview];
            self.nextCollection = nil;
        }
        if (self.previousCollection != nil) {
            [previousCollection removeFromSuperview];
            self.previousCollection = nil;
        }
        
        collection.center = self.view.center;
        collection.activeInDemo = YES;
        collection.alpha = 1;
        [collection setLayoutImageDelegates:self];
        self.currentCollection = collection;
        [currentCollection addImageGestures];
        [self.view addSubview:collection];
        
        if ([[collections currentGroup] count] > currentCollectionIndex + 1) {
            self.nextCollection = [[collections currentGroup] objectAtIndex:1];
            nextCollection.frame = [self getNextCollectionFrame];
            [self setPropertiesForSideCollection: nextCollection];
            [self.view addSubview:nextCollection];
        }
        
        if ([[collections currentGroup] count] > currentCollectionIndex + 1) {
            self.previousCollection = [[collections currentGroup] objectAtIndex: [[collections currentGroup] count] - 1];
            previousCollection.frame = [self getPreviousCollectionFrame];
            [self setPropertiesForSideCollection: previousCollection];
            [self.view addSubview:previousCollection];
        }
        
        [self.view setNeedsDisplay];
    }
    @catch (NSException *exception) {
        if (exception.name != NSRangeException) {
            @throw;
        }
    }
    @finally {
        
        
    }
   
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (IBAction)homeButtonPressed:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)emailButtonPressed:(id)sender
{
    if (lightboxView.hidden == NO) {
        [self doneEditingCollectionImage:self];
    }
    self.emailView = [[MFMailComposeViewController alloc] init];
    if ([MFMailComposeViewController canSendMail]) {
        [emailView setSubject:@"Your Custom Wall Portraits"];
        emailView.mailComposeDelegate = self;
        [emailView addAttachmentData:UIImagePNGRepresentation([self renderRoomViewToImage])
                            mimeType:@"image/png" 
                            fileName:@"CollectionPreview.png"];
        NSString *messageBody = [NSString stringWithFormat:@"<h1>%@</h1>%@<br /><br />",
                                            currentCollection.name, currentCollection.description];
        if ([currentCollection.priceDescription isEqualToString:@" "]) {
            messageBody = [messageBody stringByAppendingFormat:@"%@<br />", currentCollection.price];
        } else {
            messageBody = [messageBody stringByAppendingFormat:@"%@: %@<br />", currentCollection.priceDescription, currentCollection.price];
        }
        if (![currentCollection.price2 isEqualToString:@" "]) {
            messageBody = [messageBody stringByAppendingFormat:@"%@: %@<br />", currentCollection.price2Description, currentCollection.price2];
        }
        if (![currentCollection.price3 isEqualToString:@" "]) {
            messageBody = [messageBody stringByAppendingFormat:@"%@: %@<br />", currentCollection.price3Description, currentCollection.price3];
        }
        if (![currentCollection.price4 isEqualToString:@" "]) {
            messageBody = [messageBody stringByAppendingFormat:@"%@: %@<br />", currentCollection.price4Description, currentCollection.price4];
        }
        messageBody = [messageBody stringByAppendingString:@"<br />"];
        [emailView setMessageBody:messageBody isHTML:YES];
        
        [self presentViewController:emailView animated:YES completion:nil];

    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mail Not Configured" 
                                                        message:@"This iPad is not configured to send emails." 
                                                       delegate:nil 
                                              cancelButtonTitle:nil 
                                              otherButtonTitles:@"Ok", nil];
        [alert show];
    }
}

- (IBAction)backToSetRoomVC:(id)sender
{
    [self.nextCollection removeFromSuperview];
    [self.previousCollection removeFromSuperview];

    UIViewController *newViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeScreenViewController"];
    [self.slidingViewController setTopViewController:newViewController];

//    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Getting room image from render

- (UIImage*) renderRoomViewToImage
{
    CGPoint originalCenter = self.currentCollection.center;
    CGPoint newCenter = [roomImageView convertPoint:originalCenter fromView:self.view];
    currentCollection.center = newCenter;
    [roomImageView addSubview:currentCollection];
    if(&UIGraphicsBeginImageContextWithOptions != NULL)
        UIGraphicsBeginImageContextWithOptions(roomImageView.frame.size, NO, [[UIScreen mainScreen] scale]);
    
    
    [roomImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    currentCollection.center = originalCenter;
    [self.view addSubview:currentCollection];
    return image;
}

#pragma mark groupButtonPressed

- (IBAction)groupButtonPressed:(id)sender
{
    if (lastGroupButton != nil) {
        lastGroupButton.selected = NO;
    }
    NSError *error = nil;
    UIButton *pressedButton = (UIButton *) sender;
    
    NSString *groupName = [groupIndexes objectAtIndex:pressedButton.tag];
    // First check if the user has access to the selected bundle:
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSArray *purchasedBundles = [prefs objectForKey:@"purchasedBundles"];
    
    BOOL purchased = NO;
    purchased = [purchasedBundles containsObject:groupName];
    
    if (purchased == NO) {
        self.currentGroupName = groupName;
        [self performSegueWithIdentifier:@"demoRoomDABundle" sender:self];
        return;
    }
    


    NSMutableArray *oldGroup = collections.currentGroup;
    [self.collections setCurrentGroupName:[groupIndexes objectAtIndex:pressedButton.tag] error:&error];
    if (error != nil) {
        if ([groupName isEqualToString:@"favorites"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No favorites!"
                                                            message:@"Please visit the Manage Templates section to set some favorite templates!"
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"Ok", nil];
            [alert show];
        } else if ([groupName isEqualToString:kPrevealMyCollectionsGroupName]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You haven't designed any templates"
                                                            message:@"This is where templates you design or download from the Preveal Community will be."
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"Ok", nil];
            [alert show];
        }
        // Fail gracefully back to previous screen, but don't reset Templates
        self.collections.currentGroup = oldGroup;
        [self setButtonStates];
        return;
    }
    self.lastGroupButton = pressedButton;
    [self setButtonStates];
    self.currentGroupName = groupName;
    self.currentCollectionIndex = 0;
    [self resetTemplatesOnScreen];
}

- (IBAction)communityButtonTouched:(id)sender
{
    if ([PrevealCommunityUrls canUseCommunity]) {
        [self performSegueWithIdentifier:@"showCommunityTemplates" sender:sender];
    } else {
        UIViewController *newViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CommunityRegisterViewController"];
        [self.slidingViewController changeTopViewController:newViewController forceReload:NO];

    }
}

/*
- (IBAction)toggleHamburgler:(id)sender
{
    [self.slidingViewController slideRight];
}
 */
#pragma mark -
#pragma mark Handle collection carousseling 


- (CGRect)getNextCollectionFrame
{
    return CGRectMake(self.view.frame.size.width - 25, 
                      self.view.center.y - nextCollection.frame.size.height / 2, 
                      nextCollection.frame.size.width, 
                      nextCollection.frame.size.height);
}

- (IBAction)rotateCollectionsForward:(id)sender
{
    [self hideShareRibbon];
    @try {
        
        if ([[collections currentGroup] count] < 2) {
            return;
        }

        int upcomingIndex;

        if ([collections.currentGroup  count] - 1 >= currentCollectionIndex + 2) {
            upcomingIndex = currentCollectionIndex + 2;
        }else{
            upcomingIndex = currentCollectionIndex + 2 - (int)[collections.currentGroup  count];
        }
        Collection *upcomingCollection = [collections.currentGroup objectAtIndex:upcomingIndex];
        upcomingCollection.frame = CGRectMake(self.view.frame.size.width + self.view.frame.size.width /2,
                                              upcomingCollection.frame.origin.y,
                                              upcomingCollection.frame.size.width,
                                              upcomingCollection.frame.size.height);
        upcomingCollection.alpha = 0;
        
        
        [UIView animateWithDuration:0.5 animations:^{
            previousCollection.frame = CGRectOffset(previousCollection.frame, -1000, 0);
            
            self.previousCollection = self.currentCollection;
            
            [self setPropertiesForSideCollection:previousCollection];
            
            self.currentCollection = self.nextCollection;
            
            self.currentCollectionIndex = currentCollectionIndex + 1;
            
            [self setPropertiesForCurrentCollection];
            
            currentCollection.center = CGPointMake(self.view.center.x, currentCollection.center.y);
            
            previousCollection.frame = [self getPreviousCollectionFrame];
            
            if ([collections.currentGroup count] > currentCollectionIndex + 1) {
                
                self.nextCollection = [collections.currentGroup objectAtIndex:currentCollectionIndex+1];
                nextCollection.frame = [self getNextCollectionFrame];
                [self setPropertiesForSideCollection: nextCollection];
                [self.view addSubview: nextCollection];
            } else {
                self.nextCollection = [collections.currentGroup objectAtIndex: (currentCollectionIndex + 1) - [[collections currentGroup] count]];
                nextCollection.frame = [self getNextCollectionFrame];
                [self setPropertiesForSideCollection: nextCollection];
                [self.view addSubview: nextCollection];
                
                if ((currentCollectionIndex + 1) > [[collections currentGroup] count]) {
                    currentCollectionIndex = currentCollectionIndex - (int)[[collections currentGroup] count];
                }
            }
        }];
            
//        }
    }
    @catch (NSException *exception) {
        if (exception.name != NSRangeException) {
            @throw ;
        }
    }
    @finally {
        
    }
    
    
}

- (CGRect)getPreviousCollectionFrame
{
    return CGRectMake(25 - previousCollection.frame.size.width,
                      self.view.center.y - previousCollection.frame.size.height / 2,
                      previousCollection.frame.size.width,
                      previousCollection.frame.size.height);
    
}

- (CGRect)getCurrentCollectionFrame
{
    return CGRectMake(25 - currentCollection.frame.size.width,
                      self.view.center.y - currentCollection.frame.size.height / 2,
                      currentCollection.frame.size.width,
                      currentCollection.frame.size.height);
    
}

- (IBAction)rotateCollectionsBackward:(id)sender
{
    @try {
        [self hideShareRibbon];
        
        if ([[collections currentGroup] count] < 2) {
            return;
        }
        
//        if (currentCollectionIndex > 0) {
        int upcomingIndex;
        if (currentCollectionIndex - 2 >= 0) {
            upcomingIndex = currentCollectionIndex - 2;
        }else{
            upcomingIndex = currentCollectionIndex - 2 + (int)[[collections currentGroup] count];
        }
        
        Collection *upcomingCollection = [collections.currentGroup objectAtIndex:upcomingIndex];
        upcomingCollection.frame = CGRectMake(- self.view.frame.size.width /2 - upcomingCollection.frame.size.width,
                                              upcomingCollection.frame.origin.y,
                                              upcomingCollection.frame.size.width,
                                              upcomingCollection.frame.size.height);
        
        upcomingCollection.alpha = 0;
        
        
            [UIView animateWithDuration:0.5 animations:^{
                nextCollection.frame = CGRectOffset(nextCollection.frame, 1000, 0);
                
                self.nextCollection = self.currentCollection;
                [self setPropertiesForSideCollection:nextCollection];

//                if (self.previousCollection == nil) {
//                    self.currentCollection = [collections.currentGroup objectAtIndex:(currentCollectionIndex - 1 + [[collections currentGroup] count])];
//                    self.currentCollectionIndex = currentCollectionIndex - 1 + (int)[[collections currentGroup] count];
//                    currentCollection.frame = [self getCurrentCollectionFrame];
//                }else{
                    self.currentCollection = self.previousCollection;
                    self.currentCollectionIndex = currentCollectionIndex - 1;
//                }
            
                [self setPropertiesForCurrentCollection];
                
                nextCollection.frame = [self getNextCollectionFrame];
                currentCollection.center = CGPointMake(self.view.center.x, currentCollection.center.y);
                
                if (currentCollectionIndex > 0) {
                    self.previousCollection = [collections.currentGroup objectAtIndex:currentCollectionIndex - 1];
                    previousCollection.frame = [self getPreviousCollectionFrame];//CGRectOffset(previousCollection.frame, 1000, 0);
                    [self setPropertiesForSideCollection:previousCollection];

                    [self.view addSubview: previousCollection];
                } else {
                    self.previousCollection = [collections.currentGroup objectAtIndex: ([[collections currentGroup] count] - 1 + currentCollectionIndex)];
                    previousCollection.frame = [self getPreviousCollectionFrame];//CGRectOffset(previousCollection.frame, 1000, 0);
                    [self setPropertiesForSideCollection:previousCollection];
                    
                    [self.view addSubview: previousCollection];
                    
                    if (currentCollectionIndex < 0) {
                        currentCollectionIndex = currentCollectionIndex + (int)[[collections currentGroup] count];
                    }
                }
            }];
//        }
    }
    @catch (NSException *exception) {
        if (exception != NSRangeException) {
            @throw;
        }
    }
    @finally {

    
    }
    
}


- (void)setPropertiesForSideCollection: (Collection *)collection
{
    collection.activeInDemo = NO;
    collection.alpha = .3;
    collection.userInteractionEnabled = YES;
    [collection setLayoutImageDelegates:nil];
    [collection removeImageGestures];
}

- (void)setPropertiesForCurrentCollection
{
    currentCollection.alpha = 1;
    currentCollection.activeInDemo = YES;
    currentCollection.userInteractionEnabled = YES;
    [currentCollection setLayoutImageDelegates:self];
    [currentCollection addImageGestures];
}


#pragma mark -
#pragma mark CollectionImageDelegateProtocol methods

- (void)didTouchCollectionImage:(CollectionImage *)collectionImage;
{
    self.currentImage = nil;
    self.currentImage = collectionImage;
    CGPoint newCenter = [self.view convertPoint:collectionImage.center fromView:collectionImage.superview];
    collectionImage.center = newCenter;
    lightboxView.hidden = NO;
    lightboxDimmerView.hidden = NO;
    imageSettingControlsView.hidden = NO;
    self.sizeLabel.text = [collectionImage getSizeAsString];
    [self.view bringSubviewToFront:lightboxDimmerView];
    [self.view addSubview:collectionImage];
    [self.view bringSubviewToFront:collectionImage];
    [self.view bringSubviewToFront:lightboxView];
    [self.view bringSubviewToFront:imageSettingControlsView];

    CGPoint newControlsCenter = [collectionImage convertPoint:CGPointMake(collectionImage.frame.size.width/2, collectionImage.frame.size.height) toView:self.view];
    newControlsCenter.y = newControlsCenter.y + 65;
    newControlsCenter.x = newControlsCenter.x + 9;
    imageSettingControlsView.center = newControlsCenter;

    
    if (collectionImagePinchGestureRecognizer == nil) {
        self.collectionImagePinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scaleCollectionImage:)];
        [collectionImagePinchGestureRecognizer setDelegate:self];
        [self.lightboxView addGestureRecognizer:collectionImagePinchGestureRecognizer];
    }

    if (collectionImagePanGestureRecognizer == nil) {    
        self.collectionImagePanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveCollectionImage:)];
        [collectionImagePanGestureRecognizer setDelegate:self];
        [self.lightboxView addGestureRecognizer:collectionImagePanGestureRecognizer];
    }
    
    if (collectionImageTapGestureRecognizer == nil) {
        collectionImageTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doneEditingCollectionImage:)];
        collectionImageTapGestureRecognizer.numberOfTapsRequired = 2;
        [lightboxView addGestureRecognizer:collectionImageTapGestureRecognizer];
    }
    
    [self setGestureRecognizerEnabledState:NO];
    
    // If the currently selected collection image actually has an image, set the minimum scale correctly.
    if (currentImage.image != nil) {
        _lightboxMimimumScale = [self minimumScaleForImage:currentImage.imageView.image inBounds:currentImage.container.frame.size];

    }
}


- (IBAction)rotateButtonPressed:(id)sender
{
    self.currentCollection = [CollectionRotator rotateCollection:currentCollection];
    [self.collections updateCollection:self.currentCollection];
    [self setPropertiesForCurrentCollection];
}

- (IBAction)doneEditingCollectionImage:(id)sender
{
    lightboxView.hidden = YES;
    lightboxDimmerView.hidden = YES;
    imageSettingControlsView.hidden = YES;
    [self.view sendSubviewToBack:lightboxView];
    [self.view sendSubviewToBack:lightboxDimmerView];
    CGPoint newCenter = [currentCollection convertPoint:currentImage.center fromView:self.view];
    currentImage.center = newCenter;
    [self.currentCollection addSubview:currentImage];
    [self setGestureRecognizerEnabledState:YES];
}

- (IBAction) setImageFromGalleryButtonPushed:(id) sender
{
    if (self.popover == nil) {
        UIImagePickerController *galleryUI = [[UIImagePickerController alloc] init];
        galleryUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        galleryUI.delegate = self;
        
        UIPopoverController *popoverController = [[UIPopoverController alloc] initWithContentViewController:galleryUI];
        self.popover = popoverController;          
    }
    if (self.popover.isPopoverVisible == YES) {
        [popover dismissPopoverAnimated:YES];
    } else {
        [popover presentPopoverFromRect:[(UIButton *)sender frame] inView:imageSettingControlsView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"dropboxModalSegue"]) {
        UINavigationController *nc = [segue destinationViewController];
        UIViewController *vc = nc.topViewController;
        [(DropboxBrowserViewController *) vc setDelegate:self];
       
    } else if ([segue.identifier isEqualToString:@"collectionInfoBox"]) {
        self.infoPopover = [(UIStoryboardPopoverSegue *)segue popoverController];
        [(CollectionInfoPopoverViewController *)[segue destinationViewController] setCurrentCollection:currentCollection];
        [(CollectionInfoPopoverViewController *)[segue destinationViewController] setDemoController:self];
    } else if ([segue.identifier isEqualToString:@"shareCollectionSeque"]) {
        UIPopoverController *thisPopover = [(UIStoryboardPopoverSegue *) segue popoverController];
        ShareTemplateViewController *svc = [[(UINavigationController *)thisPopover.contentViewController viewControllers] objectAtIndex:0];
        svc.demoRoomController = self;
        svc.popoverController = thisPopover;
    } else if ([segue.identifier isEqualToString:@"buildATemplate"] && self.useCurrentTemplateForBuilding == YES) {
        TemplateCreationViewController *builderVC = (TemplateCreationViewController *)segue.destinationViewController;
        Collection *myCollection = [currentCollection copy];
        builderVC.openings = [myCollection.imageLayout mutableCopy];
        self.shouldLoadLastMyTemplate = YES;
    } else if ([segue.identifier isEqualToString:@"showCommunityTemplates"]) {
        [(CollectionManagementViewController *)[segue destinationViewController] setCommunityOnlyMode:YES];
    }

}

- (IBAction)dropBoxButtonPressed:(id)sender
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
#pragma mark ImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    UIImage *newImage = [image fixOrientation];
    
    [self setCurrentImageImage:[PrevealImageScaler scaleImage:newImage]];
    [popover dismissPopoverAnimated:YES];
}

- (void) setCurrentImageImage: (UIImage *)image
{
    [currentImage setImage:image];

    _lightboxMimimumScale = [self minimumScaleForImage:currentImage.imageView.image inBounds:currentImage.container.frame.size];
    [self centerCurrentImageView];
    
    CGAffineTransform currentTransform = currentImage.imageView.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, _lightboxMimimumScale, _lightboxMimimumScale);
    
    
    [currentImage.imageView setTransform:newTransform];
}

- (CGFloat)minimumScaleForImage: (UIImage *)image inBounds:(CGSize)bounds
{
    CGFloat horizontalRatio = bounds.width / image.size.width;
    CGFloat verticalRatio = bounds.height / image.size.height;
    return MAX(horizontalRatio, verticalRatio);
}

- (void)didSelectImageFromDropbox:(UIImage *)image;
{
    @try {
        [self setCurrentImageImage:[PrevealImageScaler scaleImage:image]];
    } @catch (NSException *exception) {
        if (![exception.name isEqualToString:NSRangeException]) {
            @throw;
        }
    } @finally {
        
    }

}

#pragma mark -
#pragma mark Collection level gestures

- (IBAction)move:(id)sender {
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:roomImageView];
    
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        _firstX = [currentCollection center].x;
        _firstY = [currentCollection center].y;
    }
    
    translatedPoint = CGPointMake(_firstX+translatedPoint.x, _firstY+translatedPoint.y);
    
    [currentCollection setCenter:translatedPoint];
}

- (void)setGestureRecognizerEnabledState: (BOOL)newState
{
    collectionPanGestureRecognizer.enabled = newState;
    leftSwipe.enabled = newState;
    rightSwipe.enabled = newState;
    collectionImagePinchGestureRecognizer.enabled = !newState;
    collectionImagePanGestureRecognizer.enabled = !newState;
}

#pragma mark -
#pragma CollectionImage Gestures

- (IBAction)moveCollectionImage:(id)sender 
{
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:roomImageView];

    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        _lightboxFirstX = currentImage.imageView.center.x;
        _lightboxFirstY = currentImage.imageView.center.y;
    }
    
    translatedPoint = CGPointMake(_lightboxFirstX+translatedPoint.x, _lightboxFirstY+translatedPoint.y);

    [self preventExposingWhitespaceWhenAdjustingImageToNewCenter:translatedPoint];
}

- (IBAction)scaleCollectionImage:(id)sender
{

    if([(UIPinchGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        _lightboxLastScale = 1.0;
    }

    CGFloat scale = 1.0 - (_lightboxLastScale - [(UIPinchGestureRecognizer*)sender scale]);
    if (scale < 0) { // Don't flip the image upside down
        return; 
    }
    CGAffineTransform currentTransform = currentImage.imageView.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    
    CGFloat newScaleForImage = sqrt(newTransform.a*newTransform.a + newTransform.c*newTransform.c);
    if (newScaleForImage < _lightboxMimimumScale) {
        return;
    } 

    [currentImage.imageView setTransform:newTransform];
    _lightboxLastScale = [(UIPinchGestureRecognizer*)sender scale];
    currentImage._lightboxLastScale = _lightboxLastScale;

    
    [self preventExposingWhitespaceWhenAdjustingImageToNewCenter:currentImage.imageView.center];
 
}

- (void) preventExposingWhitespaceWhenAdjustingImageToNewCenter: (CGPoint) newCenter
{
    //1. Get the bounds of the image based on its current scale
    CGRect transformedBounds = CGRectApplyAffineTransform(currentImage.imageView.bounds, currentImage.imageView.transform);
    
    // Find the center x and y of the transformed bounds
    CGFloat halfImageHeight = transformedBounds.size.height / 2;
    CGFloat halfImageWidth = transformedBounds.size.width / 2;    
    
    // Set the bounding points as center points
    CGFloat lowerYBounds = currentImage.container.frame.size.height - halfImageHeight;
    CGFloat higherYBounds = halfImageHeight;
    
    CGFloat lowerXBounds = currentImage.container.frame.size.width - halfImageWidth;
    CGFloat higherXBounds = halfImageWidth;
    
    // If a pan tries to drag a center point outside our bounding points, just reset it back to the bounding point
    if (newCenter.x < lowerXBounds) {
        newCenter.x = lowerXBounds;
    } else if (newCenter.x > higherXBounds) {
        newCenter.x = higherXBounds;
    }
    if (newCenter.y < lowerYBounds) {
        newCenter.y = lowerYBounds;
    } else if (newCenter.y > higherYBounds) {
        newCenter.y = higherYBounds;
    }
    
    // Now that we've made sure we're not dragging too much, set the new ceter for the image view.
    [currentImage.imageView setCenter:newCenter];
}

- (void) centerCurrentImageView 
{
    currentImage.imageView.center = [currentImage convertPoint:currentImage.container.center toView:currentImage.container];
}



#pragma mark - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    if (result == MFMailComposeErrorCodeSendFailed) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Sending Mail" 
                                                        message:@"There was a problem delivering your message. Please try again." 
                                                       delegate:nil 
                                              cancelButtonTitle:nil 
                                              otherButtonTitles:@"Ok", nil];
        [alert show];   
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Getting the event for image rotation

- (IBAction)rotate:(id)sender
{

    CGAffineTransform newTransform;
    if([(UIRotationGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        self.initialRotationTransform = currentCollection.transform;
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
            [currentCollection setTransform:newTransform];
        }];
    
        NSEnumerator *e = [currentCollection.subviews objectEnumerator];
        CollectionImage *v;
        while (v = [e nextObject]) {
            v.frame = CGRectMake(0, 0, v.frame.size.height, v.frame.size.width);
            v.container.frame = v.frame;
            [v setImage:v.imageView.image];
            /*
            CGAffineTransform subViewTransform = v.transform;
            CGAffineTransform newSubViewTransform;
            if (_lastRotation >= 0.78535) {
                rotations = ceil(_lastRotation / 1.57079633);
                newSubViewTransform = CGAffineTransformRotate(subViewTransform, rotations * 1.57079633);
                [v setTransform:newSubViewTransform];
            } else if (_lastRotation <= -0.78535) {
                rotations = floor(_lastRotation / 1.57079633);
                newSubViewTransform = CGAffineTransformRotate(subViewTransform, rotations * 1.57079633);
                [v setTransform: newSubViewTransform];
            } 
            */
        }
        /* If the number of rotations is even we didn't actually change orientation
        if (rotations % 2 != 0) {
            [self switchActualSizeOfScale];
        }
         */
        
        _lastRotation = 0.0;
        return;
    }
    
    CGFloat rotation = 0.0 - (_lastRotation - [(UIRotationGestureRecognizer*)sender rotation]);
    
    _totalRotation = _totalRotation + rotation;
    CGAffineTransform currentTransform = currentCollection.transform;
    newTransform = CGAffineTransformRotate(currentTransform,rotation);
    
    [currentCollection setTransform:newTransform];
    
    _lastRotation = [(UIRotationGestureRecognizer*)sender rotation];
}



#pragma mark - build a template
- (IBAction)buildTemplateBasedOnCurrent:(id)sender
{
    if ([infoPopover isPopoverVisible]) {
        [infoPopover dismissPopoverAnimated:YES];
    }
    self.useCurrentTemplateForBuilding = YES;
    [self performSegueWithIdentifier:@"buildATemplate" sender:self];
}

#pragma mark - sharing is caring
- (IBAction)shareButtonPressed:(id)sender
{
    [self showShareRibbon];
}

- (IBAction)chooseTemplateButtonPressed:(id)sender
{
    [self hideShareRibbon];
}


- (IBAction)shareToFacebookButtonPressed:(id)sender
{
    if ([self isFacebookAvailable]){
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
            SLComposeViewController *fb = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            [fb setInitialText:@"\nCreated with #Preveal | getpreveal.com"];
            [fb addImage:[self renderRoomViewToImage]];
            [self presentViewController:fb animated:YES completion:nil];
        } else {
            UIAlertView *aview = [[UIAlertView alloc] initWithTitle:@"Facebook not configured" message:@"Please setup your Facebook account in the settings app" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [aview show];
        }
    } else {
        UIAlertView *aview = [[UIAlertView alloc] initWithTitle:@"Facebook not avaialble" message:@"Facebook integration is only available on iOS versions 6.0 and greater. Please update iOS to allow sharing to Facebook." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [aview show];
    }
}

- (BOOL) isFacebookAvailable
{
    Class SocialClass = NSClassFromString(@"SLComposeViewController");
    if (SocialClass != nil) {
        return YES;
    }
    return NO;
}

- (IBAction)shareToTwitterButtonPressed:(id)sender
{
    
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *tweet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweet setInitialText:@"\nCreated with #preveal | getpreveal.com"];
        [tweet addImage:[self renderRoomViewToImage]];
        [self presentViewController:tweet animated:YES completion:nil];
    } else {
        UIAlertView *aview = [[UIAlertView alloc] initWithTitle:@"Twitter not configured"
                                                        message:@"Please setup your Twitter account in the settings app"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles: nil];
        [aview show];
    }
   
}

- (IBAction)shareToEmailButtonPressed:(id)sender
{
    @try {
        if (lightboxView.hidden == NO) {
            [self doneEditingCollectionImage:self];
        }
        self.emailView = [[MFMailComposeViewController alloc] init];
        if ([MFMailComposeViewController canSendMail]) {
            [emailView setSubject:@"Your Custom Wall Portraits"];
            emailView.mailComposeDelegate = self;
            [emailView addAttachmentData:UIImagePNGRepresentation([self renderRoomViewToImage])
                                mimeType:@"image/png"
                                fileName:@"CollectionPreview.png"];
            NSString *messageBody = [NSString stringWithFormat:@"<h1>%@</h1>%@<br /><br />",
                                     currentCollection.name, currentCollection.description];
            NSString *currencySymbol =  [[NSUserDefaults standardUserDefaults] objectForKey:@"currencySymbol"];

            if ([self priceFieldShouldBeDisplayed:currentCollection.price]) {
                if ([currentCollection.priceDescription isEqualToString:@" "]) {
                    messageBody = [messageBody stringByAppendingFormat:@"%@<br />", currentCollection.price];
                } else {
                    messageBody = [messageBody stringByAppendingFormat:@"%@: %@%@<br />", currentCollection.priceDescription, currencySymbol,currentCollection.price];
                }
            }
            if ([self priceFieldShouldBeDisplayed:currentCollection.price2]) {
                messageBody = [messageBody stringByAppendingFormat:@"%@: %@%@<br />", currentCollection.price2Description, currencySymbol,currentCollection.price2];
            }
            if ([self priceFieldShouldBeDisplayed:currentCollection.price3]) {
                messageBody = [messageBody stringByAppendingFormat:@"%@: %@%@<br />", currentCollection.price3Description, currencySymbol,currentCollection.price3];
            }
            if ([self priceFieldShouldBeDisplayed:currentCollection.price4]) {
                messageBody = [messageBody stringByAppendingFormat:@"%@: %@%@<br />", currentCollection.price4Description, currencySymbol,currentCollection.price4];
            }
            messageBody = [messageBody stringByAppendingString:@"<br />"];
            [emailView setMessageBody:messageBody isHTML:YES];
            

            [self presentViewController:emailView animated:YES completion:nil];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mail Not Configured"
                                                            message:@"This iPad is not configured to send emails."
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"Ok", nil];
            [alert show];
        }
    }
    @catch (NSException *e) {
        NSLog(@"-----------sharetoEmailButtonPressed: %@", e.description);
    }
    @finally {
        
    }
}


- (IBAction)shareToCameraRollButtonPressed:(id)sender
{
    UIImageWriteToSavedPhotosAlbum([self renderRoomViewToImage], self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Saved" message:@"The template was saved to your camera roll" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    [alert show];
}



- (IBAction)shareToPintrestButtonPressed:(id)sender
{
    
}

- (void) showShareRibbon
{
    self.groupButtonRibbon.hidden = YES;
    self.shareButtonRibbon.hidden = NO;
}
 
- (void) hideShareRibbon
{
    self.shareButtonRibbon.hidden = YES;
    self.groupButtonRibbon.hidden = NO;
}

#pragma mark - overriding the toggleHamburgler
// Override this so we can hide the left most collection
- (IBAction)toggleHamburgler:(id)sender
{
    previousCollection.hidden = YES;
    [self.slidingViewController slideRight];
}

#pragma mark - memory crap

- (void) didReceiveMemoryWarning
{
    
}

- (BOOL) priceFieldShouldBeDisplayed: (NSString *)checkingPriceField
{
    return (![checkingPriceField isEqualToString:@" "] &&
            ![checkingPriceField isEqualToString:@"(null)"] &&
            ![checkingPriceField isEqualToString:@"0.00"] &&
            ![checkingPriceField isEqualToString:@"$0.00"] &&
            checkingPriceField != nil &&
            checkingPriceField != NULL
            );
}


- (BOOL)prefersStatusBarHidden {
    return YES;
}
@end
