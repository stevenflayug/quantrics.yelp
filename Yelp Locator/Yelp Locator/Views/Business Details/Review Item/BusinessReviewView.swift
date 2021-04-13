//
//  BusinessReviewView.swift
//  Yelp Locator
//
//  Created by Steven Layug on 11/04/21.
//

import UIKit

class BusinessReviewView: UIView {
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var reviewContentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var ratingStackView: UIStackView!
    
    
    func setupReviewItem(reviewItem: Review) {
        self.setupViews()
        self.userNameLabel.text = reviewItem.user?.name
        self.reviewContentLabel.text = reviewItem.text
        self.dateLabel.text = reviewItem.timeCreated
        self.setupRatingView(rating: reviewItem.rating ?? 1)
    }
    
    func setUserImage(image: UIImage) {
        self.userImageView.contentMode = .scaleAspectFit
        self.userImageView.image = image
    }
    
    private func setupViews() {
        self.userImageView.layer.cornerRadius = 3.0
        
        self.userNameLabel.font = .primaryFont(size: 13)
        self.userNameLabel.textColor = UIColor.primaryColor
        
        self.reviewContentLabel.font = .primaryFont(size: 13)
        self.reviewContentLabel.numberOfLines = 0
        
        self.dateLabel.font = .primaryFontSemiBold(size: 13)
        
        self.ratingStackView.spacing = 1.0
        self.ratingStackView.distribution = .fillProportionally
    }
    
    private func setupRatingView(rating: Int) {
        for _ in (1...rating) {
            let fullStarImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            fullStarImageView.image = UIImage(named: "fullStar")?.resizeImage(20.0).withTintColor(.primaryColor)
            ratingStackView.addArrangedSubview(fullStarImageView)
        }
        
        self.layoutSubviews()
    }
}
