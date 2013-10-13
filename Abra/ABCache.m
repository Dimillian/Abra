//
//  ABCache.m
//  Abra
//
//  Created by Thomas Ricouard on 12/10/13.
//  Copyright (c) 2013 Thomas Ricouard. All rights reserved.
//

#import "ABCache.h"

NSString * const kInMemoryCacheName = @"com.thomasricouard.abraCache";
NSString * const kDiskCachePath = @"com.thomasricouard.abraDiskCache";

@interface ABCache ()

@property (nonatomic, strong) NSCache *inMemoryCache;
@property (nonatomic, strong, readonly) NSString *filePath;

- (BOOL)archiveObject:(id)object withFilename:(NSString *)filename;
- (id)unarchiveObjectWithFilename:(NSString *)filename;
- (BOOL)existAtFilepath:(NSString *)filename;
- (void)createCacheFolderIfNotExist;

@end

@implementation ABCache


#pragma mark - Setup


+ (instancetype)cacheManager
{
    static ABCache *cacheInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cacheInstance = [[ABCache alloc]init];
    });
    return cacheInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        _inMemoryCache = [[NSCache alloc]init];
        [self.inMemoryCache setName:kInMemoryCacheName];
        [self createCacheFolderIfNotExist];
    }
    return self;
}


#pragma mark - Exposed methods


- (NSString *)generateCachekeyWithPath:(NSString *)path parameters:(NSDictionary *)parameters
{
    __block NSString *key = [path stringByReplacingOccurrencesOfString:@"/" withString:@"#"];
    
    if (parameters) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul), ^{
            [parameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                key = [key stringByAppendingString:[NSString stringWithFormat:@"#%@#%@", key, obj]];
            }];
        });   
    }
    return key;
}

- (BOOL)cacheObject:(id)object forKey:(NSString *)key
{
    return [self cacheObject:object forKey:key onlyToInMemoryCache:NO];
}

- (BOOL)cacheObject:(id)object forKey:(NSString *)key onlyToInMemoryCache:(BOOL)inMemory
{
    [self.inMemoryCache setObject:object forKey:key];
    if (!inMemory) {
        return [self archiveObject:object withFilename:key];
    }
    return YES;
}

- (id)cachedObjectForKey:(NSString *)key
{
    return [self cachedObjectForKey:key onlyFromInMemoryCache:NO];
}

- (id)cachedObjectForKey:(NSString *)key onlyFromInMemoryCache:(BOOL)inMemory
{
    id object = [self.inMemoryCache objectForKey:key];
    if (!object && !inMemory) {
        object = [self unarchiveObjectWithFilename:key];
    }
    if (object) {
        [self.inMemoryCache setObject:object forKey:key];
    }
    return object;
}

- (void)cleanDiskCache
{
    NSError *error = nil;
    for (NSString *file in [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[ABCache cacheManager].filePath
                                                                               error:&error]) {
        [[NSFileManager defaultManager] removeItemAtPath:[[ABCache cacheManager].filePath
                                                          stringByAppendingPathComponent:file]
                                                   error:&error];
    }
}

- (void)cleanInMemoryCache
{
    if (self.inMemoryCache) {
        [self.inMemoryCache removeAllObjects];
        _inMemoryCache = [[NSCache alloc]init];
    }
}


+ (unsigned long long)diskCacheSize
{
    NSDictionary *fileAttributes = [[NSFileManager defaultManager]attributesOfItemAtPath:[ABCache cacheManager].filePath
                                                                                   error:nil];
    return [fileAttributes fileSize];
}


#pragma mark - Private methods


- (BOOL)archiveObject:(id)object withFilename:(NSString *)filename
{
    NSString *fullPath = [self.filePath stringByAppendingPathComponent:filename];
    return [NSKeyedArchiver archiveRootObject:object toFile:fullPath];
}

- (id)unarchiveObjectWithFilename:(NSString *)filename
{
    NSString *filepath = [self.filePath stringByAppendingString:filename];
    if ([self existAtFilepath:filepath]) {
        return [NSKeyedUnarchiver unarchiveObjectWithFile:filepath];
    }
    return nil;
}

- (BOOL)existAtFilepath:(NSString *)filename
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:filename];
}

- (NSString *)filePath
{
    static NSString *filePath = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString *libraryDirectory = [paths objectAtIndex:0];
        filePath = [libraryDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"Caches/%@", kDiskCachePath]];
    });
    return filePath;
    
}

- (void)createCacheFolderIfNotExist
{
    if (![self existAtFilepath:[self filePath]]) {
        NSError *fileError;
        [[NSFileManager defaultManager]createDirectoryAtPath:[self filePath]
                                 withIntermediateDirectories:NO
                                                  attributes:nil
                                                       error:&fileError];
    }
}

@end
