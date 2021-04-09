//
//  BusinessListViewController.swift
//  Yelp Locator
//
//  Created by Steven Layug on 8/04/21.
//

import UIKit
import RxSwift
import RxCocoa

class BusinessListViewController: UIViewController {
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchByTextField: UITextField!
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var businessListTableview: UITableView!
    
    private var searchByPickerView = UIPickerView()
    
    private let viewModel = BusinessListViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        self.viewModel.getBusinessList()
        self.setupNavigationBar()
        self.setupViews()
        self.setupTableView()
        self.setupObservables()
        self.setupActions()
    }

    private func setupNavigationBar() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.setStatusBar(backgroundColor: UIColor(hexString: "#d32323"))
        self.navigationController?.navigationBar.backgroundColor = UIColor(hexString: "#d32323")
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    private func setupTableView() {
        self.businessListTableview.estimatedRowHeight = 50.0
        self.businessListTableview.rowHeight = UITableView.automaticDimension
        self.businessListTableview.sectionHeaderHeight = 0.0
        self.businessListTableview.separatorStyle = .none
        
        self.businessListTableview.delegate = nil
        self.businessListTableview.dataSource = nil
        self.businessListTableview.separatorStyle = .singleLine
        self.businessListTableview.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        self.searchView.backgroundColor = .clear
        self.view.backgroundColor = UIColor(hexString: "0xEEEEEE")
        
        businessListTableview.layer.cornerRadius = 8.0
        
        // Register Cell
        self.businessListTableview.register(UINib(nibName: "BusinessListCell", bundle: .main), forCellReuseIdentifier: "businessListCell")
    }
    
    func setupViews() {
        self.searchByTextField.delegate = self
        self.searchByTextField.borderStyle = .none
        self.searchByTextField.text = "Search by: Name "
        self.searchByTextField.font = UIFont(name: "Roboto-Regular", size: 13.0)
        self.searchByTextField.backgroundColor = .clear
        self.searchByTextField.rightViewMode = .always
        self.searchByTextField.rightView = UIImageView(image: UIImage(named: "dropDown")?.resizeImage(15.0))
        self.searchByTextField.inputView = self.searchByPickerView
        self.searchByTextField.tintColor = .clear
        
        self.searchByPickerView.delegate = self
        self.searchByPickerView.dataSource = self
    }
    
    private func setupActions() {
//        backButton.rx.tap.bind { [weak self] in
//            self?.navigationController?.popViewController(animated: true)
//        }.disposed(by: disposeBag)
    }
    
    private func setupObservables() {
        self.viewModel.businessList.asObservable().bind(to: businessListTableview.rx.items(cellIdentifier: "businessListCell", cellType: BusinessListCell.self)) {
            index, item, cell in
            cell.setupCell(business: item)
        }.disposed(by: disposeBag)
        
        self.viewModel.businessList.asObservable().subscribe(onNext: { [unowned self] (_) in
            self.businessListTableview.reloadData()
        }).disposed(by: disposeBag)
    }
    
//        self.businessListTableview.rx.itemSelected.subscribe(onNext: { [weak self] (indexPath) in
//            let userDetailsVC = UserDetailsTableViewController()
//            userDetailsVC.user.accept(self!.viewModel.userList.value[indexPath.row])
//            self?.navigationController?.pushViewController(userDetailsVC, animated: true)
//        }).disposed(by: disposeBag)
}

extension BusinessListViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}

extension BusinessListViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return SearchTypes.allCases.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return SearchTypes.allCases[row].rawValue
    }
}


// TODO: Move to viewmodel

public enum SearchTypes: String {
    case name = "Business Name"
    case address = "Business Address"
    case type = "Business Type"
    
    public static let allCases: [SearchTypes] = [.name, .address, .type]
}
