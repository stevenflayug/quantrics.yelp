//
//  BusinessRequestOptions.swift
//  Yelp Locator
//
//  Created by Steven Layug on 7/04/21.
//

import Foundation

public struct BusinessRequestOptions {
    var longtitude: Double
    var latitude: Double
    var distance: String?
    var rating: String?
}

extension BusinessRequestOptions: RequestParameter {
    var bodyParameters: [String : Any] {
        var parameters = [String : Any]()
        parameters["longtitude"] = longtitude
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
