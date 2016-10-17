//
//  CollectionDelegateProtocol.h
//  precapture
//
//  Created by Randy Crafton on 3/14/12.
//  Copyright (c) 2012 TouchSpring Design. All rights reserved.
//

@class Collection;

@protocol CollectionDelegate<NSObject>
- (void) collectionDraggingForCollection:(Collection *)draggedCollection byGestureRecognizer: (UIGestureRecognizer *)recognizer;
@end