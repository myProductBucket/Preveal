//
//  InAppPurchaseController.h
//  precapture
//
//  Created by Randy Crafton on 9/21/12.
//  Copyright (c) 2012 Preveal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>


#define kInAppPurchaseControllerTransactionSucceededNotification @"kInAppPurchaseControllerTransactionSucceededNotification"
#define kInAppPurchaseControllerTransactionFailedNotification @"kInAppPurchaseControllerTransactionFailedNotification"

@interface InAppPurchaseController : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver, UIAlertViewDelegate> {
    NSSet *bundleIdentifiers;
    NSArray *availableBundles;
    UIAlertView *alert;
    BOOL purchasesAllowed;
    BOOL purchasesAvailable;
}

@property (nonatomic, retain) NSSet *bundleIdentifiers;
@property (nonatomic, retain) NSArray *availableBundles;
@property (nonatomic, retain) UIAlertView *alert;
@property (nonatomic, assign) BOOL purchasesAllowed;
@property (nonatomic, assign) BOOL purchasesAvailable;

+ (id)sharedInstance;
- (void) requestAllProductData;
- (SKProduct *) getProductWithIdentifier: (NSString *) productIdentifier;
- (void) purchaseProduct: (SKProduct *)product;
- (void) saveCompletedTransaction: (SKPaymentTransaction *)transaction;
- (void) restorePurchases;

@end
