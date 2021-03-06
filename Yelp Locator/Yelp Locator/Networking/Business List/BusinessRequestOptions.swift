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
    var distance: Bool? = nil
    var rating: Bool? = nil
    var name: String? = nil
    var address: String? = nil
    var category: String? = nil
}

extension BusinessRequestOptions: RequestParameter {
    var urlParameters: [String : Any] {
        var parameters = [String : Any]()
        parameters["longitude"] = longitude
        parameters["latitude"] = latitude
        parameters["sort_by"] = "best_match"
        
        if distance != nil {
            parameters["sort_by"] = "distance"
        } else if rating != nil {
            parameters["sort_by"] = "rating"
        }
        
        if name != nil {
            parameters["term"] = name
        } else if address != nil {
            parameters["location"] = address
        } else if category != nil {
            parameters["categories"] = category
        }
        
        return parameters
    }
}
