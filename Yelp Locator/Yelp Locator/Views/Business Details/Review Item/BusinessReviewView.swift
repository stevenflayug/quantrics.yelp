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
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var reviewContentLabel: UILabel!
    
    func setupReviewItem(reviewItem: Review) {
        self.setupViews()
        self.userNameLabel.text = reviewItem.user.name
        self.ratingLabel.text = "\(reviewItem.rating) Stars"
        self.reviewContentLabel.text = reviewItem.text
    }
    
    func setUserImage(image: UIImage) {
        self.userImageView.image = image
    }
    
    func setupViews() {
        self.userNameLabel.font = UIFont(name: "Roboto", size: 13.0)
        self.userNameLabel.textColor = UIColor(hexString: "#d32323")
        
        self.ratingLabel.font = UIFont(name: "Roboto", size: 13.0)
        
        self.reviewContentLabel.font = UIFont(name: "Roboto", size: 13.0)
        self.reviewContentLabel.numberOfLines = 0
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
