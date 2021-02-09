//
//  ViewController.h
//  Project4
//
//  Created by Jinwoo Kim on 2/9/21.
//

#import <UIKit/UIKit.h>
#import "ReaderViewController.h"
#import "NewsCell.h"
#import "Key.h"

@interface ViewController : UICollectionViewController <UISearchResultsUpdating>
@property NSArray<NSDictionary<NSString *, id> *> *articles;
@end
