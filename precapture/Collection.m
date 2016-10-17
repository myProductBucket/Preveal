//
//  Collection.m
//  precapture
//
//  Created by Randy Crafton on 3/10/12.
//  Copyright (c) 2012 TouchSpring Design. All rights reserved.
//

#import "Collection.h"
#import "CollectionImage.h"
#import "CollectionSpace.h"
#import "CollectionShelf.h"
#import "CollectionFramedImage.h"
#import "CollectionImageDiamondCanvas.h"
#import "CollectionElementProtocol.h"
#import "PreCaptureSessionDetails.h"
#import "Scalinator.h"
#import <QuartzCore/QuartzCore.h>
#import "Collections.h"
#include <math.h>

@implementation Collection


@synthesize name, price, file_name, description, purchased, free, order, type, inAppPrice, imageLayout;
@synthesize originalFrame, activeInDemo, layoutLoaded, scaled, show, isFavorite, groupName, initialRotation;
@synthesize price2, price3, price4, priceDescription, price2Description, price3Description, price4Description;
@synthesize currentRotation, studioName, studioUrl, createdBy;


- (void)saveToFile 
{
    NSError *error = nil;

    NSData *jsonData = [self asJSONData];
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *userCollectionsDirectory = [documentsDirectory stringByAppendingPathComponent:@"Collections"];
    [jsonData writeToFile:[userCollectionsDirectory stringByAppendingPathComponent:file_name]
                  options:NSDataWritingAtomic 
                    error:&error];
}

