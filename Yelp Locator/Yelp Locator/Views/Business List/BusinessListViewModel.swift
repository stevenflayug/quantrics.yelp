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
    
    func setSearchCategory(category: SearchType) {
        self.searchCategory = category
    }
    
    func setFilterType(filterType: FilterType) {
        self.filterType = filterType
        self.startBusinessListRequest(filterBy: filterType)
    }
    
    func startBusinessListRequest(filterBy: FilterType) {
        let longitude = UserDefaults.standard.double(forKey: "longitude")
        let latitude = UserDefaults.standard.double(forKey: "latitude")
        
        let requestParameters = BusinessRequestOptions(longitude: longitude,
                                                       latitude: latitude,
                                                       distance: filterBy == .distance ? true : nil,
                                                       rating: filterBy == .rating ? true : nil,
                                                       name: self.searchCategory == .name ? self.searchTextValue.value : nil,
                                                       address: self.searchCategory == .address && self.searchTextValue.value != "" ? self.searchTextValue.value : nil,
                                                       category: self.searchCategory == .type ? self.searchTextValue.value : nil)
        
        self.router.startBusinessListRequest(options: requestParameters) { [weak self] (data, error) in
            guard let _self = self else { return }
            guard data != nil else {
                _self.errorMessage.accept(error ?? "")
                return
            }

            switch filterBy {
            case .none:
                // Added alphabetical sorting for default list
                _self.businessListContainer.accept(data?.businesses?.sorted(by: { $0.name ?? "" < $1.name ?? "" }) ?? [])
            case .rating:
                // Need to sort manually when filtering by Rating since API sometimes returns inconsistent order
                _self.businessListContainer.accept(data?.businesses?.sorted(by: { $0.rating ?? 0.0 > $1.rating ?? 0.0 }) ?? [])
            default:
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
            if searchText != "" {
                /// Need to manually filter by Name search since API response also filters by Category on "term" search
                /// term - string - Optional. Search term, for example "food" or "restaurants". The term may also be business names, such as "Starbucks". If term is not included the endpoint will default to searching across businesses from a small number of popular categories.
                filteredList = self.businessListContainer.value.filter({($0.name?.lowercased().contains(searchText.lowercased()) ?? false)})
                self.businessList.accept(filteredList)
            } else {
                self.businessList.accept(self.businessListContainer.value)
            }
        default:
            self.businessList.accept(self.businessListContainer.value)
        }
    }
    
    func clearSearchValue() {
        self.searchTextValue.accept("")
    }
}

