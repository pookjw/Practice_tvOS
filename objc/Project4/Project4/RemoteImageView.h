//
//  RemoteImageView.h
//  Project4
//
//  Created by Jinwoo Kim on 2/9/21.
//

#import <UIKit/UIKit.h>

@interface RemoteImageView : UIImageView
@property NSURL *url;
- (void)loadURL:(NSURL *)url;
@end
