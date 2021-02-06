//
//  ImageViewController.h
//  Project1
//
//  Created by Jinwoo Kim on 2/6/21.
//

#import <UIKit/UIKit.h>
#import "Key.h"

@interface ImageViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UILabel *creditLabel;
@property NSString *catetory;
@property NSArray<UIImageView *> *imageViews;
@property NSArray<NSDictionary *> *images;
@property NSUInteger imageCounter;
@end
