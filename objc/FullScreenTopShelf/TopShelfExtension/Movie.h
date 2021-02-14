//
//  Movie.h
//  TopShelfExtension
//
//  Created by Jinwoo Kim on 2/14/21.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, MediaFormat) {
    MediaFormatVideoResolutionHD,
    MediaFormatVideoResolution4K,
    MediaFormatVideoColorSpaceHDR,
    MediaFormatVideoColorSpaceDolbyVision,
    MediaFormatAudioDolbyAtmos ,
    MediaFormatAudioTranscriptionClosedCaptioning,
    MediaFormatAudioTranscriptionSDH,
    MediaFormatAudioDescription
};

@interface Movie : NSObject
@property NSString * _Nonnull identifier;
@property NSString * _Nonnull title;
@property NSDate * _Nonnull releaseDate;
@property NSString * _Nonnull summary;
@property NSString * _Nonnull genre;
@property NSTimeInterval duration;
@property NSSet<NSNumber *> * _Nullable mediaFormats;
@property NSArray<NSString *> * _Nullable featuredActors;
@property NSArray<NSString *> * _Nullable featuredDirectors;
@property NSString * _Nonnull imageName;
@property NSString * _Nonnull previewVideoName;
@property (nonatomic) NSURL * _Nullable previewVideoURL;

+ (Movie * _Nullable)movieFromDictionary:(NSDictionary * _Nullable)dic;
- (NSURL * _Nullable)imageURLWithScale:(NSUInteger)scale;
@end
