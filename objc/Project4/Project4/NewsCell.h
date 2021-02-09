//
//  NewsCell.h
//  Project4
//
//  Created by Jinwoo Kim on 2/9/21.
//

#import <UIKit/UIKit.h>
#import "RemoteImageView.h"

@interface NewsCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet RemoteImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

/*
 weak로 붙잡고 있을 경우, isActive가 false가 되었을 때 removeConstraint(_:)가 불린다. 따라서 reference count가 줄어 들어서, release가 되어 버린다.
 https://developer.apple.com/documentation/uikit/nslayoutconstraint/1527000-isactive
 */
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *unfocusedConstraint;
@property NSLayoutConstraint *focusedConstraint;
@end
