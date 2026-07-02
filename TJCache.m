//
//  TJCache.m
//  TJCollections
//
//  Created by Tim Johnsen.
//

#import "TJCache.h"

__attribute__((objc_direct_members))
@implementation TJCache {
    NSCache *_cache;
    NSMapTable *_mapTable;
}

- (instancetype)init {
    return [super initWithCollection:self
                          writeBlock:^(id key, id obj, TJCache *collection) {
        [collection->_cache setObject:obj forKey:key];
        [collection->_mapTable setObject:obj forKey:key];
    } readBlock:^id _Nonnull(id _Nonnull key, TJCache *collection) {
        return collection->_cache;
    } queue:nil];
}

- (void)setCountLimit:(NSUInteger)countLimit
{
    _cache.countLimit = countLimit;
}

- (NSUInteger)countLimit
{
    return _cache.countLimit;
}

- (void)removeAllObjects
{
    [_cache removeAllObjects];
}

- (void)enumerateKeys:(const BOOL)keys
               values:(const BOOL)values
            withBlock:(void (NS_NOESCAPE ^)(id key, id value))block
{
    [self readCollection:^(TJCache *cache) {
        if (keys) {
            for (id key in cache->_mapTable) {
                block(key, keys ? [cache->_mapTable objectForKey:key] : nil);
            }
        } else if (values) {
            for (id value in [cache->_mapTable objectEnumerator]) {
                block(nil, value);
            }
        } else {
            NSAssert(NO, @"One of keys or values should be true");
        }
    } waitUntilDone:YES];
}

- (NSDictionary *)dictionaryRepresentation
{
    __block NSDictionary *dictionaryRepresentation;
    [self readCollection:^(TJCache *cache) {
        dictionaryRepresentation = [cache->_mapTable dictionaryRepresentation];
    } waitUntilDone:YES];
    return dictionaryRepresentation;
}

- (void)setObject:(nullable id)obj forKey:(nonnull id)key weakOnly:(BOOL)weakOnly {
    if (weakOnly) {
        dispatch_barrier_async(self.queue, ^{
            [self->_mapTable setObject:obj forKey:key];
        });
    } else {
        [self setObject:obj forKey:key];
    }
}

@end
