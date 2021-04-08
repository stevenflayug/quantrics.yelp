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
    @IBOutlet weak var filterTextField: UITextField!
    
    @IBOutlet weak var businessesTableView: UITableView!
    
    private let viewModel = BusinessListViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        self.viewModel.getBusinessList()
        self.setupTableView()
        self.setupObservables()
        self.setupActions()
    }

    private func setupTableView() {
        businessesTableView.estimatedRowHeight = 50.0
        businessesTableView.rowHeight = UITableView.automaticDimension
        businessesTableView.sectionHeaderHeight = UITableView.automaticDimension
        businessesTableView.estimatedSectionHeaderHeight = 60.0
        businessesTableView.delegate = nil
        businessesTableView.dataSource = nil
        
        // Register Cell
        self.businessesTableView.register(UINib(nibName: "BusinessListCell", bundle: .main), forCellReuseIdentifier: "businessListCell")
    }
    
    private func setupActions() {
//        backButton.rx.tap.bind { [weak self] in
//            self?.navigationController?.popViewController(animated: true)
//        }.disposed(by: disposeBag)
    }
    
    private func setupObservables() {
        self.viewModel.businessList.asObservable().bind(to: businessesTableView.rx.items(cellIdentifier: "businessListCell", cellType: BusinessListCell.self)) {
            index, item, cell in
            cell.setupCell(business: item)
        }.disposed(by: disposeBag)
        
        self.viewModel.businessList.asObservable().subscribe(onNext: { [unowned self] (_) in
            self.businessesTableView.reloadData()
        }).disposed(by: disposeBag)
    }
    
//        self.businessesTableView.rx.itemSelected.subscribe(onNext: { [weak self] (indexPath) in
//            let userDetailsVC = UserDetailsTableViewController()
//            userDetailsVC.user.accept(self!.viewModel.userList.value[indexPath.row])
//            self?.navigationController?.pushViewController(userDetailsVC, animated: true)
//        }).disposed(by: disposeBag)
}
