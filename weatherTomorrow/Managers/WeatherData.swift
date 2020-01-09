//
//  jsonManager.swift
//  weatherTomorrow
//
//  Created by Razvan-Antonio Berbece on 09/12/2019.
//  Copyright © 2019 Razvan-Antonio Berbece. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Weather: Codable {
    let timezone: String
    let currently: Currently
    let hourly: Hourly
    
    struct Currently: Codable {
        let summary: String
        let icon: String
        let temperature, apparentTemperature, dewPoint, humidity: Double
        let pressure, windSpeed, windGust: Double
        let windBearing: Int
        let cloudCover: Double
        let uvIndex: Int
        let visibility, ozone: Double
    }
    
    struct Hourly: Codable {
        let summary: String
    }
}


