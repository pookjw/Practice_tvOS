//
//  RemoteImageView.m
//  Project4
//
//  Created by Jinwoo Kim on 2/9/21.
//

#import "RemoteImageView.h"

@implementation RemoteImageView

- (NSURL *)getCachesDirectory {
    NSArray<NSURL *> *paths = [NSFileManager.defaultManager URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask];
    return paths[0];
}

- (void)loadURL:(NSURL *)url {
    // stash the URL away for later checking
    self.url = url;
    
    // create a fate-to-save version of this URL that will be our cache filename
    // https://eddiekwon.github.io/swift/2018/09/01/Encoding101/
    NSString *savedFilename = [url.absoluteString stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.alphanumericCharacterSet];
    if (savedFilename == nil) return;
    
    // append that to the caches directory to get a complete path
    NSURL *fullPath = [[self getCachesDirectory] URLByAppendingPathComponent:savedFilename];
    
    // if the cached image exists already
    if ([NSFileManager.defaultManager fileExistsAtPath:fullPath.path]) {
        // use it and return
        self.image = [UIImage imageWithContentsOfFile:fullPath.path];
    }
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), ^{
        // download the image data
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        if (imageData == nil) return;
        
        // write it to our cache file
        [imageData writeToURL:fullPath atomically:YES];
        
        // now the image has downloaded check it's still the one we want
        if (self.url == url) {
            dispatch_async(dispatch_get_main_queue(), ^{
                // update our image
                self.image = [UIImage imageWithData:imageData];
            });
        }
    });
}

@end
