//
//  BusinessDetailsViewController.swift
//  Yelp Locator
//
//  Created by Steven Layug on 11/04/21.
//

import UIKit
import RxSwift
import RxCocoa
import PKHUD

class BusinessDetailsViewController: UIViewController {
    @IBOutlet weak var detailsScrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoStackView: UIStackView!
    @IBOutlet weak var reviewsTitleLabel: UILabel!
    @IBOutlet weak var reviewsStackView: UIStackView!
    @IBOutlet weak var dealsTitleLabel: UILabel!
    @IBOutlet weak var dealsButton: UIButton!
    @IBOutlet weak var firstSeparatorView: UIView!
    @IBOutlet weak var secondSeparatorView: UIView!
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        HUD.show(.rotatingImage(UIImage(named: "yelpIcon")?.resizeImage(75.0)), onView: self.view)
    }
    
    private func setupNavigationBar() {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.white
        titleLabel.font = .primaryFontSemiBold(size: 15)
        titleLabel.text = "Business Details"
        titleLabel.frame = CGRect(x: 0, y: 0, width: 60, height: 34)
        navigationItem.titleView = titleLabel
        
        guard let _navigationController = self.navigationController else { return }
        _navigationController.navigationBar.tintColor = .white
        _navigationController.navigationBar.isHidden = false
        _navigationController.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        _navigationController.setStatusBar(backgroundColor: .primaryColor)
        _navigationController.navigationBar.backgroundColor = .primaryColor
        _navigationController.navigationBar.isTranslucent = true
    }
    
    func setupViews() {
        self.infoStackView.spacing = 0.0
        self.infoStackView.layer.cornerRadius = 8.0
        self.infoStackView.distribution = .fillProportionally
        self.infoStackView.clipsToBounds = true
        
        self.reviewsStackView.spacing = 0.0
        self.reviewsStackView.layer.cornerRadius = 8.0
        self.reviewsStackView.distribution = .fillProportionally
        self.reviewsStackView.clipsToBounds = true
        
        self.titleLabel.font = .primaryFontSemiBold(size: 20)
        self.titleLabel.textColor = .primaryColor
        self.titleLabel.text = ""
        
        self.reviewsTitleLabel.text = ""
        self.reviewsTitleLabel.font = .primaryFontSemiBold(size: 20)
        self.reviewsTitleLabel.textColor = .primaryColor
        
        self.dealsTitleLabel.text = ""
        self.dealsTitleLabel.font = .primaryFontSemiBold(size: 20)
        self.dealsTitleLabel.textColor = .primaryColor
        
        self.dealsButton.isHidden = true
        self.dealsButton.setTitle(" See Deals ", for: .normal)
        self.dealsButton.setTitleColor(.white, for: .normal)
        self.dealsButton.titleLabel?.font = .primaryFontSemiBold(size: 15)
        self.dealsButton.backgroundColor = .primaryColor
        self.dealsButton.layer.cornerRadius = 5.0
        self.dealsButton.addTarget(self, action: #selector(self.dealsButtonTapped), for: .touchUpInside)
        
        self.firstSeparatorView.isHidden = true
        self.secondSeparatorView.isHidden = true
    }
    
    private func setupObservables() {
        self.observeServices().subscribe(onNext: { [weak self] loadViews in
            guard let _self = self else { return }
            if loadViews {
                _self.setupReviews(reviews: _self.viewModel.businessReviews.value)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    _self.setupHeader(info: _self.viewModel.businessDetails.value)
                    _self.setupDetails(details: _self.viewModel.businessDetails.value)
                }
                HUD.hide(animated: true)
            }
        }).disposed(by: disposeBag)
    }
    
    private func observeServices() -> Observable<Bool> {
        return Observable.combineLatest(viewModel.detailsServiceDone, viewModel.reviewsServiceDone)
        { (detailsDone, reviewsDone) in
            return detailsDone && reviewsDone
        }
    }
    
    private func setupHeader(info: BusinessDetailsData) {
        self.titleLabel.text = info.name
        
        if let imageUrl = URL(string: info.imageURL ?? ""), info.imageURL != "" {
            self.viewModel.getData(from: imageUrl) { data, response, error in
                guard let data = data, error == nil else {
                    self.imageView.image = UIImage(named: "yelpIcon")
                    return
                }
                DispatchQueue.main.async() { [weak self] in
                    guard let _self = self else { return }
                    _self.imageView.image = UIImage(data: data)?.withRoundedCorners(radius: 15.0)
                }
            }
        } else {
            self.imageView.image = UIImage(named: "yelpIcon")
        }
    }
    
    private func setupDetails(details: BusinessDetailsData) {
        self.viewModel.detailItems.forEach { [weak self] in
            guard let _self = self else { return }
            
            _self.reviewsTitleLabel.text = "Reviews"
            _self.dealsTitleLabel.text = "Deals"
            _self.firstSeparatorView.isHidden = false
            _self.secondSeparatorView.isHidden = false
            _self.dealsButton.isHidden = false
            
            let detailView: BusinessDetailView = .fromNib()
            detailView.setupDetailItem(detailItem: $0, business: details)
            _self.infoStackView.addArrangedSubview(detailView)
        }
    }
    
    private func setupReviews(reviews: [Review]) {
        reviews.forEach { [weak self] in
            guard let _self = self else { return }
            let reviewView: BusinessReviewView = .fromNib()
            reviewView.setupReviewItem(reviewItem: $0)
            _self.reviewsStackView.addArrangedSubview(reviewView)
            
            if let imageUrl = URL(string: $0.user?.imageURL ?? "") {
                _self.viewModel.getData(from: imageUrl) { data, response, error in
                    guard let data = data, error == nil else {
                        reviewView.setUserImage(image: UIImage(named: "imagePlaceholder") ?? UIImage())
                        return
                    }
                    DispatchQueue.main.async() { [weak self] in
                        guard let _ = self else { return }
                        reviewView.setUserImage(image: UIImage(data: data) ?? UIImage())
                    }
                }
            }  else {
                reviewView.setUserImage(image: UIImage(named: "imagePlaceholder") ?? UIImage())
            }
        }
    }
    
    @objc private func dealsButtonTapped() {
        if let url = URL(string: self.viewModel.businessDetails.value.url ?? "") {
            UIApplication.shared.open(url)
        } else {
            HUD.flash(.labeledError(title: "Yelp link not provided", subtitle: ""), onView: self.view, delay: 1, completion: nil)
        }
    }
}
