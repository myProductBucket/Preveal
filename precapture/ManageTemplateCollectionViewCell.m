//
//  ManageTemplateCollectionViewCell.m
//  precapture
//
//  Created by Randy Crafton on 4/2/15.
//  Copyright (c) 2015 Preveal. All rights reserved.
//

#import "ManageTemplateCollectionViewCell.h"
#import "Collection.h"
#import "Collections.h"
#import "Scalinator.h"
#import "UIAlertView+Context.h"

@implementation ManageTemplateCollectionViewCell

@synthesize delegate;
@synthesize collection, collectionFavoritedButton, collectionVisibleButton, editDetailsButton, deleteButton, templateView, templateNameLabel;
@synthesize activityView;

- (void) setMyCollection:(Collection *)myCollection
{
    [self clearActivityView];
    
    for (UIView *subview in templateView.subviews) {
        [subview removeFromSuperview];
    }
    self.collection = myCollection;
    [self sizeCollection];
    if ([collection.name isEqualToString:@""]) {
        templateNameLabel.text = @"Un-named";
    } else {
        templateNameLabel.text = collection.name;
    }
    [templateNameLabel setAdjustsFontSizeToFitWidth:YES];
    collection.center = [self getCenterPoint];
    //[self.contentView addSubview:collection];
    [self.templateView addSubview:self.collection];
    [self setVisibleButtonImage];
    [self setFavoriteButtonImage];
}

- (void) clearActivityView
{
    if (self.activityView != nil) {
        [activityView removeFromSuperview];
        [activityView stopAnimating];
        self.activityView = nil;
    }
}

- (CGPoint) getCenterPoint
{
    return CGPointMake(175/2, 55);
}

- (void) sizeCollection
{
    if (collection.scaled == NO) {
        
        Scalinator *scalinator = [[Scalinator alloc] init];
        scalinator.actualSize = [NSDecimalNumber decimalNumberWithString:@"11"];
        scalinator.referenceSize = [NSDecimalNumber decimalNumberWithString:@"13"];
        
        CGFloat referenceSize = 23.0;
        BOOL fits = NO;
        while (fits == NO) {
            scalinator.referenceSize = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f", referenceSize]];
            [collection scaleViewToRoom:scalinator addSizeLabels:NO];
            if (collection.frame.size.width <= templateView.frame.size.width && collection.frame.size.height <= templateView.frame.size.height) {
                fits = YES;
            } else {
                referenceSize = referenceSize - 1.0;
                collection.scaled = NO;
                scalinator.ratio = nil;
            }
            if (referenceSize == 1) { fits = YES; } //halt if the scaling fails
        }
    }
}

#pragma mark -
#pragma mark button touches
- (IBAction)didTouchShowButton:(id)sender
{
    if ([self.collection.show isEqualToString:@"1"])
    {
        collection.show = @"0";
    } else {
        collection.show = @"1";
    }
    [self setVisibleButtonImage];
    [self.collection saveToFile];
}

- (IBAction)didTouchEditButton:(id)sender
{
    [self.collection saveToFile];
    [delegate showEditViewForCollection:collection];
    
}


- (IBAction)didTouchFavoriteButton:(id)sender
{
    if ([self.collection.isFavorite isEqualToString:@"1"])
    {
        collection.isFavorite = @"0";
    } else {
        collection.isFavorite = @"1";
    }
    [self setFavoriteButtonImage];
    [self.collection saveToFile];
    
}

- (IBAction)didTouchDeleteButton:(id)sender
{
    NSLog(@"Deleting %@", self.collection.file_name);
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Confirm"
                                                        message:[NSString stringWithFormat:@"Are you sure you want to delete %@", self.collection.name]
                                                       delegate:self
                                              cancelButtonTitle:@"Nevermind"
                                              otherButtonTitles:@"Yes", nil];
    alertView.context = self.collection.file_name;
    [alertView show];
}


- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex > 0) {
        [Collections permanentlyDeleteCollectionWithFileName:alertView.context];
        [delegate reload];
    }
}


#pragma mark -
#pragma mark set button states

- (void) setVisibleButtonImage
{
    if ([self.collection.show isEqualToString:@"1"] )
    {
        self.collection.alpha = 1.0;
        [collectionVisibleButton setImage:[UIImage imageNamed:@"manage-card-show-default.png"]  forState:UIControlStateNormal];
    } else {
        self.collection.alpha = 0.3;
        [collectionVisibleButton setImage:[UIImage imageNamed:@"manage-card-show-hidden.png"]  forState:UIControlStateNormal];
    }
}

- (void) setFavoriteButtonImage
{
    if ([self.collection.isFavorite isEqualToString:@"1"])
    {
        [collectionFavoritedButton setImage:[UIImage imageNamed:@"manage-card-fave-faved.png"] forState:UIControlStateNormal];
        
    } else {
        [collectionFavoritedButton setImage:[UIImage imageNamed:@"manage-card-fave-default.png"] forState:UIControlStateNormal];
    }
}

- (IBAction)putInWaitingState:(id)sender
{
    if (self.activityView == nil) {
        self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [activityView startAnimating];
        activityView.center = [self getCenterPoint];
        [self addSubview:activityView];
        
        templateNameLabel.text = @"Downloading....";
        if (self.collection != nil) {
            [collection removeFromSuperview];
            self.collection = nil;
        }
    }
}

@end
