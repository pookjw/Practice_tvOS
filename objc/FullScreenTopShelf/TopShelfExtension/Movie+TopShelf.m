//
//  Movie+TopShelf.m
//  TopShelfExtension
//
//  Created by Jinwoo Kim on 2/14/21.
//

#import "Movie+TopShelf.h"

@implementation Movie (TopShelf)

- (TVTopShelfCarouselItem *)makeCarouselItem {
    TVTopShelfCarouselItem *item = [[TVTopShelfCarouselItem alloc] initWithIdentifier:self.identifier];
    
    item.contextTitle = NSLocalizedString(@"Featured Movie", @"The context title for a movie item.");
    item.title = self.title;
    item.summary = self.summary;
    item.genre = self.genre;
    item.duration = self.duration;
    item.creationDate = self.releaseDate;
    item.previewVideoURL = self.previewVideoURL;
    item.mediaOptions = [self makeCarouselMediaOptions];
    item.namedAttributes = [self makeCarouselNamedAttributes];
    [item setImageURL:[self imageURLWithScale:1] forTraits:TVTopShelfItemImageTraitScreenScale1x];
    [item setImageURL:[self imageURLWithScale:2] forTraits:TVTopShelfItemImageTraitScreenScale2x];
    
    item.playAction = [[TVTopShelfAction alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"full-screen-top-shelf://movie/%@/play", self.identifier]]];
    item.displayAction = [[TVTopShelfAction alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"full-screen-top-shelf://movie/%@", self.identifier]]];
    
    return item;
}

- (TVTopShelfCarouselItemMediaOptions)makeCarouselMediaOptions {
    TVTopShelfCarouselItemMediaOptions __block options = 0;
    
    if (self.mediaFormats) {
        [self.mediaFormats enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, BOOL * _Nonnull stop) {
            switch ([obj unsignedIntegerValue]) {
                case MediaFormatVideoResolutionHD:
                    options |= TVTopShelfCarouselItemVideoResolutionHD;
                    break;
                case MediaFormatVideoResolution4K:
                    options |= TVTopShelfCarouselItemVideoResolution4K;
                    break;
                case MediaFormatVideoColorSpaceHDR:
                    options |= TVTopShelfCarouselItemVideoColorSpaceHDR;
                    break;
                case MediaFormatVideoColorSpaceDolbyVision:
                    options |= TVTopShelfCarouselItemVideoColorSpaceDolbyVision;
                    break;
                case MediaFormatAudioDolbyAtmos:
                    options |= TVTopShelfCarouselItemVideoResolutionHD;
                    break;
                case MediaFormatAudioTranscriptionClosedCaptioning:
                    options |= TVTopShelfCarouselItemAudioTranscriptionClosedCaptioning;
                    break;
                case MediaFormatAudioTranscriptionSDH:
                    options |= TVTopShelfCarouselItemAudioTranscriptionSDH;
                    break;
                case MediaFormatAudioDescription:
                    options |= TVTopShelfCarouselItemAudioDescription;
                    break;
                default:
                    break;
            }
        }];
    }
    
    return options;
}

- (NSArray<TVTopShelfNamedAttribute *> *)makeCarouselNamedAttributes {
    NSMutableArray<TVTopShelfNamedAttribute *> *namedAttributes = [@[] mutableCopy];
    
    if ((self.featuredActors) && (self.featuredActors.count != 0)) {
        NSString *name = [NSString stringWithFormat:NSLocalizedString(@"Actors", @"The attribute name for the actor role."), self.featuredActors.count];
        [namedAttributes addObject:[[TVTopShelfNamedAttribute alloc] initWithName:name values:self.featuredActors]];
    }
    
    if ((self.featuredDirectors) && (self.featuredDirectors.count != 0)) {
        NSString *name = [NSString stringWithFormat:NSLocalizedString(@"Directors", @"The attribute name for the director role."), self.featuredDirectors.count];
        [namedAttributes addObject:[[TVTopShelfNamedAttribute alloc] initWithName:name values:self.featuredDirectors]];
    }
    
    return namedAttributes;
}

@end
