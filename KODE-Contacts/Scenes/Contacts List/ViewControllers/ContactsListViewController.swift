//
//  ContactsListViewController.swift
//  KODE-Contacts
//
//  Created by Developer on 11.10.2021.
//

import UIKit
import SnapKit

class ContactsListViewController: UIViewController {
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
        bindToViewModel()
        viewModel.loadDataFromDatabase()
    }
    
    // MARK: Actions
    @objc private func addBarButtonPressed() {
        viewModel.addButtonPressed()
    }
    
    // MARK: Private Methods
    
    private func bindToViewModel() {
        viewModel.didUpdateData = { [weak self] in
            self?.tableView.reloadData()
        }
    }

    private func setupSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
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
        tableView.register(TableViewContactCell.self, forCellReuseIdentifier: String(describing: TableViewContactCell.self))
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

extension ContactsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            var needsToRemoveSection = false
            do {
                if viewModel.sections[indexPath.section].1.count == 1 {
                    needsToRemoveSection = true
                }
                try viewModel.deleteContact(at: indexPath)
            } catch let error {
                showAlertWithError(error)
                return
            }
            
            if needsToRemoveSection {
                tableView.deleteSections([indexPath.section], with: .fade)
            } else {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        viewModel.titles[section]
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        viewModel.titles
    }

    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        index
    }
    
}

extension ContactsListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.sections[section].1.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TableViewContactCell.self))
                as? TableViewContactCell else {
            return UITableViewCell()
        }
        cell.configure(with: viewModel.sections[indexPath.section].1[indexPath.row])        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectedRowAt(indexPath)
    }
    
}

extension ContactsListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterContacts(with: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.discardFiltering()
    }
    
}
