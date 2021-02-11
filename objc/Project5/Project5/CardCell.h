//
//  CardCell.h
//  Project5
//
//  Created by Jinwoo Kim on 2/11/21.
//

#import <UIKit/UIKit.h>

@interface CardCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *card;
@property (weak, nonatomic) IBOutlet UIImageView *contents;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property NSString *word;
- (void)flipTo:(NSString *)image hideContents:(BOOL)hideContents;
@end
