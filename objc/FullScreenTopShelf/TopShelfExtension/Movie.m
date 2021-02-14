//
//  Movie.m
//  TopShelfExtension
//
//  Created by Jinwoo Kim on 2/14/21.
//

#import "Movie.h"

@implementation Movie

+ (Movie * _Nullable)movieFromDictionary:(NSDictionary * _Nullable)dic {
    Movie *new = [Movie new];
    if (new) {
        new.identifier = dic[@"id"];
        new.title = dic[@"title"];
        new.releaseDate = [NSDate dateWithTimeIntervalSince1970:[(NSNumber *)dic[@"released_at"] doubleValue]];
        new.summary = dic[@"summary"];
        new.genre = dic[@"genre"];
        new.duration = [(NSNumber *)dic[@"duration"] doubleValue];
        new.mediaFormats = [NSSet setWithArray:[Movie parseMediaFormats:(NSArray<NSString *> *)dic[@"media_formats"]]];
        new.featuredActors = dic[@"featured_actors"];
        new.featuredDirectors = dic[@"featured_directors"];
        new.imageName = dic[@"image_name"];
        new.previewVideoName = dic[@"preview_video_name"];
    }
    return new;
}

+ (NSArray<NSNumber *> *)parseMediaFormats:(NSArray<NSString *> *)input {
    NSMutableArray *output = [@[] mutableCopy];
    
    [input enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:@"hd"]) {
            [output addObject:[NSNumber numberWithUnsignedInteger:MediaFormatVideoResolutionHD]];
        } else if ([obj isEqualToString:@"4k"]) {
            [output addObject:[NSNumber numberWithUnsignedInteger:MediaFormatVideoResolution4K]];
        } else if ([obj isEqualToString:@"hdr"]) {
            [output addObject:[NSNumber numberWithUnsignedInteger:MediaFormatVideoColorSpaceHDR]];
        } else if ([obj isEqualToString:@"dolby-vision"]) {
            [output addObject:[NSNumber numberWithUnsignedInteger:MediaFormatVideoColorSpaceDolbyVision]];
        } else if ([obj isEqualToString:@"dolby-atmos"]) {
            [output addObject:[NSNumber numberWithUnsignedInteger:MediaFormatAudioDolbyAtmos]];
        } else if ([obj isEqualToString:@"cc"]) {
            [output addObject:[NSNumber numberWithUnsignedInteger:MediaFormatAudioTranscriptionClosedCaptioning]];
        } else if ([obj isEqualToString:@"sdh"]) {
            [output addObject:[NSNumber numberWithUnsignedInteger:MediaFormatAudioTranscriptionSDH]];
        } else if ([obj isEqualToString:@"ad"]) {
            [output addObject:[NSNumber numberWithUnsignedInteger:MediaFormatAudioDescription]];
        }
    }];
    
    return output;
}

- (NSURL * _Nullable)previewVideoURL {
    return [NSBundle.mainBundle URLForResource:self.previewVideoName withExtension:@"mp4"];
}

- (NSURL * _Nullable)imageURLWithScale:(NSUInteger)scale {
    return [NSBundle.mainBundle URLForResource:self.imageName withExtension:@"jpg"];
}

@end
