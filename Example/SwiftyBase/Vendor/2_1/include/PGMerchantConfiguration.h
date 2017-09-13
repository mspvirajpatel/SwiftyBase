//
//  PGMerchantConfiguration.h
//  PaymentsSDK
//
//  Created by Pradeep Udupi on 04/02/13.
//  Copyright (c) 2013 Robosoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PGOrder;

/*!
 The PGMerchantConfiguration instance contains the information about the merchant. It encapsulates all the configuration 
 information related to a merchant using the Paytm Payment SDK. You can get an instance to the default configuration 
 using teh defaultConfiguration factory method. You dont have to create your own instance. The default configuration will
 contain all the information specific to the merchant to whom the SDK is delivered.
 */
@interface PGMerchantConfiguration : NSObject

/*!
 This method returns the default instance of the merchant configuration. The fields are all preconfigured in this instance.
 You can access this configuration only if you need to override some values such as the SSL client certificate path 
 and the password used to protect the client certificate.
 NOTE: The SSL client certificate provided with the SDK should be included in the app. The default name will be Certificates.p12
 and it will not be password protected. If you need you can password protect the certificate before including it in the app
 and then set the password in the clientSSLCertPassword field.
 */
+(PGMerchantConfiguration *)defaultConfiguration;

/*
 Returns a dictionary representation of the merchant configuration parameters along with current Order deatails
 */
- (NSDictionary *)transactionParametersForOrder:(PGOrder *)order;

/*
 These are the configuration parameters of the merchant. The merchant app developer must configure these properties depending on their
 merchant configuration.
 */
@property (nonatomic, copy) NSString    *merchantID; //Mandatory: Merchant id provided by Paytm
@property (nonatomic, copy) NSString    *website; //Mandatory: Website value provided by Paytm
@property (nonatomic, copy) NSString    *industryID;//Mandatory: Industry type is passed here
@property (nonatomic, copy) NSString    *channelID; //Mandatory: Default value is WAP.
@property (nonatomic, copy) NSString    *theme; //Optional: Default is javas
@property (nonatomic, copy) NSString    *authMode; //Optional: Default is empty string
@property (nonatomic, copy) NSString    *paymentTypeID; //Optional: Default is empty string
@property (nonatomic, copy) NSString    *cardType; //Optional: Default is empty string
@property (nonatomic, copy) NSString    *bankCode; //Optional: Default is empty string

//SSL client certificate settings
@property (nonatomic, copy) NSString    *clientSSLCertPath; //Mandatory: Full path of the client SSL certificate. The certificate has to be placed inside the app bundle
@property (nonatomic, copy) NSString    *clientSSLCertPassword; //Optional: Password for the SSL certificate. Its strongly recommended to set the password for the certificate for additional security


@property (nonatomic, copy) NSString    *checksumGenerationURL; //Optional: If merchant generates checksum in their own server
@property (nonatomic, copy) NSString    *checksumValidationURL; //Optional: If merchant validates checksum in their own server

@end