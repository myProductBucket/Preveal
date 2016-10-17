//
//  CollectionDetailEditViewController.m
//  precapture
//
//  Created by Randy Crafton on 6/20/12.
//  Copyright (c) 2012 Preveal. All rights reserved.
//

#import "CollectionDetailEditViewController.h"
#import "Collection.h"
#import "Scalinator.h"
#import "CollectionUploader.h"
#import "PrevealCommunityUrls.h"
#import "CreatedCollectionHandler.h"
#import "TemplateCreationViewController.h"
#import "LoginManager.h"
#import "PrevealUser.h"

@interface CollectionDetailEditViewController ()

@end

@implementation CollectionDetailEditViewController

@synthesize nameField, priceField, descriptionField, collectionPreviewView, currentCollection;
@synthesize originalCenter, showCollectionSwitch, favoriteSwitch;
@synthesize price3Field, price2Field, price4Field, priceDescriptionField, price2DescriptionField, price3DescriptionField, price4DescriptionField, otherPriceField;
@synthesize uploadSwitch, uploadText, showUpload, previousViewController, headerImageView;
@synthesize smoochMessageButton;

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setBadgeNumber) name:SKTConversationUnreadCountDidChangeNotification object:nil];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setBadgeNumber];

    if (currentCollection != nil) {
        nameField.text = [currentCollection.name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        descriptionField.text = [currentCollection.description stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        priceField.text = [currentCollection.price stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        price2Field.text = currentCollection.price2;
        price3Field.text = [currentCollection.price3 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        price4Field.text = [currentCollection.price4 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        priceDescriptionField.text = [currentCollection.priceDescription stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        price2DescriptionField.text = [currentCollection.price2Description stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        price3DescriptionField.text = [currentCollection.price3Description stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        price4DescriptionField.text = [currentCollection.price4Description stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (currentCollection.layoutLoaded != YES) {
            [currentCollection addLayout];
        }
        Scalinator *scalinator = [[Scalinator alloc] init];
        CGFloat referenceSize = 60.0;
        scalinator.actualSize = [NSDecimalNumber decimalNumberWithString:@"11"];
        BOOL fits = NO;
        while (fits == NO) {
            scalinator.referenceSize = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f", referenceSize]];

            [currentCollection scaleViewToRoom:scalinator];
            if (currentCollection.frame.size.width <= collectionPreviewView.frame.size.width
                && currentCollection.frame.size.height <= collectionPreviewView.frame.size.height) {
                fits = YES;
            } else {
                referenceSize = referenceSize - 5.0;
                scalinator.ratio = nil;
                currentCollection.scaled = NO;
            } 
            if (referenceSize <= 1) { fits = YES; } //halt if the scaling fails
        }

        currentCollection.center = CGPointMake(collectionPreviewView.center.x, currentCollection.center.y);
        [collectionPreviewView addSubview:currentCollection];
        [showCollectionSwitch setOn:[currentCollection.show isEqualToString:@"1"] animated:YES];
        [favoriteSwitch setOn:[currentCollection.isFavorite isEqualToString:@"1"] animated:YES];

    }
    uploadSwitch.on = NO;
    if (showUpload == YES && [PrevealCommunityUrls canUseCommunity]) {
        uploadText.hidden = NO;
        uploadSwitch.hidden = NO;
        headerImageView.image = [UIImage imageNamed:@"text-save-new-template.png"];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (NSUInteger) supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

#pragma mark - 
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

- (IBAction)smoochMessageTouchUp:(UIButton *)sender {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:0] forKey:BADGE_NUMBER];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [Smooch showConversationFromViewController:self];
}


- (IBAction)cancel:(id)sender
{
    [currentCollection removeFromSuperview];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)save:(id)sender
{
    currentCollection.name = nameField.text;
    currentCollection.description = descriptionField.text;
    currentCollection.price = priceField.text;
    currentCollection.price2 = price2Field.text;
    currentCollection.price3 = price3Field.text;
    currentCollection.price4 = price4Field.text;
    currentCollection.priceDescription = priceDescriptionField.text;
    currentCollection.price2Description = price2DescriptionField.text;
    currentCollection.price3Description = price3DescriptionField.text;
    currentCollection.price4Description = price4DescriptionField.text;
    
    
    LoginManager *lm = [LoginManager sharedInstance];
    [lm loadUserDocument];
    PrevealUser *user = lm.user;
    
    if (user != nil) {
        currentCollection.studioName = user.studioName;
        currentCollection.studioUrl = user.studioURL;
    }
    
    if (showCollectionSwitch.on) {
        currentCollection.show = @"1";
    } else {
        currentCollection.show = @"0";
    }
    
    if (favoriteSwitch.on) {
        currentCollection.isFavorite = @"1";
    } else {
        currentCollection.isFavorite = @"0";
    }
    
    [currentCollection saveToFile];
    if (self.showUpload == YES &&
        self.uploadSwitch.on == YES &&
        [currentCollection.imageLayout count] > 2) // Don't upload anything with fewer than 3 canvases.
    {
        [CollectionUploader saveCollectionToServer:currentCollection];
    }
    
    [currentCollection removeFromSuperview];
    
    if ([previousViewController class] == [TemplateCreationViewController class]) {
        [(TemplateCreationViewController *)previousViewController setDoneEditing:YES];
    }

    [self dismissViewControllerAnimated:YES completion:nil];
    [previousViewController viewWillAppear:YES];
}


- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
