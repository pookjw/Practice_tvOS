//
//  ContentProvider.m
//  TopShelfExtension
//
//  Created by Jinwoo Kim on 2/14/21.
//

#import "ContentProvider.h"
#import "MoviesResponse.h"
#import "Movie+TopShelf.h"

@implementation ContentProvider

- (void)loadTopShelfContentWithCompletionHandler:(void (^) (id<TVTopShelfContent> content))completionHandler {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url = [NSBundle.mainBundle URLForResource:@"movies" withExtension:@"json"];
        if (url == nil) [NSException raise:@"URLIsNil" format:@"Unable to load movies.json file."];
        
        NSError *dataError = nil;
        NSData *data = [NSData dataWithContentsOfURL:url options:NSDataReadingMappedAlways | NSDataReadingUncached error:&dataError];
        if (dataError) {
            NSLog(@"%@", dataError.localizedDescription);
            completionHandler(nil);
            return;
        }
        
        NSError *decodeError = nil;
        NSDictionary *decoded = [NSJSONSerialization JSONObjectWithData:data options:0 error:&decodeError];
        if (decodeError) {
            NSLog(@"%@", decodeError.localizedDescription);
            completionHandler(nil);
            return;
        }
        
        MoviesResponse *response = [MoviesResponse moviesFromDic:decoded];
        NSMutableArray<TVTopShelfCarouselItem *> *items = [@[] mutableCopy];
        [response.movies enumerateObjectsUsingBlock:^(Movie * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [items addObject:[obj makeCarouselItem]];
        }];
        TVTopShelfCarouselContent *content = [[TVTopShelfCarouselContent alloc] initWithStyle:TVTopShelfCarouselContentStyleDetails items:[items copy]];
        
        completionHandler(content);
    });
}

@end
