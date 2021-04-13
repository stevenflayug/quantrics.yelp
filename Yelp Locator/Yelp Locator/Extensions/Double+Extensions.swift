//
//  Double+Extensions.swift
//  Yelp Locator
//
//  Created by Steven Layug on 13/04/21.
//

import Foundation

extension Double {
  func convert(from originalUnit: UnitLength, to convertedUnit: UnitLength) -> Double {
    return Measurement(value: self, unit: originalUnit).converted(to: convertedUnit).value
  }
}
