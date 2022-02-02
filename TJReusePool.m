//
//  TJReusePool.h
//  TJCollections
//
//  Created by Tim Johnsen.
//

#import "TJReusePool.h"

__attribute__((objc_direct_members))
@interface TJReusePool () <NSCacheDelegate>

@end

__attribute__((objc_direct_members))
@implementation TJReusePool {
    dispatch_queue_t _queue;
    
    NSCache *_cache;
    NSHashTable *_objects;
}

- (instancetype)init
{
    return [self initWithThreadSafety:YES];
}

- (instancetype)initWithThreadSafety:(BOOL)threadSafety
{
    if (self = [super init]) {
        if (threadSafety) {
            _queue = dispatch_queue_create(nil, DISPATCH_QUEUE_SERIAL);
        }
        _cache = [NSCache new];
        _cache.delegate = self;
        _objects = [NSHashTable weakObjectsHashTable];
    }
    return self;
}

- (void)pushObject:(id)object
{
    [_cache setObject:object forKey:object];
    dispatch_block_t block = ^{
        [self->_objects addObject:object];
    };
    if (_queue) {
        dispatch_async(_queue, block);
    } else {
        block();
    }
}

- (id)popObject
{
    __block id object;
    dispatch_block_t block = ^{
        object = [self->_objects anyObject];
    };
    if (_queue) {
        dispatch_sync(_queue, block);
    } else {
        block();
    }
    [_cache removeObjectForKey:object]; // This ends up invoking -cache:willEvictObject:
    return object;
}

- (void)cache:(NSCache *)cache willEvictObject:(id)obj
{
    dispatch_block_t block = ^{
        [self->_objects removeObject:obj];
    };
    if (_queue) {
        dispatch_sync(_queue, block);
    } else {
        block();
    }
}

@end
