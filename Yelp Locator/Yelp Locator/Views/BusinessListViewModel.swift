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
    
    let filterValue: BehaviorRelay<String> = BehaviorRelay(value: "")
    let businessList: BehaviorRelay<[Business]> = BehaviorRelay(value: [])
    let businessListContainer: BehaviorRelay<[Business]> = BehaviorRelay(value: [])
    let errorMessage: BehaviorRelay<String> = BehaviorRelay(value: "")
    let disposeBag = DisposeBag()
    var searchCategory: SearchType = .name
    
    func getBusinessList() {
        // TODO: Mock coordinates, should be based on location
        router.startBusinessListRequest(options: BusinessRequestOptions(longitude: 121.14007076052972, latitude: 14.567405147003639, distance: nil, rating: nil)) { [weak self] (data, error) in
            guard let _self = self else { return }
            guard data != nil else {
                _self.errorMessage.accept(error ?? "")
                return
            }
            _self.businessListContainer.accept(data?.businesses ?? [])
            _self.businessList.accept(data?.businesses ?? [])
        }
    }
    
    func setupObservables() {
        self.filterValue.asObservable().subscribe(onNext: { [weak self] (searchText) in
            guard let _self = self else { return }
            var filteredList: [Business] = []
            switch _self.searchCategory {
            case .name:
                filteredList = _self.businessListContainer.value.filter({$0.name.lowercased().contains(searchText.lowercased())})
            case .address:
                filteredList = _self.businessListContainer.value.filter({$0.completeAddress.lowercased().contains(searchText.lowercased())})
            default:
                filteredList = _self.businessListContainer.value.filter({$0.completeCategory.lowercased().contains(searchText.lowercased())})
            }
            if searchText != "" {
                _self.businessList.accept(filteredList)
            } else {
                _self.businessList.accept(_self.businessListContainer.value)
            }
        }).disposed(by: self.disposeBag)
    }
    
    func setSearchCategory(category: SearchType) {
        self.searchCategory = category
    }
}

