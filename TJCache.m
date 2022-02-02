//
//  TJCache.m
//  TJCollections
//
//  Created by Tim Johnsen.
//

#import "TJCache.h"

__attribute__((objc_direct_members))
@implementation TJCache {
    dispatch_queue_t _queue;
    
    NSCache *_cache;
    NSMapTable *_mapTable;
}

- (instancetype)init
{
    return [self initWithThreadSafety:YES];
}

- (instancetype)initWithThreadSafety:(BOOL)threadSafety
{
    if (self = [super init]) {
        if (threadSafety) {
            _queue = dispatch_queue_create(nil, DISPATCH_QUEUE_CONCURRENT);
        }
        _cache = [NSCache new];
        _mapTable = [NSMapTable strongToWeakObjectsMapTable];
    }
    return self;
}

- (id)objectForKey:(id)key
{
    __block id object;
    dispatch_block_t block = ^{
        object = [self->_mapTable objectForKey:key];
    };
    if (_queue) {
        dispatch_sync(_queue, block);
    } else {
        block();
    }
    return object;
}

- (id)objectForKeyedSubscript:(id)key
{
    return [self objectForKey:key];
}

- (void)setObject:(id)obj forKey:(id)key
{
    [_cache setObject:obj forKey:key];
    dispatch_block_t block = ^{
        [self->_mapTable setObject:obj forKey:key];
    };
    if (_queue) {
        dispatch_barrier_async(_queue, block);
    } else {
        block();
    }
}

- (void)setObject:(id)obj forKeyedSubscript:(id)key
{
    [self setObject:obj forKey:key];
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
    dispatch_block_t enumerateBlock = ^{
        if (keys) {
            for (id key in self->_mapTable) {
                block(key, keys ? [self->_mapTable objectForKey:key] : nil);
            }
        } else if (values) {
            for (id value in [self->_mapTable objectEnumerator]) {
                block(nil, value);
            }
        } else {
            NSAssert(NO, @"One of keys or values should be true");
        }
    };
    if (_queue) {
        dispatch_sync(_queue, enumerateBlock);
    } else {
        enumerateBlock();
    }
}

@end
