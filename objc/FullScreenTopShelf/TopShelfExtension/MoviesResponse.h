//
//  MoviesResponse.h
//  TopShelfExtension
//
//  Created by Jinwoo Kim on 2/14/21.
//

#import <Foundation/Foundation.h>
#import "Movie.h"

@interface MoviesResponse : NSObject
+ (MoviesResponse * _Nullable)moviesFromDic:(NSDictionary * _Nullable)dic;
@property NSArray<Movie *> * _Nonnull movies;
@end
