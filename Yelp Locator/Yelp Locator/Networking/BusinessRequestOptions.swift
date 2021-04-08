//
//  BusinessRequestOptions.swift
//  Yelp Locator
//
//  Created by Steven Layug on 7/04/21.
//

import Foundation

public struct BusinessRequestOptions {
    var longitude: Double
    var latitude: Double
    var distance: String?
    var rating: String?
}

extension BusinessRequestOptions: RequestParameter {
    var urlParameters: [String : Any] {
        var parameters = [String : Any]()
        parameters["longitude"] = longitude
        parameters["latitude"] = latitude
        
        if distance != nil {
            parameters["distance"] = distance
        }
        
        if rating != nil {
            parameters["rating"] = rating
        }
        
        return parameters
    }
}
