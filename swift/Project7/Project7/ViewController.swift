//
//  ViewController.swift
//  Project7
//
//  Created by Jinwoo Kim on 2/11/21.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    var pages = [String: JSON]()
    var firstRun = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mapView.centerCoordinate = CLLocationCoordinate2D(latitude: 51.38, longitude: -2.36)
        updateMap()
    }

    func focus(on city: City) {
        mapView.centerCoordinate = city.coordinates
    }
    
    func updateMap() {
        guard let url = URL(string: "https://en.wikipedia.org/w/api.php?ggscoord=\(self.mapView.centerCoordinate.latitude)%7C\(self.mapView.centerCoordinate.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json") else {
            return
        }
        
        DispatchQueue.global(qos: .userInteractive).async {
            if let data = try? Data(contentsOf: url) {
                let json = JSON(data)
                self.pages = json["query"]["pages"].dictionaryValue
                DispatchQueue.main.async {
                    self.reloadAnnotations()
                }
            }
        }
    }
    
    func reloadAnnotations() {
        // remove all existing annotations
        mapView.removeAnnotations(mapView.annotations)
        
        // create a new, empty map rect
        var visibleMap = MKMapRect.null
        
        // loop over all the pages we received from Wikipedia
        for page in pages.values {
            // create a point annotation for it, configuring its title and coordinate
            let point = MKPointAnnotation()
            point.title = page["title"].stringValue
            point.coordinate = CLLocationCoordinate2D(latitude: page["coordinates"][0]["lat"].doubleValue,
                                                      longitude: page["coordinates"][0]["lon"].doubleValue)
            
            // add that to the map
            mapView.addAnnotation(point)
            
            // add its position to our overall map rect+
            let mapPoint = MKMapPoint(point.coordinate)
            let pointRect = MKMapRect(x: mapPoint.x, y: mapPoint.y, width: 0.1, height: 0.1)
            visibleMap = visibleMap.union(pointRect)
            
            print("Noti!!! \(point.coordinate)")
        }
        
        // if this is the first time we have loaded pins
        if firstRun {
            // zoom to the configured map rect
            mapView.setVisibleMapRect(visibleMap, edgePadding: UIEdgeInsets(top: 60, left: 60, bottom: 90, right: 90), animated: true)
            
            // mark that we've done it at least once
            firstRun = false
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        updateMap()
    }
}
