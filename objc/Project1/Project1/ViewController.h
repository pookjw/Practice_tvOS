//
//  ViewController.h
//  Project1
//
//  Created by Jinwoo Kim on 2/6/21.
//

#import <UIKit/UIKit.h>
#import "ImageViewController.h"

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property NSArray<NSString *> *categories;
@end
