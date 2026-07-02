//
//  TJConcurrentMutableCollection.h
//  Close-up
//
//  Created by Tim Johnsen on 6/30/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Generic implementation of the "many readers one writer" pattern described in https://www.mikeash.com/pyblog/friday-qa-2011-10-14-whats-new-in-gcd.html that wraps a collection of your choice
@interface TJConcurrentMutableCollection<__covariant KeyType, __covariant ObjectType, __covariant CollectionType> : NSObject

- (instancetype)initWithCollection:(CollectionType)collection
                        writeBlock:(void (^)(KeyType, _Nullable ObjectType, CollectionType))writeBlock
                         readBlock:(nullable ObjectType (^)(KeyType, CollectionType))readBlock
                             queue:(nullable dispatch_queue_t)queue NS_DESIGNATED_INITIALIZER;

@property (nonatomic, readonly) dispatch_queue_t queue;

- (nullable ObjectType)objectForKey:(KeyType)key __attribute__((objc_direct));
/// NOTE: `completion` is invoked on instance's `queue`.
- (void)objectForKey:(KeyType)key completion:(void (^)(_Nullable ObjectType))completion __attribute__((objc_direct));
- (void)setObject:(nullable ObjectType)obj forKey:(KeyType)key __attribute__((objc_direct));
- (void)setObject:(nullable ObjectType)obj forKey:(KeyType)key waitUntilDone:(BOOL)waitUntilDone __attribute__((objc_direct));
- (void)removeObjectForKey:(KeyType)key __attribute__((objc_direct));
- (void)removeObjectForKey:(KeyType)key waitUntilDone:(BOOL)waitUntilDone __attribute__((objc_direct));

- (nullable ObjectType)objectForKeyedSubscript:(KeyType)key __attribute__((objc_direct));
- (void)setObject:(nullable ObjectType)obj forKeyedSubscript:(KeyType)key __attribute__((objc_direct));

/// NOTE: Intended only for use for batch reads. Writing in this block could cause a crash.
- (void)readCollection:(void (^)(CollectionType))completion waitUntilDone:(BOOL)waitUntilDone __attribute__((objc_direct));

// Convenience initializers
- (instancetype)initWithDictionary:(nullable NSMutableDictionary<KeyType, ObjectType> *)dictionary
                             queue:(nullable dispatch_queue_t)queue;
+ (instancetype)dictionary;

- (instancetype)initWithMapTable:(nullable NSMapTable<KeyType, ObjectType> *)mapTable
                           queue:(nullable dispatch_queue_t)queue;
+ (instancetype)mapTable;

@end

NS_ASSUME_NONNULL_END
