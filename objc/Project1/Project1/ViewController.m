//
//  ViewController.m
//  Project1
//
//  Created by Jinwoo Kim on 2/6/21.
//

#import "ViewController.h"

@implementation ViewController

- (void)setup {
    self.categories = @[@"Airplanes", @"Beaches", @"Bridges", @"Cats", @"Cities", @"Dogs", @"Earth", @"Forests", @"Galaxies", @"Landmarks", @"Mountains", @"People", @"Roads", @"Sports", @"Sunets"];
}

- (void)viewDidLoad {
    [self setup];
    [super viewDidLoad];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.categories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = self.categories[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ImageViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"Images"];
    if (vc) {
        vc.catetory = self.categories[indexPath.row];
        [self presentViewController:vc animated:YES completion:nil];
    }
}

@end
