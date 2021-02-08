//
//  ViewController.m
//  Project3
//
//  Created by Jinwoo Kim on 2/8/21.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.focusGuide = [UIFocusGuide new];
    [self.view addLayoutGuide:self.focusGuide];
    
    [[self.focusGuide.topAnchor constraintEqualToAnchor:self.textField.bottomAnchor] setActive:YES];
    [[self.focusGuide.widthAnchor constraintEqualToAnchor:self.view.widthAnchor] setActive:YES];
    [[self.focusGuide.heightAnchor constraintEqualToConstant:1] setActive:YES];
    
    /*
     nextButton이 Focus인 상태에서 눌러서 showAlert가 실행되고 다시 돌아올 경우, 아래 값이 YES이면 nextButton으로 Focus를 다시 둔다.
     하지만 NO이면 Focus를 다시 기본값 (preferredFocusEnvironments)으로 리셋시킨다.
     */
    self.restoresFocusAfterTransition = NO;
}

- (void)didUpdateFocusInContext:(UIFocusUpdateContext *)context withAnimationCoordinator:(UIFocusAnimationCoordinator *)coordinator {
    [super didUpdateFocusInContext:context withAnimationCoordinator:coordinator];
    
    // if the user is moving towards the text field
    if (context.nextFocusedView == self.textField) {
        // the the focus guide to redirect to the next button
        self.focusGuide.preferredFocusEnvironments = @[self.nextButton];
    } else if (context.nextFocusedView == self.nextButton) {
        // otherwise tell the focus guide to redirect to the text field
        self.focusGuide.preferredFocusEnvironments = @[self.textField];
    }
    
    if (context.nextFocusedView == self.textField) {
        // we're mocing to the text field - animate in the tip label
        [coordinator addCoordinatedAnimations:^{ self.textFieldTip.alpha = 1; }
                                   completion:nil];
    } else if (context.previouslyFocusedView == self.textField) {
        // we're moving away from the text field - animate out the tip label
        [coordinator addCoordinatedAnimations:^{ self.textFieldTip.alpha = 0; }
                                   completion:nil];
    }
}

- (NSArray<id<UIFocusEnvironment>> *)preferredFocusEnvironments {
    return @[self.textField];
}

- (IBAction)showAlert:(UIButton *)sender {
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Hello"
                                                                message:nil
                                                         preferredStyle:UIAlertControllerStyleAlert];
    [ac addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:ac animated:YES completion:nil];
}

@end
