//
//  BusinessDetailViewModel.swift
//  Yelp Locator
//
//  Created by Steven Layug on 13/04/21.
//

import Foundation

class BusinessDetailViewModel {
    
    func formatTime(dateString: String) -> String {
        var dateValue = dateString
        dateValue.insert(":", at: dateValue.index(dateValue.startIndex, offsetBy: 2))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let dateFromStr = dateFormatter.date(from: dateValue) ?? Date()
        
        dateFormatter.dateFormat = "hh:mm a"
        let timeFromDate = dateFormatter.string(from: dateFromStr)
        return timeFromDate
    }
}
