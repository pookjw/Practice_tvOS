//
//  SearchViewController.h
//  Project7
//
//  Created by Jinwoo Kim on 2/11/21.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "City.h"

@interface SearchViewController : UIViewController <UISearchResultsUpdating, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak) UITabBarController *mainTabBarController;
@property NSMutableArray<City *> *allCities;
@property NSArray<City *> *matchingCities;
@end
