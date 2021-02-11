//
//  SearchViewController.swift
//  Project7
//
//  Created by Jinwoo Kim on 2/11/21.
//

import UIKit
import CoreLocation

class SearchViewController: UIViewController, UISearchResultsUpdating, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    weak var mainTabBarController: UITabBarController!
    var allCities = [City]()
    var matchingCities = [City]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let capitals = Bundle.main.url(forResource: "capitals", withExtension: "json") else { return }
        guard let contents = try? Data(contentsOf: capitals) else { return }
        
        let cities = JSON(contents).arrayValue
        
        for city in cities {
            let coords = CLLocationCoordinate2D(latitude: city["lat"].doubleValue, longitude: city["lon"].doubleValue)
            let newCity = City(name: city["name"].stringValue, country: city["country"].stringValue, coordinates: coords)
            allCities.append(newCity)
        }
        
        allCities.sort()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let city = matchingCities[indexPath.row]
        cell.textLabel?.text = city.formattedName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let map = mainTabBarController.viewControllers?.first as? ViewController else {
            return
        }
        
        let city = matchingCities[indexPath.row]
        map.focus(on: city)
        
        mainTabBarController.selectedIndex = 0;
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let search = searchController.searchBar.text else { return }
        
        if search.isEmpty {
            // no text - return all cities
            matchingCities = allCities
        } else {
            // run search
            matchingCities = allCities.filter {
                $0.matches(search)
            }
        }
        
        tableView.reloadData()
    }
}
