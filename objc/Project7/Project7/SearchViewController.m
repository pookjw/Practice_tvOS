//
//  SearchViewController.m
//  Project7
//
//  Created by Jinwoo Kim on 2/11/21.
//

#import "SearchViewController.h"

@implementation SearchViewController

- (void)setup {
    self.allCities = [@[] mutableCopy];
    self.matchingCities = @[];
}

- (void)viewDidLoad {
    [self setup];
    [super viewDidLoad];
    
    NSURL *capitals = [NSBundle.mainBundle URLForResource:@"capitals" withExtension:@"json"];
    if (capitals == nil) return;
    NSData *contents = [NSData dataWithContentsOfURL:capitals];
    if (contents == nil) return;
    
    NSArray<NSDictionary *> *cities = [NSJSONSerialization JSONObjectWithData:contents options:0 error:nil];
    
    [cities enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull city, NSUInteger idx, BOOL * _Nonnull stop) {
        CLLocationCoordinate2D capitals = CLLocationCoordinate2DMake([(NSNumber *)city[@"lat"] doubleValue],
                                                                     [(NSNumber *)city[@"lon"] doubleValue]);
        
        City *newCity = [[City alloc] initWithName:(NSString *)city[@"name"]
                                           country:(NSString *)city[@"country"]
                                       coordinates:capitals];
        
        [self.allCities addObject:newCity];
    }];
    NSLog(@"%lu", cities.count);
    
//    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
//    [self.allCities sortUsingDescriptors:@[descriptor]];
    self.allCities = [[self.allCities sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        City *city1 = (City *)obj1;
        City *city2 = (City *)obj2;
        if ((city1 == nil) || (city2 == nil)) return NSOrderedSame;
        return [city1.name compare:city2.name];
    }] mutableCopy];
}

#pragma UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.matchingCities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    City *city = self.matchingCities[indexPath.row];
    cell.textLabel.text = city.formattedName;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ViewController *map = (ViewController *)[self.mainTabBarController.viewControllers firstObject];
    if (map == nil) return;
    
    City *city = self.matchingCities[indexPath.row];
    [map focusOn:city];
    
    self.mainTabBarController.selectedIndex = 0;
}

#pragma UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *search = searchController.searchBar.text;
    if (search == nil) return;
    
    if (([search isEqualToString:@""]) || (search == nil)) {
        // no text - return all cities
        self.matchingCities = self.allCities;
    } else {
        // run search
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
            City *city = (City *)evaluatedObject;
            if (city == nil) return NO;
            return [city matchesWithText:search];
        }];
        self.matchingCities = [self.allCities filteredArrayUsingPredicate:predicate];
    }
    
    [self.tableView reloadData];
}

@end
