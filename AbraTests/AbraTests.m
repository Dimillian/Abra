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

@property (nonatomic, strong) ABModelTest *testModel;
@property (nonatomic, strong) NSString * cacheKey;

@end

@implementation AbraTests

- (void)setUp
{
    [super setUp];
    _testModel  = [[ABModelTest alloc]init];
    NSDate *now = [NSDate date];
    NSString *originalTitle = @"New title";
    NSNumber *originalUid = @(123);
    self.testModel.postedDate = now;
    self.testModel.title = originalTitle;
    self.testModel.uid = originalUid;
    
    NSString *testPath = @"/post";
    NSDictionary *testParam = @{@"user": @"me", @"filter": @(1), @"all": @(YES)};
    _cacheKey = [[ABCache cacheManager]generateCachekeyWithPath:testPath parameters:testParam];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCacheNoAPI
{
    BOOL cached = [[ABCache cacheManager]cacheObject:self.testModel forKey:self.cacheKey];
    XCTAssertTrue(cached, @"The object was not cached correctly");
}

- (void)testDecacheNoApi
{
    ABModelTest *cachedObject = [[ABCache cacheManager]cachedObjectForKey:self.cacheKey];
    XCTAssertTrue(cachedObject.uid.intValue == self.testModel.uid.intValue,
                  @"The cached object uid does not match original object uid");
    XCTAssertTrue([cachedObject.postedDate.description isEqualToString:self.testModel.postedDate.description],
                  @"The cached object postedDate does not match original object postedDate");
    XCTAssertTrue([cachedObject.title isEqualToString: self.testModel.title],
                  @"The cached object title does not match original object title");
}

@end
