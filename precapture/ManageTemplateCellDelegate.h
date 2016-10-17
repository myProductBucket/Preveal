//
//  ManageTemplateCellDelegate.h
//  precapture
//
//  Created by Randy Crafton on 4/3/15.
//  Copyright (c) 2015 Preveal. All rights reserved.
//

#ifndef precapture_ManageTemplateCellDelegate_h
#define precapture_ManageTemplateCellDelegate_h


#endif

@class Collection;

@protocol ManageTemplateCellDelegate<NSObject>
- (void) showEditViewForCollection: (Collection *) collection;
- (void) reload;
- (void) reloadData;
- (void) downloadCollection: (Collection *)collection;
- (void) showInfoForCommunityCollection:(Collection *)collection;

@end
