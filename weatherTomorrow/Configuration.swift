//
//  Configuration.swift
//  weatherTomorrow
//
//  Created by Razvan-Antonio Berbece on 08/12/2019.
//  Copyright © 2019 Razvan-Antonio Berbece. All rights reserved.
//

import Foundation


struct API {
    static let url = "api.darksky.net"
    static let key = "3bda542c3fb4313462fcc18064701cfe"
    static let baseURLString: String = "https://\(url)/forecast/\(key)/"
}

struct Defaults {
    static let latitude : Double = 37.8267
    static let longitude : Double =  -122.423
}


