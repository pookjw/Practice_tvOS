//
//  NSArray+Shuffled.m
//  Project8
//
//  Created by Jinwoo Kim on 2/13/21.
//

#import "NSArray+Shuffled.h"

@implementation NSArray (Shuffled)

- (NSArray *)shuffled {
    if (self.count <= 1) return @[];
    NSMutableArray *_mutableCopy = [self mutableCopy];
    for (NSUInteger i = 0; i < _mutableCopy.count - 1; ++i) {
        NSInteger remainingCount = self.count - i;
        NSInteger exchangeIndex = i + arc4random_uniform((u_int32_t)remainingCount);
        [_mutableCopy exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
    }
    return [_mutableCopy copy];
}

@end
