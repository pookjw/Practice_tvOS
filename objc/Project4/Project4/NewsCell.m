//
//  NewsCell.m
//  Project4
//
//  Created by Jinwoo Kim on 2/9/21.
//

#import "NewsCell.h"

/*
 focusedFrameGuide을 쓸 경우, UIImageView가 커졌을 때의 frame으로 Constraint를 지정한다.
 아래 코드에서 focusedFrameGuide를 지워보면, UILabel은 원래 frame으로 Constraint를 갖기 때문에 UILabel의 frame은 변하지 않는다.
 하지만 focusedFrameGuide를 쓰면, UILabel은 focused frame으로 반영되어서 height가 줄어든다.
 */

@implementation NewsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.focusedConstraint = [self.textLabel.topAnchor constraintEqualToAnchor:self.imageView.focusedFrameGuide.bottomAnchor constant:15];
}

- (void)updateConstraints {
    [super updateConstraints];
    [self.focusedConstraint setActive:self.isFocused];
    [self.unfocusedConstraint setActive:!self.isFocused];
}

- (void)didUpdateFocusInContext:(UIFocusUpdateContext *)context withAnimationCoordinator:(UIFocusAnimationCoordinator *)coordinator {
    [super didUpdateFocusInContext:context withAnimationCoordinator:coordinator];
    [self setNeedsUpdateConstraints];
    
    [coordinator addCoordinatedAnimations:^{ [self layoutIfNeeded]; }
                               completion:nil];
}

@end
