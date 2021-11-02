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
    
    private var isSearching: Bool = false {
        didSet {
            if isSearching {
                placeholderLabel.text = R.string.localizable.noResults()
            } else {
                placeholderLabel.text = R.string.localizable.createContact()
            }
        }
    }
    
    private var searchText: String = "" {
        didSet {
            viewModel.filterContacts(with: searchText)
        }
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
        view.backgroundColor = .white
        setup()
        bindToViewModel()
        viewModel.loadDataFromDatabase()
    }
    
    // MARK: Actions
    @objc private func addBarButtonPressed() {
        viewModel.addContact()
    }
    
    // MARK: Private Methods
    private func bindToViewModel() {
        viewModel.didUpdateData = { [weak self] in
            self?.tableView.reloadData()
        }
        viewModel.didReceiveError = { [weak self] error in
            self?.showAlertWithError(error)
        }
        viewModel.didRemoveRow = { [weak self] indexPath in
            self?.tableView.deleteRows(at: [indexPath], with: .fade)
        }
        viewModel.didRemoveSection = { [weak self] indexPath in
            self?.tableView.deleteSections(IndexSet(integer: indexPath.section), with: .fade)
        }
    }
    
    private func setup() {
        setupNavigationController()
        setupSearchController()
        setupTableView()
        setupPlaceholderLabel()
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
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(ContactTableViewCell.self, forCellReuseIdentifier: String(describing: ContactTableViewCell.self))
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupPlaceholderLabel() {
        tableView.addSubview(placeholderLabel)
        placeholderLabel.font = .placeholder
        placeholderLabel.textColor = .secondaryTextColor
        placeholderLabel.text = R.string.localizable.createContact()
        placeholderLabel.textAlignment = .center
        placeholderLabel.numberOfLines = 0
        placeholderLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.centerY.equalToSuperview().offset(-Constants.placeholderCenterYOffset)
            make.centerX.equalToSuperview()
        }
    }
    
}

// MARK: - UITableViewDelegate
extension ContactsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        guard !isSearching else { return .none }
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteContact(at: indexPath)
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
        if numberOfSections == 0 {
            placeholderLabel.isHidden = false
        } else {
            placeholderLabel.isHidden = true
        }
        return numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.sections[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ContactTableViewCell.self))
                as? ContactTableViewCell else {
                    return UITableViewCell()
                }
        cell.configure(with: viewModel.sections[indexPath.section][indexPath.row])
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectedRowAt(indexPath)
    }
    
}

// MARK: - UISearchBarDelegate
extension ContactsListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearching = true
        self.searchText = searchText
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.discardFiltering()
        isSearching = false
    }
    
}

// MARK: - Constants
private extension Constants {
    static let placeholderCenterYOffset = CGFloat(75)
    
}
