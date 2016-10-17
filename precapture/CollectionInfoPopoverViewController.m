//
//  CollectionInfoPopoverViewController.m
//  precapture
//
//  Created by Randy Crafton on 6/20/12.
//  Copyright (c) 2012 Preveal. All rights reserved.
//

#import "CollectionInfoPopoverViewController.h"
#import "Collection.h"
#import "DemoRoomViewController.h"

@interface CollectionInfoPopoverViewController ()

@end

@implementation CollectionInfoPopoverViewController

@synthesize nameLabel, descriptionLabel, priceLabel, currentCollection, demoController, faveButton;
@synthesize price2Label, price3Label, price4Label, priceDescriptionLabel, price2DescriptionLabel, price3DescriptionLabel, price4DescriptionLabel;


- (void)viewDidLoad
{
    [super viewDidLoad];

//    self.navigationController.navigationBar.barTintColor = [UIColor redColor];
//    self.navigationController.navigationBar.translucent = NO;
    self.contentSizeForViewInPopover = CGSizeMake(220.0, 450.0);
    self.preferredContentSize = CGSizeMake(220.0, 450.0);

}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (currentCollection != nil) {
        [self hideAllPriceLabels];
        nameLabel.text = currentCollection.name;
        descriptionLabel.text = currentCollection.description;
        [descriptionLabel sizeToFit];
        if ([self priceFieldShouldBeDisplayed:currentCollection.price]) {
            priceDescriptionLabel.text = currentCollection.priceDescription;
            priceDescriptionLabel.hidden = NO;
            priceLabel.hidden = NO;
            priceLabel.text = currentCollection.price;
        }
        if ([self priceFieldShouldBeDisplayed:currentCollection.price2]) {
            price2DescriptionLabel.text = currentCollection.price2Description;
            price2DescriptionLabel.hidden = NO;
            price2Label.text = currentCollection.price2;
            price2Label.hidden = NO;
        }
        if ([self priceFieldShouldBeDisplayed:currentCollection.price3]) {
            price3DescriptionLabel.text = currentCollection.price3Description;
            price3DescriptionLabel.hidden = NO;
            price3Label.text = currentCollection.price3;
            price3Label.hidden = NO;
        }
        if ([self priceFieldShouldBeDisplayed:currentCollection.price4]) {
            price4DescriptionLabel.text = currentCollection.price4Description;
            price4DescriptionLabel.hidden = NO;
            price4Label.text = currentCollection.price4;
            price4Label.hidden = NO;
        }
    }
    [self setFaveButtonImage];
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

- (void) hideAllPriceLabels
{
    priceDescriptionLabel.hidden = YES;
    price2DescriptionLabel.hidden = YES;
    price3DescriptionLabel.hidden = YES;
    price4DescriptionLabel.hidden = YES;
    priceLabel.hidden = YES;
    price2Label.hidden = YES;
    price3Label.hidden = YES;
    price4Label.hidden = YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (IBAction)faveButtonTouched:(id)sender
{
    if ([self.currentCollection.isFavorite isEqualToString:@"1"]) {
        self.currentCollection.isFavorite = @"0";
    } else {
        self.currentCollection.isFavorite = @"1";
    }
    [self.currentCollection saveToFile];
    [self setFaveButtonImage];
    
}

- (IBAction)buildButtonTouched:(id)sender
{
    [self.demoController buildTemplateBasedOnCurrent:self];
}


- (void) setFaveButtonImage
{
    if ([self.currentCollection.isFavorite isEqualToString:@"1"]) {
        [self.faveButton setImage:[UIImage imageNamed:@"btn-edit-template-fave-on.png"] forState:UIControlStateNormal];
    } else {
        [self.faveButton setImage:[UIImage imageNamed:@"btn-edit-template-fave-off.png"] forState:UIControlStateNormal];
    }
}


@end
