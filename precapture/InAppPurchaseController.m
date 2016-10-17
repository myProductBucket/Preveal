//
//  InAppPurchaseController.m
//  precapture
//
//  Created by Randy Crafton on 9/21/12.
//  Copyright (c) 2012 Preveal. All rights reserved.
//

#import "InAppPurchaseController.h"
#import "Collections.h"

@implementation InAppPurchaseController

static InAppPurchaseController *sharedInstance = nil;

@synthesize availableBundles, alert, purchasesAllowed, purchasesAvailable, bundleIdentifiers;



+ (id)sharedInstance
{
    if (sharedInstance == nil) {
        sharedInstance = [[InAppPurchaseController alloc] init];
        sharedInstance.purchasesAvailable = YES;
        sharedInstance.purchasesAllowed = NO;
        if ([SKPaymentQueue canMakePayments]) {
            sharedInstance.purchasesAllowed = YES;
        }
//        sharedInstance.bundleIdentifiers = [NSSet setWithObjects:kDesignAglowInspireGuideBundle, nil];
        sharedInstance.bundleIdentifiers = [NSSet setWithObjects:kDesignAglowInspireGuideBundle, kPrevealDA1Name, nil];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:sharedInstance];
    }
    return sharedInstance;
}

- (void) requestAllProductData
{
    SKProductsRequest *request= [[SKProductsRequest alloc] initWithProductIdentifiers:self.bundleIdentifiers];
    request.delegate = self;
    [request start];
}

- (SKProduct *) getProductWithIdentifier: (NSString *) productIdentifier
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"productIdentifier == %@", productIdentifier];
    NSArray *filteredProducts = [self.availableBundles filteredArrayUsingPredicate:predicate];
    SKProduct *product;
    if ([filteredProducts count] > 0) {
        product = [filteredProducts objectAtIndex:0];
    } else {
        [self requestProductData:productIdentifier];
    }
    return product;
}

- (void) requestProductData: (NSString *)bundleIdentifier
{
    SKProductsRequest *request= [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:bundleIdentifier]];
    request.delegate = self;
    [request start];
}



#pragma mark -
#pragma mark SKProductRequestDelegate methods
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    // TODO: Save to user defaults and only fetch every two weeks or when a bundleIdentifier is not in the bundle.
    self.availableBundles = response.products;
}
/*
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"Errored: %@", error);
}

- (void)requestDidFinish:(SKRequest *)request
{
    NSLog(@"finished");
}
*/


#pragma mark -
#pragma Handle the purchase 

- (void) restorePurchases
{
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (void) purchaseProduct: (SKProduct *)product
{
    NSLog(@"Purhcasing product");
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void) saveCompletedTransaction: (SKPaymentTransaction *)transaction
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSArray *purchasedBundles = [prefs arrayForKey:@"purchasedBundles"];
    [prefs setObject:[purchasedBundles arrayByAddingObject:transaction.payment.productIdentifier] forKey:@"purchasedBundles"];
    if ([prefs synchronize] == NO) {
        NSLog(@"Failed saving");
    } else {
        NSLog(@"Success saving");
    }
    NSLog(@"saveCompleted sending notification");
    [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseControllerTransactionSucceededNotification object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:transaction, @"transaction", nil]];
}

#pragma mark -
#pragma mark SKPaymentTransactionObserver methods

- (void) paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:
                NSLog(@"saveCompleted");
                [self saveCompletedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self saveCompletedTransaction:transaction.originalTransaction];
                break;
            case SKPaymentTransactionStateFailed:
                NSLog(@"saveFailed");
                NSLog(@"%@", transaction.error);
                [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseControllerTransactionFailedNotification object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:transaction, @"transaction", nil]];

                break;
            case SKPaymentTransactionStatePurchasing:
                return;
            default:
                break;
        }
        // remove the transaction from the payment queue.
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];

    }
}

@end
