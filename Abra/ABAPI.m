//
//  ABAPI.m
//  Abra
//
//  Created by Thomas Ricouard on 12/10/13.
//  Copyright (c) 2013 Thomas Ricouard. All rights reserved.
//

#import "ABAPI.h"

static ABAPI *sharedInstance = nil;

@implementation ABAPI


#pragma mark - Setup


- (instancetype)initWithBaseURL:(NSURL *)url sessionConfiguration:(NSURLSessionConfiguration *)configuration
{
    self = [super initWithBaseURL:url sessionConfiguration:configuration];
    if (self) {
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(onReachabilityChangedNotification:)
                                                    name:AFNetworkingReachabilityDidChangeNotification
                                                  object:nil];
    }
    return self;
}

+ (instancetype)setupWithBaseURL:(NSURL *)URL
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ABAPI alloc]initWithBaseURL:URL
                                  sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    });
    return sharedInstance;
}

+ (instancetype)manager
{
    NSAssert(sharedInstance != nil, @"You must first call setupWithBaseURL: before atempting to access the sharedClient");
    return sharedInstance;
}


#pragma mark - Reachability


- (void)onReachabilityChangedNotification:(NSNotification *)notification
{
    if ([notification.name isEqualToString:AFNetworkingReachabilityDidChangeNotification]) {
        if (self.reachbilityStatusChangedBlock) {
            AFNetworkReachabilityStatus status =
            [notification.userInfo[AFNetworkingReachabilityNotificationStatusItem] integerValue];
            self.reachbilityStatusChangedBlock(status);
        }
    }
}

@end
