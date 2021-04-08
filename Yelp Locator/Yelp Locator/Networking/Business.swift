//
//  Business.swift
//  Yelp Locator
//
//  Created by Steven Layug on 7/04/21.
//

import Foundation

struct BusinessData: Codable {
    let businesses: [Business]
    let total: Int
    let region: Region
}

struct Business: Codable {
    let id: String
    let alias: String
    let name: String
    let imageURL: String
    let isClosed: Bool
    let url: String
    let reviewCount: Int
    let categories: [Category]
    let rating: Double
    let coordinates: Center
    let transactions: [String?]
    let location: Location
    let phone: String
    let displayPhone: String
    let distance: Double
    let price: String?
}

struct Category: Codable {
    let alias: String
    let title: String
}

struct Center: Codable {
    let latitude: Double
    let longitude: Double
}

struct Location: Codable {
    let address1: String
    let address2: String
    let address3: String?
    let city: String
    let zipCode: String
    let country: String
    let state: String
    let displayAddress: [String]
}

struct Region: Codable {
    let center: Center
}
