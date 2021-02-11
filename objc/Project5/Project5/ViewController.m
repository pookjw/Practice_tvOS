//
//  ViewController.m
//  Project5
//
//  Created by Jinwoo Kim on 2/11/21.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    GameViewController *vc = (GameViewController *)segue.destinationViewController;
    if (vc == nil) return;
    
    vc.targetLanguage = [[self.language titleForSegmentAtIndex:self.language.selectedSegmentIndex] lowercaseString];
    vc.wordType = [[self.words titleForSegmentAtIndex:self.words.selectedSegmentIndex] lowercaseString];
}

@end
