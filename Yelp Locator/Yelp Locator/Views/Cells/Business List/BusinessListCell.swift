//
//  BusinessListCell.swift
//  Yelp Locator
//
//  Created by Steven Layug on 8/04/21.
//

import UIKit

class BusinessListCell: UITableViewCell {
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var actionImageView: UIImageView!
    @IBOutlet weak var ratingStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        
        for family in UIFont.familyNames.sorted() {
            let names = UIFont.fontNames(forFamilyName: family)
            print("Family: \(family) Font names: \(names)")
        }
    }
    
    private func setupUI() {
        self.nameLabel.font = UIFont(name: "Roboto-Regular", size: 15.0)
        self.nameLabel.textColor = UIColor(hexString: "#d32323")
        self.addressLabel.font = UIFont(name: "Roboto-Light", size: 13.0)
        self.addressLabel.numberOfLines = 0
        self.typeLabel.font = UIFont(name: "Roboto-Light", size: 13.0)
    }
    
    func setupCell(business: Business) {
        nameLabel.text = business.name
        addressLabel.text = business.completeAddress
        typeLabel.text = business.completeCategory
    }
}
