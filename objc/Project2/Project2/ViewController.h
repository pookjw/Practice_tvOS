//
//  ViewController.h
//  Project2
//
//  Created by Jinwoo Kim on 2/7/21.
//

#import <UIKit/UIKit.h>
#import "NSMutableArray+Shuffling.h"

@interface ViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *result;
@property NSMutableArray<NSIndexPath *> *activeCells;
@property NSMutableArray<NSIndexPath *> *flashSequence;
@property NSUInteger levelCounter;
@property NSArray<NSArray<NSNumber *> *> *levels;
@property float flashSpeed;
@end

