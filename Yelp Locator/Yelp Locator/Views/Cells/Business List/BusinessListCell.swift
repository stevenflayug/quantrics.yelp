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
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var actionImageView: UIImageView!
    @IBOutlet weak var ratingStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func prepareForReuse() {
        ratingStackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
    }
    
    private func setupUI() {
        self.nameLabel.font = UIFont(name: "Roboto-Regular", size: 15.0)
        self.nameLabel.textColor = .primaryColor
        self.addressLabel.font = UIFont(name: "Roboto-Light", size: 13.0)
        self.addressLabel.numberOfLines = 0
        self.typeLabel.font = UIFont(name: "Roboto-Light", size: 13.0)
        self.distanceLabel.font = UIFont(name: "Roboto-Regular", size: 10.0)
        self.actionImageView.image = UIImage(named: "chevronRight")?.resizeImage(5.0).withTintColor(.backgroundColor)
        self.actionImageView.contentMode = .scaleAspectFit
    }
    
    func setupCell(business: Business) {
        nameLabel.text = business.name
        addressLabel.text = business.completeAddress
        typeLabel.text = business.completeCategory
        distanceLabel.text = "\(business.distance ?? 0.0) Meters Away"
        self.setupRatingView(rating: business.rating ?? 1.0)
    }
    
    private func setupRatingView(rating: Double) {
        let intValue = Int(floor(rating))
        for _ in (1...intValue) {
            let fullStarImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            fullStarImageView.image = UIImage(named: "fullStar")?.resizeImage(20.0).withTintColor(.primaryColor)
            ratingStackView.addArrangedSubview(fullStarImageView)
        }
        
        let decimal = rating.truncatingRemainder(dividingBy: 1)
        if decimal != 0.0 {
            let halfStarImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            halfStarImageView.image = UIImage(named: "halfStar")?.resizeImage(20.0).withTintColor(.primaryColor)
            ratingStackView.addArrangedSubview(halfStarImageView)
        }
    }
}
