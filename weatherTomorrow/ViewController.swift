//
//  ViewController.swift
//  weatherTomorrow
//
//  Created by Razvan-Antonio Berbece on 08/12/2019.
//  Copyright © 2019 Razvan-Antonio Berbece. All rights reserved.
//

import UIKit
import Alamofire
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, UISearchBarDelegate{
    
    private let dataManager = DataManager(baseURL: API.baseURLString)
    
    @IBOutlet weak var mainDegrees: UILabel!
    @IBOutlet weak var mainDesc: UILabel!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var hourlyDescription: UILabel!
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    
    let emojiIcons = emojiDict()
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    var reverseCoordinates = CLcoordinates(longitude: 0, latitude: 0)
    var cityNameAccessed : String = "Default"
    
    var resultSearchController : UISearchController? = nil
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            checkLocationAuthorization()
        } else {
            // Show alert letting the user know they have to turn this on.
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            currentLocation = locationManager.location
        case .denied: // Show alert telling users how to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            mapView.showsUserLocation = true
            currentLocation = locationManager.location
        case .restricted: // Show an alert letting them know what’s up
            break
        case .authorizedAlways:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addBackground(contentMode: .center)
        checkLocationServices()
        
        //Zoom to user location
        if let userLocation = locationManager.location?.coordinate {
            let viewRegion = MKCoordinateRegion(center: userLocation, latitudinalMeters: 200, longitudinalMeters: 200)
            mapView.setRegion(viewRegion, animated: false)
        }
        
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for cities ..."
        navigationItem.titleView = resultSearchController?.searchBar
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        
        locationSearchTable.mapView = mapView
        
        dataManager.getWeather(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude, units: "si", completion: {
            response in
            switch response.result {
            case .success(let value):
                //print(value)
                self.mainDegrees.text = String(Int(value.currently.temperature)) + " °C"
                self.mainDesc.text = value.currently.summary + " " + self.emojiIcons.emojis[value.currently.icon]!
                self.hourlyDescription.text = value.hourly.summary
            case .failure(let error):
                print(error)
            }
        })
        
        CLGeocoder().reverseGeocodeLocation(currentLocation, completionHandler: {(placemarks, error) -> Void in
            if error != nil {
                print("Failed to get current location of device." + error!.localizedDescription)
                return
            }
            
            if placemarks!.count > 0 {
                let pm = placemarks![0] as! CLPlacemark
                self.cityName.text = pm.locality
            }
            else {
                print("Problem interpreting data received.")
            }
        })
        
    }
}
