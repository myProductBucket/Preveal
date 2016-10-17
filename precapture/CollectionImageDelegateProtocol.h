//
//  CollectionImageDelegateProtocol.h
//  precapture
//
//  Created by Randy Crafton on 3/13/12.
//  Copyright (c) 2012 TouchSpring Design. All rights reserved.
//
@class CollectionImage;

@protocol CollectionImageDelegateProtocol<NSObject>
- (void)didTouchCollectionImage:(CollectionImage *)collectionImage;
- (IBAction)doneEditingCollectionImage:(id)sender;
@end