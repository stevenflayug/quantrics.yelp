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
    
    private var filterBarButton = UIBarButtonItem()
    private var searchByPickerView = UIPickerView()
    private var filterPickerView = UIPickerView()
    
    private let viewModel = BusinessListViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        self.viewModel.startBusinessListRequest(filterBy: .none)
        self.setupNavigationBar()
        self.setupViews()
        self.setupTableView()
        self.setupObservables()
        self.bindValues()
        self.setupActions()
    }

    private func setupNavigationBar() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.setStatusBar(backgroundColor: UIColor(hexString: "#d32323"))
        self.navigationController?.navigationBar.backgroundColor = UIColor(hexString: "#d32323")
        self.navigationController?.navigationBar.isTranslucent = true
        
        let padding = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let filterDoneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(filterDoneTapped))

        let filterToolBar = UIToolbar()
        filterToolBar.barStyle = UIBarStyle.default
        filterToolBar.isTranslucent = true
        filterToolBar.tintColor = UIColor.systemBlue
        filterToolBar.sizeToFit()
        filterToolBar.setItems([padding, filterDoneButton], animated: false)
        filterToolBar.isUserInteractionEnabled = true
        
        let filterItem = UITextField()
        filterItem.delegate = self
        filterItem.tintColor = .clear
        filterItem.borderStyle = .none
        filterItem.backgroundColor = .clear
        filterItem.leftViewMode = .always
        filterItem.leftView = UIImageView(image: UIImage(named: "filter")?.resizeImage(20.0))
        filterItem.inputView = self.filterPickerView
        filterItem.inputAccessoryView = filterToolBar
        
        self.filterPickerView.delegate = self
        self.filterPickerView.dataSource = self
        
        filterBarButton = UIBarButtonItem(customView: filterItem)
        self.navigationItem.rightBarButtonItem = self.filterBarButton
    }
    
    private func setupTableView() {
        self.businessListTableview.tableFooterView = UIView()
        self.businessListTableview.estimatedRowHeight = 50.0
        self.businessListTableview.rowHeight = UITableView.automaticDimension
        self.businessListTableview.sectionHeaderHeight = .leastNonzeroMagnitude
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
        self.searchByTextField.text = "Search by: \(self.viewModel.searchCategory.rawValue) "
        self.searchByTextField.font = UIFont(name: "Roboto-Regular", size: 13.0)
        self.searchByTextField.backgroundColor = .clear
        self.searchByTextField.rightViewMode = .always
        self.searchByTextField.rightView = UIImageView(image: UIImage(named: "dropDown")?.resizeImage(15.0))
        self.searchByTextField.inputView = self.searchByPickerView
        self.searchByTextField.tintColor = .clear
        
        self.searchByPickerView.delegate = self
        self.searchByPickerView.dataSource = self
        
        let searchToolBar = UIToolbar()
        searchToolBar.barStyle = UIBarStyle.default
        searchToolBar.isTranslucent = true
        searchToolBar.tintColor = UIColor.systemBlue
        searchToolBar.sizeToFit()

        let searchDoneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(searchDoneTapped))
        let padding = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)

        searchToolBar.setItems([padding, searchDoneButton], animated: false)
        searchToolBar.isUserInteractionEnabled = true
        self.searchByTextField.inputAccessoryView = searchToolBar
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
        
        self.viewModel.businessList.asObservable().subscribe(onNext: { [weak self] (_) in
            guard let _self = self else { return }
            _self.businessListTableview.reloadData()
            _self.businessListTableview.reloadInputViews()
        }).disposed(by: disposeBag)
    }
    
//        self.businessListTableview.rx.itemSelected.subscribe(onNext: { [weak self] (indexPath) in
//            let userDetailsVC = UserDetailsTableViewController()
//            userDetailsVC.user.accept(self!.viewModel.userList.value[indexPath.row])
//            self?.navigationController?.pushViewController(userDetailsVC, animated: true)
//        }).disposed(by: disposeBag)
    
    private func bindValues() {
        self.viewModel.setupObservables()
        
        self.searchTextField.rx.text
            .orEmpty
            .bind(to: self.viewModel.searchTextValue)
            .disposed(by: self.disposeBag)
    }
    
    @objc func searchDoneTapped() {
        if self.searchByPickerView.selectedRow(inComponent: 0) == 0 {
            self.searchByTextField.text = "Search by: \(SearchType.allCases[0].rawValue) "
        }
        self.searchByTextField.resignFirstResponder()
    }
    
    @objc func filterDoneTapped() {
        if self.filterPickerView.selectedRow(inComponent: 0) == 0 {
            self.viewModel.setFilterType(filterType: FilterType.allCases[0])
        } else {
            self.viewModel.setFilterType(filterType: FilterType.allCases[self.filterPickerView.selectedRow(inComponent: 0)])
        }
        self.filterBarButton.customView?.resignFirstResponder()
    }
}

extension BusinessListViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}

extension BusinessListViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.searchByPickerView {
            return SearchType.allCases.count
        } else {
            return FilterType.allCases.count
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == self.searchByPickerView {
            return SearchType.allCases[row].rawValue
        } else {
            return FilterType.allCases[row].rawValue
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.searchByPickerView {
            self.searchByTextField.text = "Search by: \(SearchType.allCases[row].rawValue) "
            self.viewModel.setSearchCategory(category: SearchType.allCases[row])
        }
    }
}
