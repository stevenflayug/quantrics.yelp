//
//  BusinessListViewModel.swift
//  Yelp Locator
//
//  Created by Steven Layug on 8/04/21.
//

import Foundation
import RxSwift
import RxCocoa

class BusinessListViewModel {
    private let router = BusinessRouter()
    
    let businessList: BehaviorRelay<[Business]> = BehaviorRelay(value: [])
    let errorMessage: BehaviorRelay<String> = BehaviorRelay(value: "")

    func getBusinessList() {
        // TODO: Mock coordinates, should be based on location
        router.startBusinessListRequest(options: BusinessRequestOptions(longitude: 121.14007076052972, latitude: 14.567405147003639, distance: nil, rating: nil)) { [weak self] (data, error) in
            guard let _self = self else { return }
            guard data != nil else {
                _self.errorMessage.accept(error ?? "")
                return
            }
            _self.businessList.accept(data?.businesses ?? [])
        }
    }
}

