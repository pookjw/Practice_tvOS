//
//  AppDelegate.swift
//  Project4
//
//  Created by Jinwoo Kim on 2/8/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let categories = ["Business", "Culture", "Sport", "Technology", "Travel"]

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // 1: Grab the root view controller and safely typecast to be a tab bar controller
        if let tabBarController = window?.rootViewController as? UITabBarController {
            // 2: Create an empty view controller array ready to hold the view controllers for our app
            var viewControllers = [UIViewController]()
            
            // 3: Loop over all the categories
            for category in categories {
                // 4: Create a new view controllre for this category
                if let newsController = tabBarController.storyboard?.instantiateViewController(identifier: "News") as? ViewController {
                    // 5: Give it the title of this category
                    newsController.title = category
                    
                    // 6: Append it to our array of view controllers
                    viewControllers.append(newsController)
                }
            }
            
            viewControllers.append(createSearch(storyboard: tabBarController.storyboard))
            
            // 7: Assign the view controller array to the tab bar controller
            tabBarController.viewControllers = viewControllers
        }
        
        return true
    }
    
    func createSearch(storyboard: UIStoryboard?) -> UIViewController {
        guard let newsController = storyboard?.instantiateViewController(identifier: "News") as? ViewController else {
            fatalError("Unable to instantiate a NewsController.")
        }
        
        let searchController = UISearchController(searchResultsController: newsController)
        searchController.searchResultsUpdater = newsController
        
        let searchContainer = UISearchContainerViewController(searchController: searchController)
        searchContainer.title = "Search"
        
        return searchContainer
    }
}

