//
//  ReaderViewController.h
//  Project4
//
//  Created by Jinwoo Kim on 2/9/21.
//

#import <UIKit/UIKit.h>
#import "RemoteImageView.h"

@interface ReaderViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *headline;
@property (weak, nonatomic) IBOutlet RemoteImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *body;
@property NSDictionary<NSString *, id> *article;
@end
