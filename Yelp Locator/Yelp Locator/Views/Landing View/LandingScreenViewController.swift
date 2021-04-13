//
//  LandingScreenViewController.swift
//  Yelp Locator
//
//  Created by Steven Layug on 13/04/21.
//

import UIKit
import RxSwift
import RxCocoa
import CoreLocation
import PKHUD

class LandingScreenViewController: UIViewController {
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var brandImageViiew: UIImageView!
    @IBOutlet weak var startButton: UIButton!
    
    private let viewModel = LandingScreenViewModel()
    private var locationManager = CLLocationManager()
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        self.setupNavigationBar()
        self.setupViews()
        self.setupObservables()
        self.viewModel.checkLocationServices()
    }
    
    private func setupNavigationBar() {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.white
        titleLabel.font = .primaryFontSemiBold(size: 15)
        titleLabel.text = "Business Locator"
        titleLabel.frame = CGRect(x: 0, y: 0, width: 60, height: 34)
        navigationItem.titleView = titleLabel

        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        guard let _navigationController = self.navigationController else { return }
        _navigationController.navigationBar.tintColor = .white
        _navigationController.navigationBar.isHidden = false
        _navigationController.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        _navigationController.setStatusBar(backgroundColor: .primaryColor)
        _navigationController.navigationBar.backgroundColor = .primaryColor
        _navigationController.navigationBar.isTranslucent = true
    }

    private func setupViews() {
        self.backgroundImageView.contentMode = .scaleAspectFill
        self.backgroundImageView.image = UIImage(named: "backgroundImage")
        
        self.brandImageViiew.contentMode = .scaleAspectFit
        self.brandImageViiew.image = UIImage(named: "brandImage")
        
        self.startButton.layer.cornerRadius = 5.0
        self.startButton.setTitle(" Find Businesses Nearby ", for: .normal)
        self.startButton.titleLabel?.font = .primaryFontSemiBold(size: 15)
        self.startButton.setTitleColor(.white, for: .normal)
        self.startButton.backgroundColor = .primaryColor
        self.startButton.addTarget(self, action: #selector(navigateToList), for: .touchUpInside)
    }
    
    private func setupObservables() {
        self.viewModel.requestAuthorization.asObservable().subscribe(onNext: { [weak self] in
            guard let _self = self else { return }
            if $0 {
                _self.locationManager.requestWhenInUseAuthorization()
            }
        }).disposed(by: disposeBag)
        
        self.viewModel.locationServicesEnabled.asObservable().subscribe(onNext: { [weak self] in
            guard let _self = self else { return }
            if $0 {
                _self.setupLocationManager()
            }
        }).disposed(by: disposeBag)
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    @objc private func navigateToList() {
        if self.viewModel.locationAuthorized.value {
            let businessListVC = BusinessListViewController()
            self.navigationController?.pushViewController(businessListVC, animated: true)
        } else {
            HUD.flash(.labeledError(title: "Location Access Required", subtitle: self.viewModel.errorMessage.value), delay: 2.0)
        }
    }
}

extension LandingScreenViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            switch locationManager.authorizationStatus {
            case .authorizedAlways, .authorizedWhenInUse:
                self.viewModel.confirmLocationAuthorization()
                UserDefaults.standard.set(locationManager.location?.coordinate.longitude, forKey: "longitude")
                UserDefaults.standard.set(locationManager.location?.coordinate.latitude, forKey: "latitude")
            default:
                break
            }
        }
    }
}
