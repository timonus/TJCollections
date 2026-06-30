//
//  TJCache.h
//  TJCollections
//
//  Created by Tim Johnsen.
//

#import <Foundation/Foundation.h>
#import "TJConcurrentMutableCollection.h"

NS_ASSUME_NONNULL_BEGIN

@interface TJCache<__covariant KeyType, __covariant ObjectType> : TJConcurrentMutableCollection

- (void)setObject:(nullable ObjectType)obj forKey:(KeyType)key weakOnly:(BOOL)weakOnly;

@property (nonatomic) NSUInteger countLimit;

- (void)removeAllObjects;

- (void)enumerateKeys:(BOOL)keys
               values:(BOOL)values
            withBlock:(void (NS_NOESCAPE ^)(KeyType _Nullable key, ObjectType _Nullable value))block;

- (NSDictionary<KeyType, ObjectType> *)dictionaryRepresentation;

@end

NS_ASSUME_NONNULL_END
