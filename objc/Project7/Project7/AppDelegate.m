//
//  AppDelegate.m
//  Project7
//
//  Created by Jinwoo Kim on 2/11/21.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    if (tabBarController) {
        NSMutableArray *viewControllers = [tabBarController.viewControllers mutableCopy];
        [viewControllers addObject:[self createSearchIn:tabBarController]];
        tabBarController.viewControllers = viewControllers;
    }
    
    return YES;
}

- (__kindof UIViewController *)createSearchIn:(UITabBarController *)tabBarController {
    SearchViewController *searchViewController = [tabBarController.storyboard instantiateViewControllerWithIdentifier:@"Search"];
    if (searchViewController == nil) [NSException raise:@"SearchViewControllerIsNil" format:@"Unable to instantiate a SearchViewController"];
    
    searchViewController.mainTabBarController = tabBarController;
    
    UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:searchViewController];
    searchController.searchResultsUpdater = searchViewController;
    
    UISearchContainerViewController *searchContainer = [[UISearchContainerViewController alloc] initWithSearchController:searchController];
    searchContainer.title = @"Search";
    return searchContainer;
}

@end
