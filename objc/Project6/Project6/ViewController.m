//
//  ViewController.m
//  Project6
//
//  Created by Jinwoo Kim on 2/11/21.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [UISegmentedControl appearance].tintColor = UIColor.greenColor;
    
    UITraitCollection *light = [UITraitCollection traitCollectionWithUserInterfaceStyle:UIUserInterfaceStyleLight];
    UITraitCollection *dark = [UITraitCollection traitCollectionWithUserInterfaceStyle:UIUserInterfaceStyleDark];
    
    [UISegmentedControl appearanceForTraitCollection:light].tintColor = UIColor.blueColor;
    [UISegmentedControl appearanceForTraitCollection:dark].tintColor = UIColor.redColor;
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
        self.view.backgroundColor = [UIColor colorWithRed:0.30 green:0 blue:0 alpha:1];
    } else {
        self.view.backgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:1 alpha:1];
    }
}

@end
