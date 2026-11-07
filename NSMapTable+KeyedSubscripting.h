//
//  NSMapTable+KeyedSubscripting.h
//  Close-up
//
//  Created by Tim Johnsen on 11/7/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMapTable<KeyType, ObjectType> (KeyedSubscripting)

- (nullable ObjectType)objectForKeyedSubscript:(KeyType)key;
- (void)setObject:(nullable ObjectType)obj forKeyedSubscript:(KeyType <NSCopying>)key;

@end

NS_ASSUME_NONNULL_END
