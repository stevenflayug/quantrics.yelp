//
//  BusinessRequest.swift
//  Yelp Locator
//
//  Created by Steven Layug on 7/04/21.
//

import Foundation
import Moya

public enum UserRequest {
    case businessList(options: BusinessRequestOptions)
    case businessDetails(options: BusinessDetailsRequestOptions)
    case businessReviews(options: BusinessReviewsRequestOptions)
}

extension UserRequest: TargetType {
  public var baseURL: URL {
    return URL(string: "https://api.yelp.com/v3/businesses")!
  }

  public var path: String {
    switch self {
    case .businessList: return "/search"
    case .businessDetails(let options): return "/\(options.id)"
    case .businessReviews(let options): return "/\(options.id)/reviews"
    }
  }

  public var method: Moya.Method {
    return .get
  }

  public var sampleData: Data {
    return Data()
  }

 public var task: Task {
    switch self {
    case .businessList(let options):
        return .requestParameters(parameters: options.urlParameters,
                                  encoding: URLEncoding.default)
    default:
        return .requestParameters(parameters: ["locale": "en_US"],
                                  encoding: URLEncoding.default)
    }
 }

  public var headers: [String: String]? {
    return ["Content-Type": "application/json",
            "Authorization": "Bearer ZnKqgnYVt_Y8yBZF5Sh1Wc5GZdhkr32t7gUTJ-ExkmXlOFDvNwlllJ77g-JFB5AJaSURxNDy27hhHy_0bteFsYN_MZ8O6XKZH4JhjgTv_z0yAPsZHFR0jsbOQYhsYHYx"]
  }

  public var validationType: ValidationType {
    return .successCodes
  }
}

