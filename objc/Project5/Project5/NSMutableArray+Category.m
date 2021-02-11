//
//  NSMutableArray+Category.m
//  Project8
//
//  Created by Jinwoo Kim on 1/3/21.
//

#import "NSMutableArray+Category.h"

// https://stackoverflow.com/a/56656

@implementation NSMutableArray (Category)
- (void)shuffle {
    if (self.count <= 1) return;
    for (NSUInteger i = 0; i < self.count - 1; ++i) {
        NSInteger remainingCount = self.count - i;
        NSInteger exchangeIndex = i + arc4random_uniform((u_int32_t)remainingCount);
        [self exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
    }
}

- (_Nullable id)popLast {
    if (self.count == 0) return nil;
    id last = self[self.count - 1];
    [self removeLastObject];
    return last;
}

- (_Nonnull id)removeLast {
    if (self.count == 0) [NSException raise:@"RemoveLastError" format:@"Cannot remove the last object because array of count is zero."];
    id last = self[self.count - 1];
    [self removeLastObject];
    return last;
}

@end
