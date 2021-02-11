//
//  AppDelegate.swift
//  Project7
//
//  Created by Jinwoo Kim on 2/11/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if let tabBarController = window?.rootViewController as? UITabBarController {
            tabBarController.viewControllers?.append(createSearch(in: tabBarController))
        }
        
        return true
    }

    func createSearch(in tabBarController: UITabBarController) -> UIViewController {
        guard let searchViewController = tabBarController.storyboard?.instantiateViewController(identifier: "Search") as? SearchViewController else {
            fatalError("Unable to instantiate a SearchViewController.")
        }
        
        searchViewController.mainTabBarController = tabBarController
        
        let searchController = UISearchController(searchResultsController: searchViewController)
        searchController.searchResultsUpdater = searchViewController
        
        let searchContainer = UISearchContainerViewController(searchController: searchController)
        searchContainer.title = "Search"
        return searchContainer
    }
}

