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

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    private let dataManager = DataManager(baseURL: API.baseURLString)
    
    @IBOutlet weak var mainDegrees: UILabel!
    @IBOutlet weak var mainDesc: UILabel!
    @IBOutlet weak var cityName: UILabel!
    
    let emojiIcons = emojiDict()
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    var reverseCoordinates = CLcoordinates(longitude: 0, latitude: 0)
    var cityNameAccessed : String = "Default"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        locationManager.requestWhenInUseAuthorization()
        if( CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
                CLLocationManager.authorizationStatus() ==  .authorizedAlways){
                    currentLocation = locationManager.location
        }
        
        dataManager.getWeather(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude, units: "si", completion: {
            response in
            switch response.result {
               case .success(let value):
                //print(value)
                self.mainDegrees.text = String(Int(value.currently.temperature)) + " °C"
                self.mainDesc.text = value.currently.summary + " " + self.emojiIcons.emojis[value.currently.icon]!
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
