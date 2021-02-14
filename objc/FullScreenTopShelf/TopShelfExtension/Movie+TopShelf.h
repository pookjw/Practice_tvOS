//
//  Movie+TopShelf.h
//  TopShelfExtension
//
//  Created by Jinwoo Kim on 2/14/21.
//

#import <TVServices/TVServices.h>
#import "Movie.h"

@interface Movie (TopShelf)
- (TVTopShelfCarouselItem *)makeCarouselItem;
@end
