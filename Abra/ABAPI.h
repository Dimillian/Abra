//
//  ABAPI.h
//  Abra
//
//  Created by Thomas Ricouard on 12/10/13.
//  Copyright (c) 2013 Thomas Ricouard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@interface ABAPI : AFHTTPSessionManager

/**
 If you assign this property, the block will be called whener the network status changed, and you will be notififed with the new status
 */
@property (nonatomic, copy) void (^reachbilityStatusChangedBlock)(AFNetworkReachabilityStatus status);

/**
 You must call this methode once before any request, it will setup the ABAPI singleton for the passes URL
 @param URL the base URL of uour API
 @return the new initialized ABAPI
 */
+ (instancetype)setupWithBaseURL:(NSURL *)URL;

/**
 @return the shared ABAPI object which was setup with your base URL.
 */
+ (instancetype)manager;


@end