- (NSData *) asJSONData
{
    NSError *error = nil;

    NSDictionary *dictRepresentation = [self renderAsDictionary];
    return [NSJSONSerialization dataWithJSONObject:dictRepresentation
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
}

- (NSData *) asCleanJSONData
{
    NSError *error = nil;
    
    NSMutableDictionary *dictRepresentation = [NSMutableDictionary dictionaryWithDictionary:[self renderAsDictionary]];
    
    // Sanitize
    [dictRepresentation setObject:@"0" forKey:@"isFavorite"];
    [dictRepresentation setObject:@"0" forKey:@"price"];
    [dictRepresentation setObject:@"0" forKey:@"price2"];
    [dictRepresentation setObject:@"0" forKey:@"price3"];
    [dictRepresentation setObject:@"0" forKey:@"price4"];

    [dictRepresentation setObject:@"Canvas" forKey:@"priceDescription"];
    [dictRepresentation setObject:@"Metal" forKey:@"price2Description"];
    [dictRepresentation setObject:@"Acrylic" forKey:@"price3Description"];
    [dictRepresentation setObject:@"Standout" forKey:@"price4Description"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [dictRepresentation setObject:[defaults objectForKey:COMMUNITY_USERNAME] forKey:@"createdBy"];
    [dictRepresentation setObject:[defaults objectForKey:STUDIO_NAME] forKey:@"studioName"];
    [dictRepresentation setObject:[defaults objectForKey:STUDIO_URL] forKey:@"studioUrl"];
    [dictRepresentation setObject:@"communityTemplates" forKey:@"groupName"];
    
    return [NSJSONSerialization dataWithJSONObject:dictRepresentation
                                           options:NSJSONWritingPrettyPrinted
                                             error:&error];
}
- (BOOL)isAvailableForUse
{
    BOOL isAvailable = NO;
    if ([free isEqualToString:@"YES"] == YES) {
        isAvailable = YES;
    } else if ([purchased isEqualToString:@"YES"] == YES) {
        isAvailable = YES;
    }
    return isAvailable;
}

- (void)addLayout
{

    NSEnumerator *e = [self.imageLayout objectEnumerator];
    UIView <CollectionElementProtocol> *layoutElement;
    float maxX = 0.0;
    float maxY = 0.0;
    while (layoutElement = [e nextObject]) {
        if ([layoutElement class] == [CollectionImage class] ||[layoutElement class] == [CollectionShelf class] ) {
            if ([layoutElement.x floatValue] + [layoutElement.width floatValue] > maxX) {
                maxX = [layoutElement.x floatValue] + [layoutElement.width floatValue];
            }
            if ([layoutElement.y floatValue] + [layoutElement.height floatValue] > maxY) {
                maxY = [layoutElement.y floatValue] + [layoutElement.height floatValue];
            }
        } else if ([layoutElement class] == [CollectionFramedImage class]) {
            CollectionFramedImage *framedElement = (CollectionFramedImage *) layoutElement;
            if ([framedElement.frameX floatValue] + [framedElement.frameWidth floatValue] > maxX) {
                maxX = [framedElement.frameX floatValue] + [framedElement.frameWidth floatValue];
            }
            if ([framedElement.frameY floatValue] + [framedElement.frameHeight floatValue] > maxY) {
                maxY = [framedElement.frameY floatValue] + [framedElement.frameHeight floatValue];
            }
        } else if ([layoutElement class] == [CollectionImageDiamondCanvas class]) {
            if ([layoutElement.x floatValue] + [layoutElement.width floatValue] > maxX) {
                maxX = [layoutElement.x floatValue] + [layoutElement.width floatValue];
            }
            if ([layoutElement.y floatValue] + [layoutElement.height floatValue] > maxY) {
                maxY = [layoutElement.y floatValue] + [layoutElement.height floatValue];
            }
        }
        [self addSubview:layoutElement];
        [layoutElement setCollection:self];
    }
    self.frame = CGRectMake(0.0, 0.0, maxX, maxY);
    self.originalFrame = self.frame;
    self.layoutLoaded = YES;
    self.scaled = NO;

}



- (void)scaleViewToRoom: (Scalinator *)scalinator
{
    [self scaleViewToRoom:scalinator addSizeLabels:YES];
    
}

- (void)scaleViewToRoom: (Scalinator *)scalinator addSizeLabels: (BOOL) addSizeLables
{
    if (scaled == NO) {
        self.frame = [scalinator getAdjustedFrame:self.originalFrame];
        NSEnumerator *e = [self.imageLayout objectEnumerator];
        UIView <CollectionElementProtocol> *layoutElement;
        while (layoutElement = [e nextObject]) {
            layoutElement.frame = [scalinator getAdjustedFrame:layoutElement.originalFrame];

            NSEnumerator *e2 = [layoutElement.subviews objectEnumerator];
            UIView *subview;
            while (subview = [e2 nextObject]) {
                subview.frame = [scalinator getAdjustedFrame:subview.frame];
                subview.center = layoutElement.center;
            }

            [layoutElement configureViewDetails];
            [layoutElement doneResizingWithScalinator:scalinator];
            
            if (addSizeLables == YES) {
                [layoutElement addSizeLabel];
            }
        }
        CGRect appFrame = [[[UIScreen alloc] init] applicationFrame];
        self.frame = CGRectMake(appFrame.size.width + appFrame.size.width/2, appFrame.size.height/2, self.frame.size.width, self.frame.size.height);
        self.scaled = YES;
    }
}


- (void)setLayoutImageDelegates:(id) imageDelegate;
{
    NSEnumerator *e = [self.imageLayout objectEnumerator];
    UIView <CollectionElementProtocol> *layoutElement;
    while (layoutElement = [e nextObject]) {
        if ([layoutElement isKindOfClass:[CollectionImage class]]) {
            [(CollectionImage *)layoutElement setDelegate:imageDelegate];
        }
    }
}

#pragma mark
#pragma CollectionElementsProtocol

- (void)loadFromDictionary: (NSDictionary *) definition
{
    self.activeInDemo = NO;
    self.name = [definition objectForKey:@"name"];
    self.file_name = [definition objectForKey:@"file_name"];
    
    self.price = [self getStringValue:definition fromKey:@"price"];
    self.price2 = [self getStringValue:definition fromKey:@"price2"];
    self.price3 = [self getStringValue:definition fromKey:@"price3"];
    self.price4 = [self getStringValue:definition fromKey:@"price4"];
    self.priceDescription = [definition objectForKey:@"priceDescription"];
    self.price2Description = [definition objectForKey:@"price2Description"];
    self.price3Description = [definition objectForKey:@"price3Description"];
    self.price4Description = [definition objectForKey:@"price4Description"];
    self.purchased = [definition objectForKey:@"purchased"];
    self.free = [definition objectForKey:@"free"];
    self.order = [definition objectForKey:@"order"];
    self.type = [definition objectForKey:@"type"];
    self.inAppPrice = [definition objectForKey:@"in_app_price"];
    
    
    self.show = [NSString stringWithFormat:@"%@", [definition objectForKey:@"show"]];
    self.description = [definition objectForKey:@"description"];
    self.groupName = [definition objectForKey:@"groupName"];
    self.isFavorite = [NSString stringWithFormat:@"%@", [definition objectForKey:@"isFavorite"]];
    self.initialRotation = [definition objectForKey:@"initialRotation"];
    self.studioUrl = [definition objectForKey:@"studioUrl"];
    self.studioName = [definition objectForKey:@"studioName"];
    self.createdBy = [definition objectForKey:@"createdBy"];
    
    NSMutableArray *myLayout = [[NSMutableArray alloc ] init];
    NSEnumerator *e = [(NSArray *)[definition objectForKey:@"layout"] objectEnumerator];
    NSDictionary *layoutElement;
    CollectionImage *collectionImage;
    
    while (layoutElement = [e nextObject]) {
        if ([[layoutElement objectForKey:@"class"] isEqualToString:@"CollectionImage"]) {
            collectionImage = [[CollectionImage alloc] init];
            [collectionImage loadFromDictionary:layoutElement];
            [myLayout addObject:collectionImage];
        } else if ([[layoutElement objectForKey:@"class"] isEqualToString:@"CollectionFramedImage"]) {
            collectionImage = [[CollectionFramedImage alloc] init];
            [collectionImage loadFromDictionary:layoutElement];
            [myLayout addObject:collectionImage];
        } else if ([[layoutElement objectForKey:@"class"] isEqualToString:@"CollectionImageDiamondCanvas"]) {
            collectionImage = [[CollectionImageDiamondCanvas alloc] init];
            [collectionImage loadFromDictionary:layoutElement];
            [myLayout addObject:collectionImage];
        } else if ([[layoutElement objectForKey:@"class"] isEqualToString:@"CollectionShelf"]) {
            collectionImage = [[CollectionShelf alloc] init];
            [collectionImage loadFromDictionary:layoutElement];
            [myLayout addObject:collectionImage];
        }
        
        
    }
    self.imageLayout = [NSArray arrayWithArray:myLayout];
    [self addLayout];
}

- (NSString *) getStringValue: (NSDictionary *) definition fromKey: (NSString *)key
{
    if ([[definition objectForKey:key] isKindOfClass:[NSNull class]]) {
        return @" ";
    }
    NSString *value = [NSString stringWithFormat:@"%@", [definition objectForKey:key]];
    if ([value isEqualToString:@"(null)"])  {
        value =  @" ";
    }
    return value;
}

- (NSDictionary *)renderAsDictionary
{
    [self unNillify];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:name forKey:@"name"];
    [dict setObject:file_name forKey:@"file_name"];
    [dict setObject:file_name forKey:@"_id"];
    [dict setObject:price forKey:@"price"];
    [dict setObject:price2 forKey:@"price2"];
    [dict setObject:price3 forKey:@"price3"];
    [dict setObject:price4 forKey:@"price4"];
    [dict setObject:priceDescription forKey:@"priceDescription"];
    [dict setObject:price2Description forKey:@"price2Description"];
    [dict setObject:price3Description forKey:@"price3Description"];
    [dict setObject:price4Description forKey:@"price4Description"];
    [dict setObject:description forKey:@"description"];
    [dict setObject:purchased forKey:@"purchased"];
    [dict setObject:free forKey:@"free"];
    [dict setObject:self.order forKey:@"order"];    
    [dict setObject:self.type forKey:@"type"];
    [dict setObject:inAppPrice forKey:@"in_app_price"];
    [dict setObject:show forKey:@"show"];
    [dict setObject:description forKey:@"description"];
    [dict setObject:groupName forKey:@"groupName"];
    [dict setObject:isFavorite forKey:@"isFavorite"];
    [dict setObject:initialRotation forKey:@"initialRotation"];
    [dict setObject:createdBy forKey:@"createdBy"];
    [dict setObject:studioName forKey:@"studioName"];
    [dict setObject:studioUrl forKey:@"studioUrl"];
    
    NSMutableArray *myImageLayout = [NSMutableArray arrayWithCapacity:[imageLayout count]];
    NSEnumerator *e = [imageLayout objectEnumerator];
    id <CollectionElementProtocol> layoutElement;
    while (layoutElement = [e nextObject]) {
        [myImageLayout addObject:[layoutElement renderAsDictionary]];
    }

    
    [dict setObject:myImageLayout forKey:@"layout"];
    return [NSDictionary dictionaryWithDictionary:dict];
}

- (void) unNillify
{
    if (self.price == nil || [price isEqualToString:@""]) {
        self.price = @" ";
    }
    if (self.price2 == nil || [price2 isEqualToString:@""]) {
        self.price2 = @" ";
    }
    if (self.price3 == nil || [price3 isEqualToString:@""]) {
        self.price3 = @" ";
    }
    if (self.price4 == nil || [price4 isEqualToString:@""]) {
        self.price4 = @" ";
    }
    if (self.price == nil || [price isEqualToString:@""]) {
        self.price = @" ";
    }
    if (self.priceDescription == nil || [priceDescription isEqualToString:@""]) {
        self.priceDescription = @" ";
    }
    if (self.price2Description == nil || [price2Description isEqualToString:@""]) {
        self.price2Description = @" ";
    }
    if (self.price3Description == nil || [price3Description isEqualToString:@""]) {
        self.price3Description = @" ";
    }
    if (self.price4Description == nil || [price4Description isEqualToString:@""]) {
        self.price4Description = @" ";
    }
    if (self.groupName == nil || [groupName isEqualToString:@""]) {
        self.groupName = @" ";
    }
    if (self.description == nil || [description isEqualToString:@""]) {
        self.description = @" ";
    }
    if (self.show == nil) {
        self.show = @"1";
    }
    if (self.isFavorite == nil) {
        self.isFavorite = @"0";
    }
    if (self.initialRotation == nil) {
        self.initialRotation = @"0";
    }

    if (self.createdBy == nil || [createdBy isEqualToString:@""]) {
        self.createdBy = @" ";
    }
    if (self.studioName == nil || [studioName isEqualToString:@""]) {
        self.studioName = @" ";
    }
    if (self.studioUrl == nil || [studioUrl isEqualToString:@""]) {
        self.studioUrl = @" ";
    }

}

- (void) addImageGestures
{
    NSEnumerator *e = [self.imageLayout objectEnumerator];
    UIView <CollectionElementProtocol> *layoutElement;
    while (layoutElement = [e nextObject]) {
        if ([layoutElement isKindOfClass:[CollectionImage class]]) {
            [(CollectionImage *)layoutElement configureGestureRecognizers];
        }
    }
}

- (void) removeImageGestures
{
    NSEnumerator *e = [self.imageLayout objectEnumerator];
    UIView <CollectionElementProtocol> *layoutElement;
    while (layoutElement = [e nextObject]) {
        if ([layoutElement isKindOfClass:[CollectionImage class]]) {
            [(CollectionImage *)layoutElement removeGestureRecognizers];
        }
    }
}

#pragma mark - Copy
-(id)copyWithZone:(NSZone *)zone
{
    Collection *another = [[Collection alloc] init];
    
    [another loadFromDictionary:[self renderAsDictionary]];
    return another;
}

#pragma mark - To Image
- (UIImage*) renderToImage
{
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();  
    return image;
}


- (float) totalWidth;
{
    NSEnumerator *e = [self.imageLayout objectEnumerator];
    UIView <CollectionElementProtocol> *layoutElement;
    float maxX = 0.0;
    while (layoutElement = [e nextObject]) {
        if ([layoutElement class] == [CollectionImage class]) {
            if ([layoutElement.x floatValue] + [layoutElement.width floatValue] > maxX) {
                maxX = [layoutElement.x floatValue] + [layoutElement.width floatValue];
            }
        } else if ([layoutElement class] == [CollectionFramedImage class]) {
            CollectionFramedImage *framedElement = (CollectionFramedImage *) layoutElement;
            if ([framedElement.frameX floatValue] + [framedElement.frameWidth floatValue] > maxX) {
                maxX = [framedElement.frameX floatValue] + [framedElement.frameWidth floatValue];
            }
        }
    }

    return maxX;
}

- (float) totalHeight
{
    NSEnumerator *e = [self.imageLayout objectEnumerator];
    UIView <CollectionElementProtocol> *layoutElement;
    float maxY = 0.0;
    while (layoutElement = [e nextObject]) {
        if ([layoutElement class] == [CollectionImage class]) {
            if ([layoutElement.y floatValue] + [layoutElement.height floatValue] > maxY) {
                maxY = [layoutElement.y floatValue] + [layoutElement.height floatValue];
            }
        } else if ([layoutElement class] == [CollectionFramedImage class]) {
            CollectionFramedImage *framedElement = (CollectionFramedImage *) layoutElement;
            if ([framedElement.frameY floatValue] + [framedElement.frameHeight floatValue] > maxY) {
                maxY = [framedElement.frameY floatValue] + [framedElement.frameHeight floatValue];
            }
        }
        [self addSubview:layoutElement];
        [layoutElement setCollection:self];
    }
    return maxY;    
}

- (void) permanentlyDelete
{
    [Collections permanentlyDeleteCollectionWithFileName:self.file_name];
}
- (void) unhide
{
    [self setHidden:NO];
}
@end
