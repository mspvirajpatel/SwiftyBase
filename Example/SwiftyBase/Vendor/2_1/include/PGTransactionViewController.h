//
//  PGTransactionViewController.h
//  PaymentsSDK
//
//  Created by Pradeep Udupi on 12/12/12.
//  Copyright (c) 2012-2013 Paytm Mobile Solutions Ltd. All rights reserved.
//  Written under contract by Robosoft Technologies Pvt Ltd.
//

#import <UIKit/UIKit.h>

#import "PGMerchantConfiguration.h"
#import "PGServerEnvironment.h"

@class PGOrder;
@class PGTransactionViewController;

typedef enum {
    kCASVerificationStatusUndefined = 0,
    kCASVerificationStatusSuccess = 1,
    kCASVerificationStatusFailed = 2
}PGMerchantVerificationStatus;


#define kContactingMessage @"Contacting Server…"
#define kPleaseWaitMessage @"Please wait…"

//========================================PGTransactionDelegate==========================================================

@protocol PGTransactionDelegate <NSObject>

@required

//Called when a transaction has completed. response dictionary will be having details about Transaction.
- (void)didSucceedTransaction:(PGTransactionViewController *)controller
                    response:(NSDictionary *)response;

//Called when a transaction is failed with any reason. response dictionary will be having details about failed Transaction.
- (void)didFailTransaction:(PGTransactionViewController *)controller
                    error:(NSError *)error
                 response:(NSDictionary *)response;

//Called when a transaction is Canceled by User. response dictionary will be having details about Canceled Transaction.
- (void)didCancelTransaction:(PGTransactionViewController *)controller
                      error:(NSError *)error
                   response:(NSDictionary *)response;
@optional

//Called when CHeckSum HASH Generation completes either by PG_Server Or Merchant server.
- (void)didFinishCASTransaction:(PGTransactionViewController *)controller response:(NSDictionary *)response;
@end


//========================================PGTransactionViewController==========================================================

@interface PGTransactionViewController : UIViewController <UIWebViewDelegate, UIActionSheetDelegate>

/*
 Simpler form of transaction creation. This will take only the dynamic "PGOrder" object which can be created with currrent order details
 and will take the rest from the merchant configuration.
 */
- (id)initTransactionForOrder:(PGOrder *)order;

/*
 A delegate object should be set to handle the responses coming during the transaction
 */

@property (nonatomic, weak) id<PGTransactionDelegate> delegate;

/*
 Indicates that the transaction should happen on the staging server. If this is false then all transactions will happen on the production server.
 During development you can set this to true to ensure that the transactions are happening on the staging server and not on the actual production.
 */
@property (nonatomic, assign) BOOL useStaging;

/*
 Set this to true to enable the logging of the communication
 */
@property (nonatomic, assign) BOOL loggingEnabled;

/*
 Set a server Type on which the transaction should run
 */
@property (nonatomic, assign)   ServerType serverType;

/*
 Set the merchant configuration for the transaction
 */
@property (nonatomic, strong)   PGMerchantConfiguration *merchant;

/*
 Set to true if you want to pass all the params from checksum to the PG. Default is false which will send only the CHECKSUMHASH
 */
@property (nonatomic, assign) BOOL sendAllChecksumResponseParamsToPG;

/*
 Set the TopBar for customisation. by default navigation bar will be shown.
 It is mandatory to set cancelButton if topBar will set by Application.
 */
@property (nonatomic, strong)   UIView *topBar;

@property (nonatomic, strong)   UIButton *cancelButton;
@end

