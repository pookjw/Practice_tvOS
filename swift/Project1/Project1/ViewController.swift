//
//  ViewController.swift
//  Project1
//
//  Created by Jinwoo Kim on 2/3/21.
//

import UIKit

class ViewController: UIViewController {
    var categories = ["Airplanes", "Beaches", "Bridges", "Cats", "Cities", "Dogs", "Earth", "Forests", "Galaxies", "Landmarks", "Mountains", "People", "Roads", "Sports", "Sunets"]
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(identifier: "Images") as? ImagesViewController else { return }
        vc.category = categories[indexPath.row]
        present(vc, animated: true)
    }
}
