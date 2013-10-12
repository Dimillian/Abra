//
//  AbraTests.m
//  AbraTests
//
//  Created by Thomas Ricouard on 04/10/13.
//  Copyright (c) 2013 Thomas Ricouard. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ABModelTest.h"
#import "Abra.h"

@interface AbraTests : XCTestCase

@end

@implementation AbraTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCacheNoAPI
{
    ABModelTest *test = [[ABModelTest alloc]init];
    NSDate *now = [NSDate date];
    NSString *originalTitle = @"New title";
    NSNumber *originalUid = @(123);
    test.postedDate = now;
    test.title = originalTitle;
    test.uid = originalUid;
    
    NSString *testPath = @"/post";
    NSDictionary *testParam = @{@"user": @"me", @"filter": @(1), @"all": @(YES)};
    NSString *cachedKey = [[ABCache cacheManager]generateCachekeyWithPath:testPath parameters:testParam];
    BOOL cached = [[ABCache cacheManager]cacheObject:test forKey:cachedKey];
    XCTAssertTrue(cached, @"The object was not cacched correctly");
    
    ABModelTest *cachedObject = [[ABCache cacheManager]cachedObjectForKey:cachedKey];
    XCTAssertTrue(cachedObject.uid.intValue == test.uid.intValue,
                  @"The cached object uid does not match original object uid");
}


@end
