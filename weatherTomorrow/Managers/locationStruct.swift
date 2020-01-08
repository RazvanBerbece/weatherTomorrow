//
//  locationStruct.swift
//  weatherTomorrow
//
//  Created by Razvan-Antonio Berbece on 09/12/2019.
//  Copyright © 2019 Razvan-Antonio Berbece. All rights reserved.
//

import Foundation
import CoreLocation

struct CLcoordinates {
    var longitude: Double
    var latitude: Double
    
    init(longitude: Double, latitude: Double) {
        self.longitude = longitude
        self.latitude = latitude
    }
}
