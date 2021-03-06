//
//  BusinessListViewController.swift
//  Yelp Locator
//
//  Created by Steven Layug on 8/04/21.
//

import UIKit
import RxSwift
import RxCocoa
import PKHUD

class BusinessListViewController: UIViewController {
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchByTextField: UITextField!
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var businessListTableview: UITableView!
    @IBOutlet weak var emptyImageView: UIImageView!
    
    private var refreshControl = UIRefreshControl()
    private var filterBarButton = UIBarButtonItem()
    private var searchByPickerView = UIPickerView()
    private var filterPickerView = UIPickerView()

    private let viewModel = BusinessListViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        HUD.dimsBackground = false
        self.setupNavigationBar()
        self.setupTableView()
        self.setupViews()
        self.setupObservables()
        self.bindValues()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !self.viewModel.initialLoadDone {
            HUD.show(.rotatingImage(UIImage(named: "yelpIcon")?.resizeImage(75.0)), onView: self.view)
            self.viewModel.startBusinessListRequest(filterBy: .none)
        }
    }

    private func setupNavigationBar() {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.white
        titleLabel.font = .primaryFontSemiBold(size: 15)
        titleLabel.text = "Businesses Near Me"
        titleLabel.frame = CGRect(x: 0, y: 0, width: 60, height: 34)
        self.navigationItem.titleView = titleLabel
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.setStatusBar(backgroundColor: .primaryColor)
        self.navigationController?.navigationBar.backgroundColor = .primaryColor
        self.navigationController?.navigationBar.isTranslucent = true
        
        let padding = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let filterDoneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(filterDoneTapped))
        filterDoneButton.tintColor = .primaryColor

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
        
        self.searchView.backgroundColor = .clear
        self.view.backgroundColor = .backgroundColor
        
        businessListTableview.layer.cornerRadius = 8.0
        
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(reloadBusinessList), for: .valueChanged)
        self.businessListTableview.addSubview(refreshControl)
        
        // Register Cell
        self.businessListTableview.register(UINib(nibName: "BusinessListCell", bundle: .main), forCellReuseIdentifier: "businessListCell")
    }
    
    func setupViews() {
        self.searchByTextField.delegate = self
        self.searchByTextField.borderStyle = .none
        self.searchByTextField.text = "Search by: \(self.viewModel.searchCategory.rawValue) "
        self.searchByTextField.font = .primaryFont(size: 13)
        self.searchByTextField.backgroundColor = .clear
        self.searchByTextField.rightViewMode = .always
        self.searchByTextField.rightView = UIImageView(image: UIImage(named: "dropDown")?.resizeImage(15.0))
        self.searchByTextField.inputView = self.searchByPickerView
        self.searchByTextField.tintColor = .clear
        self.searchByTextField.leftViewMode = .always
        
        self.searchTextField.clearButtonMode = .whileEditing
        self.searchTextField.leftView = UIImageView(image: UIImage(named: "search")?.resizeImage(25.0).withTintColor(.lightGray))
        self.searchTextField.leftViewMode = .always
        self.searchTextField.placeholder = "Search Businesses"
        self.searchTextField.delegate = self
        
        self.searchByPickerView.delegate = self
        self.searchByPickerView.dataSource = self
        
        let searchToolBar = UIToolbar()
        searchToolBar.barStyle = UIBarStyle.default
        searchToolBar.isTranslucent = true
        searchToolBar.tintColor = UIColor.systemBlue
        searchToolBar.sizeToFit()

        let searchDoneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(searchDoneTapped))
        searchDoneButton.tintColor = .primaryColor
        let padding = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)

        searchToolBar.setItems([padding, searchDoneButton], animated: false)
        searchToolBar.isUserInteractionEnabled = true
        self.searchByTextField.inputAccessoryView = searchToolBar
        
        self.emptyImageView.image = UIImage(named: "emptyImage")
        self.emptyImageView.isHidden = false
        self.emptyImageView.contentMode = .center
        
        self.businessListTableview.isHidden = true
    }
    
    private func setupObservables() {
        self.viewModel.businessList.asObservable().bind(to: businessListTableview.rx.items(cellIdentifier: "businessListCell", cellType: BusinessListCell.self)) {
            index, item, cell in
            cell.setupCell(business: item)
        }.disposed(by: disposeBag)
        
        self.viewModel.businessList.asObservable().subscribe(onNext: { [weak self] in
            guard let _self = self else { return }
            HUD.hide(animated: true)
            
            if $0.isEmpty {
                _self.businessListTableview.isHidden = true
                _self.emptyImageView.isHidden = false
            } else {
                _self.businessListTableview.isHidden = false
                _self.emptyImageView.isHidden = true
            }
            
            _self.businessListTableview.reloadData()
            _self.businessListTableview.reloadInputViews()
            _self.refreshControl.endRefreshing()
        }).disposed(by: disposeBag)
        
        self.businessListTableview.rx.itemSelected.subscribe(onNext: { [weak self] (indexPath) in
            guard let _self = self else { return }
            let businessDetailsVC = BusinessDetailsViewController(businessId: _self.viewModel.businessList.value[indexPath.row].alias ?? "")
            _self.navigationController?.pushViewController(businessDetailsVC, animated: true)
        }).disposed(by: disposeBag)
        
        viewModel.errorMessage.asObservable().subscribe(onNext: { (error) in
            if error != "" {
                HUD.flash(.labeledError(title: "Business List Service Error", subtitle: error), onView: self.view, delay: 1, completion: nil)
            }
        }).disposed(by: disposeBag)
    }
    
    private func bindValues() {
        self.searchTextField.rx.text
            .orEmpty
            .bind(to: self.viewModel.searchTextValue)
            .disposed(by: self.disposeBag)
    }
    
    @objc func searchDoneTapped() {
        if self.searchByPickerView.selectedRow(inComponent: 0) == 0 {
            self.searchByTextField.text = "Search by: \(self.viewModel.searchTypes[0].rawValue) "
        }
        
        self.viewModel.clearSearchValue()
        self.searchTextField.text = ""
        self.reloadBusinessList()
        self.searchByTextField.resignFirstResponder()
    }
    
    @objc func filterDoneTapped() {
        if self.viewModel.filterTypes[self.filterPickerView.selectedRow(inComponent: 0)] != self.viewModel.filterType {
            HUD.show(.rotatingImage(UIImage(named: "yelpIcon")?.resizeImage(75.0)), onView: self.view)
            
            if self.filterPickerView.selectedRow(inComponent: 0) == 0 {
                self.viewModel.setFilterType(filterType: self.viewModel.filterTypes[0])
            } else {
                self.viewModel.setFilterType(filterType: self.viewModel.filterTypes[self.filterPickerView.selectedRow(inComponent: 0)])
            }
        }
        
        self.filterBarButton.customView?.resignFirstResponder()
    }
    
    @objc func reloadBusinessList() {
        HUD.show(.rotatingImage(UIImage(named: "yelpIcon")?.resizeImage(75.0)), onView: self.view)
        self.viewModel.startBusinessListRequest(filterBy: self.viewModel.filterTypes[self.filterPickerView.selectedRow(inComponent: 0)])
    }
}

extension BusinessListViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.searchByTextField {
            return false
        } else {
            return true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.searchTextField {
            HUD.show(.rotatingImage(UIImage(named: "yelpIcon")?.resizeImage(75.0)), onView: self.view)
            self.viewModel.startBusinessListRequest(filterBy: self.viewModel.filterType)
        }
    }
}

extension BusinessListViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.searchByPickerView {
            return self.viewModel.searchTypes.count
        } else {
            return self.viewModel.filterTypes.count
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == self.searchByPickerView {
            return self.viewModel.searchTypes[row].rawValue
        } else {
            return self.viewModel.filterTypes[row].rawValue
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.searchByPickerView {
            self.searchByTextField.text = "Search by: \(self.viewModel.searchTypes[row].rawValue) "
            self.viewModel.setSearchCategory(category: self.viewModel.searchTypes[row])
        }
    }
}
