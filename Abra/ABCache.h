//
//  ABCache.h
//  Abra
//
//  Created by Thomas Ricouard on 12/10/13.
//  Copyright (c) 2013 Thomas Ricouard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ABCache : NSObject

/**
 Creates and returns an `ABCache` object.
 */
+ (instancetype)cacheManager;

/**
 REST friendly method to generate a cache key from a path + parameters combinaison.
 The final key will look like this path#key1#value1#key2#value2... It should be used when you want to manually cache 
 and object from an API request
 @param path Your API path without the base url, (the same you use to run queries from ABModel). Requiered
 @param parameters Your API parameters (the same you use to run queries from ABModel). Optional
 @return a key wich represent your path and parameters and which should be safe to use as a cache key
 */
- (NSString *)generateCachekeyWithPath:(NSString *)path parameters:(NSDictionary *)parameters;

/**
 Cache the passed object to the in memory cache and to the disk cache, update any previous occurence.
 @param object The object you want to cache. The object must be a subclass of ABModel or conform to <NSCoding>.
 @param key The key to cache the object (will be the filename too) should be generated from the generateCacheKey method
 @return YES if the object was cached with success
 */
- (BOOL)cacheObject:(id)object forKey:(NSString *)key;

/**
 Return the cached object with the associated key (the key should be generated from generateCacheKey method)
 The object will first be checked and returned from the in memory cache, if it does not exist here, it will be return from disk cache.
 @return An object from in memory cache or disk cache, or nil if the key is not associated with any cached objects.
 */
- (id)cachedObjectForKey:(NSString *)key;

/**
 Cache the passed object to the in memory cache and eventually to disk cache update any previous occurence.
 @param object The object you want to cache. The object must be a subclass of ABModel or conform to <NSCoding>.
 @param key The key to cache the object (will be the filename too) should be generated from the generateCacheKey method
 @param inMemory Set to YES if you don't want to persist the passed object to disk
 @return YES if the object was cached with success
 */
- (BOOL)cacheObject:(id)object forKey:(NSString *)key onlyToInMemoryCache:(BOOL)inMemory;

/**
 Return the cached object with the associated key (the key should be generated from generateCacheKey method)
 The object will first be checked and returned from the in memory cache, if it does not exist here, it will be return from disk.
 @param inMemory set to YES if you don't want to check diskCache
 @return An object from in memory cache or disk cache, or nil if the key is not associated with any cached objects.
 */
- (id)cachedObjectForKey:(NSString *)key onlyFromInMemoryCache:(BOOL)inMemory;

/**
 Remove every object in the inMemoryCache
 */
- (void)cleanInMemoryCache;

/**
 Remove every object cached on the disk
 */
- (void)cleanDiskCache;

/**
 @return the disk cache folder size
 */
+ (unsigned long long)diskCacheSize;



@end
