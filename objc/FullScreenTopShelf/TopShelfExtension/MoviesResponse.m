//
//  MoviesResponse.m
//  TopShelfExtension
//
//  Created by Jinwoo Kim on 2/14/21.
//

#import "MoviesResponse.h"

@implementation MoviesResponse

+ (MoviesResponse * _Nullable)moviesFromDic:(NSDictionary * _Nullable)dic {
    MoviesResponse *new = [MoviesResponse new];
    
    if (new) {
        NSArray<NSDictionary *> *arr = dic[@"movies"];
        NSMutableArray<Movie *> *result = [@[] mutableCopy];
        [arr enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [result addObject:[Movie movieFromDictionary:obj]];
        }];
        new.movies = [result copy];
    }
    
    return new;
}

@end
