//
//  CollectionElementProtocol.h
//  precapture
//
//  Created by Randy Crafton on 3/10/12.
//  Copyright (c) 2012 TouchSpring Design. All rights reserved.
//

#ifndef precapture_CollectionElementProtocol_h
#define precapture_CollectionElementProtocol_h

@class Collection;
@class Scalinator;

#endif
@protocol CollectionElementProtocol<NSObject>
- (NSDictionary *)renderAsDictionary;
- (void)loadFromDictionary:(NSDictionary *)definition;
- (CGRect)originalFrame;
- (NSDecimalNumber *) height;
- (NSDecimalNumber *) width;
- (NSDecimalNumber *) x;
- (NSDecimalNumber *) y;
@optional
- (void) setCollection:(Collection *)collection;;
- (void) doneResizingWithScalinator: (Scalinator *)scalinator;
- (void) addSizeLabel;
- (void)configureViewDetails;

@end