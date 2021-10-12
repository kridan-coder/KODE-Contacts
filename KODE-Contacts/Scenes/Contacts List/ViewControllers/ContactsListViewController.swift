//
//  ContactsListViewController.swift
//  KODE-Contacts
//
//  Created by Developer on 11.10.2021.
//

import UIKit
import SnapKit

class ContactsListViewController: UIViewController, UISearchBarDelegate {
    // MARK: - Properties
    private let viewModel: ContactsListViewModel
    
    private let searchController: UISearchController
    private let tableView: UITableView
    
    // MARK: - Init
    init(viewModel: ContactsListViewModel) {
        self.viewModel = viewModel
        
        searchController = UISearchController()
        tableView = UITableView()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
        setupSearchController()
        setupTableView()
        
        setupView()
    }
    
    // MARK: Actions
    @objc private func addBarButtonPressed() {
        viewModel.addButtonPressed()
    }
    
    // MARK: Private Methods
    private func setupSearchController() {
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
    }
    
    private func setupNavigationController() {
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonPressed))
        navigationItem.rightBarButtonItem = addBarButton
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // UI
    private func setupView() {
        view.backgroundColor = .white
        setupTableViewUI()
    }
    
    private func setupTableViewUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}

extension ContactsListViewController: UITableViewDelegate {}

extension ContactsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
}
