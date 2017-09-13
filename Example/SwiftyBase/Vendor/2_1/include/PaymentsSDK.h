//
//  PaymentsSDK.h
//  PaymentsSDK
//
//  Created by Pradeep Udupi on 12/12/12.
//  Copyright (c) 2012-2013 Paytm Mobile Solutions Ltd. All rights reserved.
//  Written under contract by Robosoft Technologies Pvt Ltd.
//

#ifndef __PAYMENTS_SDK_H__
#define __PAYMENTS_SDK_H__

#import <Foundation/Foundation.h>

#import "PGTransactionViewController.h"
#import "PGMerchantConfiguration.h"
#import "PGServerEnvironment.h"
#import "PGOrder.h"

#define PGSDK_VERSION   @"2.1"

#ifdef DEBUG
#define DEBUGLOG    NSLog
#else
#define DEBUGLOG(x,...) //
#endif

//Reusable Class Redefines to avoid name clashes

//#define Reachability    PGReachability

#define CFSafeRelease(x) if (x != nil) CFRelease(x);

#endif