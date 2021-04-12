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
    
    let searchTypes = SearchType.allCases
    let filterTypes = FilterType.allCases
        
    let searchTextValue: BehaviorRelay<String> = BehaviorRelay(value: "")
    let businessList: BehaviorRelay<[Business]> = BehaviorRelay(value: [])
    let businessListContainer: BehaviorRelay<[Business]> = BehaviorRelay(value: [])
    let errorMessage: BehaviorRelay<String> = BehaviorRelay(value: "")
    
    var initialLoadDone = false
    var searchCategory: SearchType = .name
    var filterType: FilterType = .none
    
    private let disposeBag = DisposeBag()

    func setupObservables() {
        self.searchTextValue.asObservable().subscribe(onNext: { [weak self] in
            guard let _self = self else { return }
            _self.searchBusinesses(searchText: $0)
        }).disposed(by: self.disposeBag)
    }
    
    func setSearchCategory(category: SearchType) {
        self.searchCategory = category
    }
    
    func setFilterType(filterType: FilterType) {
        self.startBusinessListRequest(filterBy: filterType)
    }
    
    func startBusinessListRequest(filterBy: FilterType) {
        let longitude = UserDefaults.standard.double(forKey: "longitude")
        let latitude = UserDefaults.standard.double(forKey: "latitude")
        
        var requestParameters = BusinessRequestOptions(longitude: longitude, latitude: latitude)
        
        switch filterBy {
        case .distance:
            requestParameters = BusinessRequestOptions(longitude: longitude, latitude: latitude, distance: true)
        case .rating:
            requestParameters = BusinessRequestOptions(longitude: longitude, latitude: latitude, rating: true)
        default:
            break
        }
        
        self.router.startBusinessListRequest(options: requestParameters) { [weak self] (data, error) in
            guard let _self = self else { return }
            guard data != nil else {
                _self.errorMessage.accept(error ?? "")
                return
            }
            
            // Had to sort manually when filtering by Rating since API sometimes returns inconsistent lists
            if filterBy == .rating {
                _self.businessListContainer.accept(data?.businesses?.sorted(by: { $0.rating ?? 0.0 > $1.rating ?? 0.0 }) ?? [])
            } else {
                _self.businessListContainer.accept(data?.businesses ?? [])
            }
            _self.searchBusinesses(searchText: _self.searchTextValue.value)
            _self.initialLoadDone = true
        }
    }
    
    private func searchBusinesses(searchText: String) {
        var filteredList: [Business] = []
        switch self.searchCategory {
        case .name:
            filteredList = self.businessListContainer.value.filter({($0.name?.lowercased().contains(searchText.lowercased()) ?? false)})
        case .address:
            filteredList = self.businessListContainer.value.filter({$0.completeAddress.lowercased().contains(searchText.lowercased())})
        default:
            filteredList = self.businessListContainer.value.filter({$0.completeCategory.lowercased().contains(searchText.lowercased())})
        }
        if searchText != "" {
            self.businessList.accept(filteredList)
        } else {
            self.businessList.accept(self.businessListContainer.value)
        }
    }
}

