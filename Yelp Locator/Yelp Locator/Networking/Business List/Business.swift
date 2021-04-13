//
//  Business.swift
//  Yelp Locator
//
//  Created by Steven Layug on 7/04/21.
//

import Foundation

struct BusinessData: Codable {
    let businesses: [Business]?
    let total: Int?
    let region: Region?
}

struct Business: Codable {
    let id: String?
    let alias: String?
    let name: String?
    let imageURL: String?
    let isClosed: Bool?
    let url: String?
    let reviewCount: Int?
    let categories: [Category]?
    let rating: Double?
    let coordinates: Center?
    let transactions: [String]?
    let location: Location?
    let phone: String?
    let displayPhone: String?
    let distance: Double?
    let price: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case alias
        case name
        case url
        case categories
        case rating
        case coordinates
        case transactions
        case location
        case phone
        case distance
        case price
        case isClosed = "is_closed"
        case displayPhone = "display_phone"
        case imageURL = "image_url"
        case reviewCount = "review_count"
    }
    
    var completeAddress: String {
        var completeAddress = ""
        self.location?.displayAddress?.forEach {
            completeAddress += completeAddress == "" ?  "\($0)" : " \($0)"
        }
        return completeAddress
    }
    
    var completeCategory: String {
        var completeCategory = ""
        self.categories?.forEach {
            completeCategory += completeCategory == "" ?  "\($0.title ?? "")" : ", \($0.title ?? "")"
        }
        return completeCategory
    }
}

struct Category: Codable {
    let alias: String?
    let title: String?
}

struct Center: Codable {
    let latitude: Double?
    let longitude: Double?
}

struct Location: Codable {
    let address1: String?
    let address2: String?
    let address3: String?
    let city: String?
    let zipCode: String?
    let country: String?
    let state: String?
    let displayAddress: [String]?
    
    enum CodingKeys: String, CodingKey {
        case address1
        case address2
        case address3
        case city
        case country
        case state
        case zipCode = "zip_code"
        case displayAddress = "display_address"
    }
}

struct Region: Codable {
    let center: Center
}
