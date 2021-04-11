//
//  BusinessDetails.swift
//  Yelp Locator
//
//  Created by Steven Layug on 11/04/21.
//

import Foundation

struct BusinessDetailsData: Codable {
    let id, alias, name: String?
    let imageURL: String?
    let isClaimed, isClosed: Bool?
    let url: String?
    let phone, displayPhone: String?
    let reviewCount: Int?
    let categories: [Category]?
    let rating: Double?
    let location: DetailLocation?
    let coordinates: Coordinates?
    let photos: [String]?
    let hours: [Hour]?
    let transactions: [String]?
    
    public init() {
        self.id = ""
        self.alias = ""
        self.name = ""
        self.imageURL = ""
        self.isClaimed = false
        self.isClosed = false
        self.url = ""
        self.phone = ""
        self.displayPhone = ""
        self.reviewCount = 0
        self.categories = []
        self.rating = 0
        self.location = DetailLocation()
        self.coordinates = Coordinates()
        self.photos = []
        self.hours = []
        self.transactions = []
    }

    enum CodingKeys: String, CodingKey {
        case id, alias, name
        case imageURL = "image_url"
        case isClaimed = "is_claimed"
        case isClosed = "is_closed"
        case url, phone
        case displayPhone = "display_phone"
        case reviewCount = "review_count"
        case categories, rating, location, coordinates, photos, hours, transactions
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
            completeCategory += completeCategory == "" ?  "\($0.title)" : ", \($0.title)"
        }
        return completeCategory
    }
}

struct Coordinates: Codable {
    let latitude, longitude: Double
    
    public init() {
        self.latitude = 0.0
        self.longitude = 0.0
    }
}

struct Hour: Codable {
    let hourOpen: [Open]?
    let hoursType: String?
    let isOpenNow: Bool?

    enum CodingKeys: String, CodingKey {
        case hourOpen = "open"
        case hoursType = "hours_type"
        case isOpenNow = "is_open_now"
    }
}

struct Open: Codable {
    let isOvernight: Bool?
    let start, end: String?
    let day: Int?

    enum CodingKeys: String, CodingKey {
        case isOvernight = "is_overnight"
        case start, end, day
    }
}

struct DetailLocation: Codable {
    let address1, address2, address3, city: String?
    let zipCode, country, state: String?
    let displayAddress: [String]?
    let crossStreets: String?
    
    public init() {
        self.address1 = ""
        self.address2 = ""
        self.address3 = ""
        self.city = ""
        self.zipCode = ""
        self.country = ""
        self.state = ""
        self.displayAddress = []
        self.crossStreets = ""
    }

    enum CodingKeys: String, CodingKey {
        case address1, address2, address3, city
        case zipCode = "zip_code"
        case country, state
        case displayAddress = "display_address"
        case crossStreets = "cross_streets"
    }
}
