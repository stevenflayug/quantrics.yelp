//
//  BusinessRouter.swift
//  Yelp Locator
//
//  Created by Steven Layug on 7/04/21.
//

import Foundation
import UIKit
import Moya

class BusinessRouter {
    let provider = MoyaProvider<UserRequest>(plugins: [NetworkLoggerPlugin()])
    
    public func startBusinessListRequest(options: BusinessRequestOptions, completion: @escaping (_ businessList: BusinessData?, _ error: String?) -> Void) {
        provider.request(.businessList(options: options)) { result in
            switch result {
            case .success(let response):
                do {
                    print(try response.mapJSON())
                    if let results = try? response.map(BusinessData.self) {
                        print(results)
                        completion(results, nil)
                    }
                } catch let error {
                    print(error)
                    completion(nil, "No businesses retrieved")
                    return
                }
            case .failure(let error):
                completion(nil, error.localizedDescription)
                return
            }
        }
    }
}
