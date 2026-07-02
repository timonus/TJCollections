//
//  TJConcurrentMutableCollection.m
//  Close-up
//
//  Created by Tim Johnsen on 6/30/26.
//

#import "TJConcurrentMutableCollection.h"

@implementation TJConcurrentMutableCollection {
    id _collection;
    
    void (^_writeBlock)(id, id, id);
    id (^_readBlock)(id, id);
}


- (instancetype)init
{
    return [self initWithDictionary:nil queue:nil];
}

- (instancetype)initWithCollection:(id)collection writeBlock:(void (^)(id _Nonnull, id _Nonnull, id _Nonnull))writeBlock readBlock:(id  _Nonnull (^)(id _Nonnull, id _Nonnull))readBlock queue:(nullable dispatch_queue_t)queue
{
    if (self = [super init]) {
        _collection = collection;
        _writeBlock = writeBlock;
        _readBlock = readBlock;
        _queue = queue ?: dispatch_queue_create("com.tijo.TJConcurrentMutableCollection", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

#pragma mark - Convenience Initializers

- (instancetype)initWithDictionary:(NSMutableDictionary *)dictionary queue:(dispatch_queue_t)queue
{
    if (dictionary == nil) {
        dictionary = [NSMutableDictionary new];
    }
    return [self initWithCollection:dictionary
                         writeBlock:^(id key, id obj, NSMutableDictionary *dict) {
        dict[key] = obj;
    }
                          readBlock:^id(id key, NSMutableDictionary *dict) {
        return dict[key];
    }
                              queue:queue];
}

- (instancetype)initWithMapTable:(NSMapTable *)mapTable queue:(dispatch_queue_t)queue
{
    if (mapTable == nil) {
        mapTable = [NSMapTable strongToWeakObjectsMapTable];
    }
    return [self initWithCollection:mapTable
                         writeBlock:^(id key, id obj, NSMapTable *table) {
        if (obj) {
            [table setObject:obj forKey:key];
        } else {
            [table removeObjectForKey:key];
        }
    }
                          readBlock:^id(id key, NSMapTable *table) {
        return [table objectForKey:key];
    }
                              queue:queue];
}

#pragma mark - Accessors

- (id)objectForKey:(id)key
{
    __block id obj;
    dispatch_sync(_queue, ^{
        obj = _readBlock(key, _collection);
    });
    return obj;
}

- (void)objectForKey:(id)key completion:(void (^)(_Nullable id))completion
{
    dispatch_async(_queue, ^{
        id obj = _readBlock(key, _collection);
        completion(obj);
    });
}

- (void)readCollection:(void (^)(id))completion waitUntilDone:(BOOL)waitUntilDone
{
    if (waitUntilDone) {
        dispatch_sync(_queue, ^{
            completion(_collection);
        });
    } else {
        dispatch_async(_queue, ^{
            completion(_collection);
        });
    }
}

- (void)setObject:(id)obj forKey:(id)key
{
    [self setObject:obj forKey:key waitUntilDone:NO];
}

- (void)setObject:(id)obj forKey:(id)key waitUntilDone:(BOOL)waitUntilDone
{
    if (waitUntilDone) {
        dispatch_barrier_sync(_queue, ^{
            _writeBlock(key, obj, _collection);
        });
    } else {
        dispatch_barrier_async(_queue, ^{
            _writeBlock(key, obj, _collection);
        });
    }
}

- (void)removeObjectForKey:(id)key
{
    [self setObject:nil forKey:key waitUntilDone:NO];
}

- (void)removeObjectForKey:(id)key waitUntilDone:(BOOL)waitUntilDone
{
    [self setObject:nil forKey:key waitUntilDone:waitUntilDone];
}

- (void)setObject:(id)obj forKeyedSubscript:(id)key
{
    [self setObject:obj forKey:key];
}

- (id)objectForKeyedSubscript:(id)key {
    return [self objectForKey:key];
}

+ (instancetype)dictionary
{
    return [[self alloc] initWithDictionary:nil queue:nil];
}

+ (instancetype)mapTable
{
    return [[self alloc] initWithMapTable:nil queue:nil];
}

@end
