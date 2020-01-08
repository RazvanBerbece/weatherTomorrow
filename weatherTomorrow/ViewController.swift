//
//  ViewController.swift
//  weatherTomorrow
//
//  Created by Razvan-Antonio Berbece on 08/12/2019.
//  Copyright © 2019 Razvan-Antonio Berbece. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, UISearchBarDelegate {
    
    private let dataManager = DataManager(baseURL: API.baseURLString)
    
    @IBOutlet weak var mainDegrees: UILabel!
    @IBOutlet weak var mainDesc: UILabel!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var hourlyDescription: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let emojiIcons = emojiDict()
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    var reverseCoordinates = CLcoordinates(longitude: 0, latitude: 0)
    var cityNameAccessed : String = "Default"
    
    var resultSearchController : UISearchController? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.showsCancelButton = true
        searchBar.delegate = self
        
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        locationManager.requestWhenInUseAuthorization()
        if( CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
                CLLocationManager.authorizationStatus() ==  .authorizedAlways){
                    currentLocation = locationManager.location
        }
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        navigationItem.titleView = resultSearchController?.searchBar
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        
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
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                   return
               }

            if placemarks!.count > 0 {
                let pm = placemarks![0] as! CLPlacemark
                self.cityName.text = pm.locality
               }
               else {
                   print("Problem with the data received from geocoder")
               }
           })
        
        }
    }
