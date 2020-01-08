//
//  DataManager.swift
//  weatherTomorrow
//
//  Created by Razvan-Antonio Berbece on 08/12/2019.
//  Copyright © 2019 Razvan-Antonio Berbece. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

final class DataManager {
    
    let baseURL: String
    let session = Alamofire.Session()
    
    init(baseURL: String) {
        self.baseURL = baseURL
    }
    
        @discardableResult
        func getWeather(
          latitude: Double,
          longitude: Double,
          units: String,
          completion: @escaping (AFDataResponse<Weather>) -> Void)
          -> Request
        {
            let url = URL(string: baseURL)
            let path = "\(latitude),\(longitude)?units=\(units)"
            let finalURL = url.flatMap
            {
                URL(string: $0.absoluteString + path)
            }
        
          // Set up the call and fire it off
            print("Connecting to \(finalURL) ...")
            let request = session.request(finalURL!).responseDecodable(
            completionHandler: { (response: AFDataResponse<Weather>) in
              // Process the asynchronous response by returning it to the
              // caller; if successful, response includes a deserialized model
              completion(response)
            }
          )

          // Not necessary, but might be nice for debugging purposes
          return request
        }
}

