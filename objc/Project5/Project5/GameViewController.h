//
//  GameViewController.h
//  Project5
//
//  Created by Jinwoo Kim on 2/11/21.
//

#import <UIKit/UIKit.h>
#import "CardCell.h"
#import "NSMutableArray+Category.h"

@interface GameViewController : UICollectionViewController
@property NSString * _Nonnull targetLanguage;
@property NSString * _Nonnull wordType;
@property NSArray * _Nullable words;
@property NSMutableDictionary<NSNumber *, CardCell *> * _Nonnull cells;
@property CardCell * _Nullable first;
@property CardCell * _Nullable second;
@property NSUInteger numCorrect;
@end
