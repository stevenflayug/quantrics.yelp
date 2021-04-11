//
//  BusinessDetailsViewController.swift
//  Yelp Locator
//
//  Created by Steven Layug on 11/04/21.
//

import UIKit
import RxSwift
import RxCocoa

class BusinessDetailsViewController: UIViewController {
    @IBOutlet weak var detailsScrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoStackView: UIStackView!
    @IBOutlet weak var reviewsTitleLabel: UILabel!
    @IBOutlet weak var reviewsStackView: UIStackView!
    @IBOutlet weak var dealsTitleLabel: UILabel!
    @IBOutlet weak var dealsButton: UIButton!
    
    private var viewModel = BusinessDetailsViewModel(businessId: "")
    private let disposeBag = DisposeBag()
    
    private var businessId = ""
    
    init(businessId: String) {
        self.businessId = businessId
        self.viewModel = BusinessDetailsViewModel(businessId: businessId)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.setupNavigationBar()
        self.setupViews()
        self.setupObservables()
        self.viewModel.startBusinessDetailsRequest()
        self.viewModel.startBusinessReviewsRequest()
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.setStatusBar(backgroundColor: UIColor(hexString: "#d32323"))
        self.navigationController?.navigationBar.backgroundColor = UIColor(hexString: "#d32323")
        self.navigationController?.navigationBar.isTranslucent = true
        
//        let padding = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
//        let filterDoneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(filterDoneTapped))
//
//        let filterToolBar = UIToolbar()
//        filterToolBar.barStyle = UIBarStyle.default
//        filterToolBar.isTranslucent = true
//        filterToolBar.tintColor = UIColor.systemBlue
//        filterToolBar.sizeToFit()
//        filterToolBar.setItems([padding, filterDoneButton], animated: false)
//        filterToolBar.isUserInteractionEnabled = true
//
//        let filterItem = UITextField()
//        filterItem.delegate = self
//        filterItem.tintColor = .clear
//        filterItem.borderStyle = .none
//        filterItem.backgroundColor = .clear
//        filterItem.leftViewMode = .always
//        filterItem.leftView = UIImageView(image: UIImage(named: "filter")?.resizeImage(20.0))
//        filterItem.inputView = self.filterPickerView
//        filterItem.inputAccessoryView = filterToolBar
//
//        self.filterPickerView.delegate = self
//        self.filterPickerView.dataSource = self
//
//        filterBarButton = UIBarButtonItem(customView: filterItem)
//        self.navigationItem.rightBarButtonItem = self.filterBarButton
    }
    
    func setupViews() {
        self.infoStackView.spacing = 0.0
        self.infoStackView.distribution = .fillProportionally
        
        self.reviewsStackView.spacing = 0.0
        self.reviewsStackView.distribution = .fillProportionally
        
        self.titleLabel.font = UIFont(name: "Roboto-Bold", size: 20.0)
        self.titleLabel.textColor = UIColor(hexString: "#d32323")
        
        self.reviewsTitleLabel.text = "Reviews"
        self.reviewsTitleLabel.font = UIFont(name: "Roboto-Bold", size: 20.0)
        self.reviewsTitleLabel.textColor = UIColor(hexString: "#d32323")
        
        self.dealsTitleLabel.text = "Deals"
        self.dealsTitleLabel.font = UIFont(name: "Roboto-Bold", size: 20.0)
        self.dealsTitleLabel.textColor = UIColor(hexString: "#d32323")
        
        self.dealsButton.setTitle(" See Deals ", for: .normal)
        self.dealsButton.setTitleColor(.white, for: .normal)
        self.dealsButton.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 15.0)
        self.dealsButton.backgroundColor = UIColor(hexString: "#d32323")
        self.dealsButton.layer.cornerRadius = 5.0
    }
    
    private func setupObservables() {
        self.viewModel.businessDetails.asObservable().subscribe(onNext: { [weak self] in
            guard let _self = self else { return }
            if $0.name != "" {
                _self.setupHeader(info: $0)
                _self.setupDetails(details: $0)
            }
        }).disposed(by: disposeBag)
        
        self.viewModel.businessReviews.asObservable().subscribe(onNext: { [weak self] in
            guard let _self = self else { return }
            _self.setupReviews(reviews: $0)
        }).disposed(by: disposeBag)
    }
    
    private func setupHeader(info: BusinessDetailsData) {
        self.titleLabel.text = info.name
        
        if let imageUrl = URL(string: info.imageURL) {
            self.viewModel.getData(from: imageUrl) { data, response, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async() { [weak self] in
                    guard let _self = self else { return }
                    _self.imageView.image = UIImage(data: data)
                }
            }
        }
    }
    
    private func setupDetails(details: BusinessDetailsData) {
        DetailItem.allCases.forEach { [weak self] in
            guard let _self = self else { return }
            let detailView: BusinessDetailView = .fromNib()
            detailView.setupDetailItem(detailItem: $0, business: details)
            _self.infoStackView.addArrangedSubview(detailView)
        }
        self.infoStackView.layoutIfNeeded()
    }
    
    private func setupReviews(reviews: [Review]) {
        reviews.forEach { [weak self] in
            guard let _self = self else { return }
            let reviewView: BusinessReviewView = .fromNib()
            reviewView.setupReviewItem(reviewItem: $0)
            _self.reviewsStackView.addArrangedSubview(reviewView)
            
            if let imageUrl = URL(string: $0.user.imageURL) {
                _self.viewModel.getData(from: imageUrl) { data, response, error in
                    guard let data = data, error == nil else { return }
                    DispatchQueue.main.async() { [weak self] in
                        guard let _ = self else { return }
                        reviewView.setUserImage(image: UIImage(data: data) ?? UIImage())
                    }
                }
            }
        }
        self.infoStackView.layoutIfNeeded()
    }
}

//TODO: Move to extension
extension UIView {
    class func fromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}
