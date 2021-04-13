//
//  BusinessListValues.swift
//  Yelp Locator
//
//  Created by Steven Layug on 11/04/21.
//

import Foundation

public enum SearchType: String {
    case name = "Business Name"
    case address = "Business Address"
    case type = "Business Type"
    
    public static let allCases: [SearchType] = [.name, .address, .type]
}

public enum FilterType: String {
    case none = "None"
    case distance = "Distance"
    case rating = "Rating"
    
    public static let allCases: [FilterType] = [.none, .distance, .rating]
}

public enum DetailItem: String {
    case categories = "Categories"
    case hoursOfOperation = "Operating Hours"
    case address = "Address"
    case contactNo = "Contact Number"
    
    public static let allCases: [DetailItem] = [.categories, .hoursOfOperation, .address, .contactNo]
}
