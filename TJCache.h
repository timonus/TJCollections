//
//  TJCache.h
//  TJCollections
//
//  Created by Tim Johnsen.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TJCache<__covariant KeyType, __covariant ObjectType> : NSObject

- (instancetype)initWithThreadSafety:(BOOL)threadSafety NS_DESIGNATED_INITIALIZER;

- (nullable ObjectType)objectForKey:(KeyType)key;
- (void)setObject:(nullable ObjectType)obj forKey:(KeyType)key;

- (nullable ObjectType)objectForKeyedSubscript:(KeyType)key;
- (void)setObject:(nullable ObjectType)obj forKeyedSubscript:(KeyType)key;

@property (nonatomic) NSUInteger countLimit;

- (void)removeAllObjects;

- (void)enumerateKeys:(BOOL)keys
               values:(BOOL)values
            withBlock:(void (NS_NOESCAPE ^)(KeyType _Nullable key, ObjectType _Nullable value))block;

@end

NS_ASSUME_NONNULL_END
