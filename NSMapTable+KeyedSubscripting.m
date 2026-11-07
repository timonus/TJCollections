//
//  NSMapTable+KeyedSubscripting.m
//  Close-up
//
//  Created by Tim Johnsen on 11/7/26.
//

#import "NSMapTable+KeyedSubscripting.h"

@implementation NSMapTable (KeyedSubscripting)

- (nullable id)objectForKeyedSubscript:(id)key
{
    return [self objectForKey:key];
}

- (void)setObject:(nullable id)obj forKeyedSubscript:(id<NSCopying>)key
{
    if (obj) {
        [self setObject:obj forKey:key];
    } else {
        [self removeObjectForKey:key];
    }
}

@end
