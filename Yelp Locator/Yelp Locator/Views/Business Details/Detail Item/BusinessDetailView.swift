//
//  BusinessDetailView.swift
//  Yelp Locator
//
//  Created by Steven Layug on 11/04/21.
//

import UIKit

class BusinessDetailView: UIView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    func setupDetailItem(detailItem: DetailItem, business: BusinessDetailsData) {
        self.setupViews()
        self.titleLabel.text = detailItem.rawValue
        
        switch detailItem {
        case .categories:
            self.valueLabel.text = business.completeCategory
        case .hoursOfOperation:
            if let start = business.hours?.first?.hourOpen?.first?.start, start != "",
               let end = business.hours?.first?.hourOpen?.first?.end, end != "" {
                self.valueLabel.text = "\(business.hours?.first?.hourOpen?.first?.start ?? "") to \(business.hours?.first?.hourOpen?.first?.end ?? "")"
            } else {
                self.valueLabel.text = "None Provided"
            }
        case .address:
            self.valueLabel.text = business.completeAddress
        case .contactNo:
            self.valueLabel.text = (business.phone != "") ? business.phone : "None Provided"
        }
    }
    
    func setupViews() {
        self.titleLabel.font = UIFont(name: "Roboto-Bold", size: 15.0)
        self.titleLabel.textColor = UIColor.primaryColor
        
        self.valueLabel.font = UIFont(name: "Roboto-Light", size: 13.0)
        self.valueLabel.numberOfLines = 0
    }
}
