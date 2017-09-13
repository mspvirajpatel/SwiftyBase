//
//  PGServerEnvironment.h
//  PaymentsSDK
//
//  Created by Pradeep Udupi on 12/12/12.
//  Copyright (c) 2012-2013 Paytm Mobile Solutions Ltd. All rights reserved.
//  Written under contract by Robosoft Technologies Pvt Ltd.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class PGOrder;

/*!
 \enum  Server Types
 */
typedef enum
{
    eServerTypeProduction, //Indicates the production server
    eServerTypeStaging, //Indicates a staging server
    eServerTypeNone, //No selection
}ServerType;

/*  \typedef
 A block type that will return the type of the server user has selected in the dialog
 */
typedef void (^ServerSelectionHandler)(ServerType);

/*!
 This class encapsulates the details of a server environment.
 */
@interface PGServerEnvironment : NSObject


/*
 Creates the staging server environment instance
 */
+(PGServerEnvironment *)createStagingEnvironment;

/*
 Creates the production server environment instance
 */
+(PGServerEnvironment *)createProductionEnvironment;

/*
 returns the existing server environment instance
 */
+(PGServerEnvironment *)currentServerEnvironment;
/*
 Returns BOOL indicating if a server instance has been created or not
 */
+(BOOL)serverEnvironmentCreated;

/* 
 Returns The current server Domain name
 */
- (NSString *)domain;

/*
 Puts up a action alert view with buttons to select the type of server
 */
+(void)selectServerDialog:(UIView *)parentView completionHandler:(ServerSelectionHandler)handler;

@property (nonatomic, readonly, copy) NSString *clientAuthURL;
@property (nonatomic, readonly, copy) NSString *paymentGatewayURL;
@property (nonatomic, readonly, copy) NSString *statusQueryURL;
@property (nonatomic, readonly, copy) NSString *refundURL;
@property (nonatomic, readonly, copy) NSString *cancelTransactionURL;
@property (nonatomic, copy) NSString *callBackURLFormat;
@property (nonatomic, readonly, copy) NSString *checksumValidationURL;
@property (nonatomic, readonly, assign) BOOL isProduction;

+ (void)statusForOrderID:(NSString *)orderID responseHandler:(void (^)(NSDictionary *response, NSError *error))handler;

@end

    
