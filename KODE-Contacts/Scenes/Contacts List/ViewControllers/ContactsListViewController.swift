//
//  ContactsListViewController.swift
//  KODE-Contacts
//
//  Created by Developer on 11.10.2021.
//

import UIKit

class ContactsListViewController: UIViewController {
    // MARK: - Properties
    private let viewModel: ContactsListViewModel
    
    private let searchController = UISearchController()
    private let tableView = UITableView()
    private let placeholderLabel = UILabel()
    
    private var isSearching: Bool {
        searchController.isActive
    }
    
    // MARK: - Init
    init(viewModel: ContactsListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
        createConstraints()
        
        setupNavigationController()
        setupSearchController()
        setupTableView()
        
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
        tableView.tableFooterView = UIView()
        tableView.register(ContactTableViewCell.self, forCellReuseIdentifier: String(describing: ContactTableViewCell.self))
    }
    
    // UI
    private func initializeUI() {
        view.backgroundColor = .white
        initializePlaceholderUI()
    }
    
    private func initializePlaceholderUI() {
        placeholderLabel.font = .placeholder
        placeholderLabel.textColor = .secondaryTextColor
        placeholderLabel.text = R.string.localizable.createContact()
        placeholderLabel.textAlignment = .center
        placeholderLabel.numberOfLines = 0
    }
    
    // Constraints
    private func createConstraints() {
        createConstraintsForTableView()
        createConstraintsForPlaceholderLabel()
    }
    
    private func createConstraintsForTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func createConstraintsForPlaceholderLabel() {
        tableView.addSubview(placeholderLabel)
        placeholderLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
    
}

// MARK: - UITableViewDelegate
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

// MARK: - UITableViewDataSource
extension ContactsListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        let numberOfSections = viewModel.sections.count
        
        if numberOfSections == 0, !isSearching {
            placeholderLabel.isHidden = false
        } else {
            placeholderLabel.isHidden = true
        }
        
        return numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.sections[section].1.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ContactTableViewCell.self))
                as? ContactTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: viewModel.sections[indexPath.section].1[indexPath.row])        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectedRowAt(indexPath)
    }
    
}

// MARK: - UISearchBarDelegate
extension ContactsListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterContacts(with: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.discardFiltering()
    }
    
}
