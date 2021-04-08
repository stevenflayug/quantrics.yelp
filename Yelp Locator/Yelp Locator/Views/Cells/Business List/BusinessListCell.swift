//
//  BusinessListCell.swift
//  Yelp Locator
//
//  Created by Steven Layug on 8/04/21.
//

import UIKit

class BusinessListCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var actionImageView: UIImageView!
    @IBOutlet weak var ratingStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        nameLabel.font = UIFont(name: "Roboto", size: 15.0)
        addressLabel.font = UIFont(name: "Roboto", size: 15.0)
        typeLabel.font = UIFont(name: "Roboto", size: 15.0)
        nameLabel.font = UIFont(name: "Roboto", size: 15.0)
    }
    
    func setupCell(business: Business) {
        var completeAddress = ""
        var completeCategory = ""
        
        business.location.displayAddress.forEach {
            completeAddress += " \($0)"
        }
        
        business.categories.forEach {
            completeCategory += " \($0.title)"
        }
        
        nameLabel.text = business.name
        addressLabel.text = completeAddress
        typeLabel.text = completeCategory
    }
}
