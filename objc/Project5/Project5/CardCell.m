//
//  CardCell.m
//  Project5
//
//  Created by Jinwoo Kim on 2/11/21.
//

#import "CardCell.h"

@implementation CardCell

- (void)flipTo:(NSString *)image hideContents:(BOOL)hideContents {
    [UIView transitionWithView:self duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
        self.card.image = [UIImage imageNamed:image];
        [self.contents setHidden:hideContents];
        [self.textLabel setHidden:hideContents];
    }
                    completion:nil];
}

@end
