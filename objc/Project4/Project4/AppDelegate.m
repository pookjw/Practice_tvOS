//
//  AppDelegate.m
//  Project4
//
//  Created by Jinwoo Kim on 2/9/21.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)setup {
    self.categories = @[@"Business", @"Culture", @"Sport", @"Technology", @"Travel"];
}

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary<UIApplicationLaunchOptionsKey,id> *)launchOptions {
    [self setup];
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 1: Grab the root view controller and safely typecast to be a tab bar controller
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    
    if (tabBarController) {
        // 1: Create an empty view controller array ready to hold the view controllers for our app
        NSMutableArray<UIViewController *> *viewControllers = [@[] mutableCopy];
        
        // 3: Loop over all the categories
        for (NSString *category in self.categories) {
            // 4: Create a new view controller for this category
            ViewController *newsController = (ViewController *)[tabBarController.storyboard instantiateViewControllerWithIdentifier:@"News"];
            if (newsController) {
                // 5: Give it the title of this category
                newsController.title = category;
                
                // 6: Append it to our array of view controllers
                [viewControllers addObject:newsController];
            }
        }
        
        [viewControllers addObject:[self createSearch:tabBarController.storyboard]];
        
        // 7: Assign the view controller array to the tab bar controller
        tabBarController.viewControllers = viewControllers;
    }
    return YES;
}

- (__kindof UIViewController *)createSearch:(UIStoryboard * _Nullable)storyboard {
    ViewController *newsController = [storyboard instantiateViewControllerWithIdentifier:@"News"];
    if (newsController == nil) [NSException raise:@"ViewControllerIsNil" format:@"ViewController is nil"];
    
    UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:newsController];
    [searchController setSearchResultsUpdater:newsController];
    
    UISearchContainerViewController *searchContainer = [[UISearchContainerViewController alloc] initWithSearchController:searchController];
    searchContainer.title = @"Search";
    
    return searchContainer;
}

@end
