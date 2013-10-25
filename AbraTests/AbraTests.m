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
#import <Mantle/MTLJSONAdapter.h>
#import <Mantle/MTLReflection.h>
#import <objc/objc-runtime.h>

@interface AbraTests : XCTestCase


@end

@implementation AbraTests

- (void)setUp
{
    [super setUp];
    


}

- (void)tearDown
{
    [super tearDown];
}

- (void)testCache
{
    
    ABModelTest *testModel  = [[ABModelTest alloc]init];
    NSDate *now = [NSDate date];
    NSString *originalTitle = @"New title";
    NSNumber *originalUid = @(123);
    testModel.postedDate = now;
    testModel.title = originalTitle;
    testModel.uid = originalUid;
    
    NSString *testPath = @"post/users";
    NSDictionary *testParam = @{@"user": @"me", @"filter": @(1), @"all": @(YES)};
    NSString *cacheKey = [[ABCache cacheManager]generateCachekeyWithPath:testPath parameters:testParam];
    
    BOOL cached = [[ABCache cacheManager]cacheObject:testModel forKey:cacheKey];
    XCTAssertTrue(cached, @"The object was not cached correctly");
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libraryDirectory = [paths objectAtIndex:0];
    NSString *filePath = [libraryDirectory stringByAppendingPathComponent:
                          @"Caches/com.thomasricouard.abraDiskCache"];
    filePath = [filePath stringByAppendingPathComponent:cacheKey];
    XCTAssertTrue([[NSFileManager defaultManager]fileExistsAtPath:filePath],
                  @"The object was not cached correctly, the file doest not exist");
    
    ABModelTest *cachedObject = [[ABCache cacheManager]cachedObjectForKey:cacheKey];
    XCTAssertTrue(cachedObject.uid.intValue == testModel.uid.intValue,
                  @"The cached object uid does not match original object uid");
    XCTAssertTrue([cachedObject.postedDate isEqualToDate:testModel.postedDate],
                  @"The cached object postedDate does not match original object postedDate");
    XCTAssertTrue([cachedObject.title isEqualToString: testModel.title],
                  @"The cached object title does not match original object title");
    
    [[ABCache cacheManager]cleanInMemoryCache];
    [[ABCache cacheManager]cleanDiskCache];
    
    XCTAssertNil([[ABCache cacheManager]cachedObjectForKey:cacheKey
                                        onlyFromInMemoryCache:YES],
                   @"Memory cache is not cleaned properly");
    XCTAssertFalse([[NSFileManager defaultManager]fileExistsAtPath:filePath],
                  @"Disk cache is not cleaned properly");
}

- (void)testGeneratedMethods
{
    ABModelTest *testModel  = [[ABModelTest alloc]init];
    ABModelTestNested *nested = [[ABModelTestNested alloc]init];
    testModel.nestedModel = nested;
    SEL selector = MTLSelectorWithKeyPattern(@"nestedModel", "JSONTransformer");
    XCTAssertTrue([testModel respondsToSelector:selector], @"JSONTransformer method was not created");
    selector = MTLSelectorWithKeyPattern(@"url", "JSONTransformer");
    XCTAssertTrue([testModel respondsToSelector:selector], @"URLTransformer method was not created");
    XCTAssertTrue([testModel.nestedModel respondsToSelector:selector], @"URLTransformer method was not created");
    selector = MTLSelectorWithKeyPattern(@"urlBis", "JSONTransformer");
    XCTAssertTrue([testModel.nestedModel respondsToSelector:selector], @"URLTransformer method was not created");
    
}


@end
