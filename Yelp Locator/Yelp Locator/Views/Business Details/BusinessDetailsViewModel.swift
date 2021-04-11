//
//  BusinessDetailsViewModel.swift
//  Yelp Locator
//
//  Created by Steven Layug on 11/04/21.
//

import Foundation
import RxSwift
import RxCocoa

class BusinessDetailsViewModel {
    private let router = BusinessRouter()
    private var businessId = ""
    
    let businessDetails: BehaviorRelay<BusinessDetailsData> = BehaviorRelay(value: BusinessDetailsData())
    let businessReviews: BehaviorRelay<[Review]> = BehaviorRelay(value: [])
    let errorMessage: BehaviorRelay<String> = BehaviorRelay(value: "")
    let disposeBag = DisposeBag()

    init(businessId: String) {
        self.businessId = businessId
    }
    
    func setupObservables() {
        self.startBusinessDetailsRequest()
        self.startBusinessDetailsRequest()
    }
    
    func startBusinessDetailsRequest() {
        self.router.startBusinessDetailsRequest(options: BusinessDetailsRequestOptions(id: self.businessId)) { [weak self] (data, error) in
            guard let _self = self else { return }
            guard data != nil else {
                _self.errorMessage.accept(error ?? "")
                return
            }
            _self.businessDetails.accept(data ?? BusinessDetailsData())
        }
    }
    
    func startBusinessReviewsRequest() {
        self.router.startBusinessReviewsRequest(options: BusinessReviewsRequestOptions(id: self.businessId)) { [weak self] (data, error) in
            guard let _self = self else { return }
            guard data != nil else {
                _self.errorMessage.accept(error ?? "")
                return
            }
            _self.businessReviews.accept(data?.reviews ?? [])
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}

