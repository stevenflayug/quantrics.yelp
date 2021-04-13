//
//  LandingScreenViewModel.swift
//  Yelp Locator
//
//  Created by Steven Layug on 13/04/21.
//

import UIKit
import MapKit
import RxCocoa
import RxSwift

class LandingScreenViewModel {
    let locationServicesEnabled: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    let locationAuthorized: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    let requestAuthorization: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    let errorMessage: BehaviorRelay<String> = BehaviorRelay(value: "Please enable Location Access on Settings to view nearby Businesses")
    
    private let locManager = CLLocationManager()
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            locationServicesEnabled.accept(true)
            checkLocationAuthorization()
        }
    }
    
    func confirmLocationAuthorization() {
        locationAuthorized.accept(true)
    }
    
    private func checkLocationAuthorization() {
        switch locManager.authorizationStatus {
        case .authorizedWhenInUse:
            locationAuthorized.accept(true)
        case .authorizedAlways:
            locationAuthorized.accept(true)
        case .notDetermined:
            requestAuthorization.accept(true)
        default:
            break
        }
    }
}


