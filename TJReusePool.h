//
//  TJReusePool.h
//  TJCollections
//
//  Created by Tim Johnsen.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TJReusePool<ObjectType> : NSObject

- (instancetype)initWithThreadSafety:(BOOL)threadSafety NS_DESIGNATED_INITIALIZER;

- (void)pushObject:(ObjectType)object;
- (nullable ObjectType)popObject;

@end

NS_ASSUME_NONNULL_END
