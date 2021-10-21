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
    private let collation = UILocalizedIndexedCollation.current()
    var orderArray: [Int] = []
    var sections: [Int: [ContactCellViewModel]] = [:]
    var objects: [CollationIndexable] = [] {
        didSet {
            sections = [:]
            orderArray = []
            let selector = #selector(getter: CollationIndexable.collationString)
//            sections = Array(repeating: [], count: collation.sectionTitles.count)
//            for item in 0..<collation.sectionTitles.count {
//                sectionTitles[item] = collation.sectionIndexTitles[item]
//            }

            let sortedObjects = collation.sortedArray(from: objects, collationStringSelector: selector)
            
            for object in sortedObjects {
                let sectionNumber = collation.section(for: object, collationStringSelector: selector)
                let contact = (object as? ContactCellViewModel
                                ?? ContactCellViewModel(data: Contact(name: "Something went wrong...",
                                                                      phoneNumber: "+6 666 666 66-66")))
                
                if sections[sectionNumber] == nil {
                    sections[sectionNumber] = []
                    orderArray.append(sectionNumber)
                }
                    sections[sectionNumber]?.append(contact)
                
                
            }
            
            // sections.removeAll { $0.isEmpty }
            self.tableView.reloadData()
        }
    }
    
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
        viewModel.reloadData()
    }
    
    // MARK: Actions
    @objc private func addBarButtonPressed() {
        viewModel.addButtonPressed()
    }
    
    // MARK: Private Methods
    
    private func bindToViewModel() {
        viewModel.didReloadData = { [weak self] in
            self?.setupObjects()
            self?.tableView.reloadData()
        }
    }
    
    private func setupObjects() {
        objects = viewModel.contacts
    }

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
            do {
                try viewModel.deleteContact(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } catch let error {
                showAlertWithError(error)
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //let titles: [Int] = sections.map {$0.key}
        
        return collation.sectionTitles[orderArray[section]]
        
        //return collation.sectionTitles[titles[section]]
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        var titles: [String]? = []
        
//        for key in sections.keys {
//            titles?.append(collation.sectionTitles[key])
//        }
        
        for item in orderArray {
            titles?.append(collation.sectionTitles[item])
        }
        
        return titles
    }

    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index
//        var value = 0
//        for itemNumber in 0..<orderArray.count where orderArray[itemNumber] == index {
//            value = itemNumber
//        }
//        return value
        
    }
    
}

extension ContactsListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[(orderArray[section])]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TableViewContactCell.self))
                as? TableViewContactCell else {
            return UITableViewCell()
        }
        cell.configure(with: sections[(orderArray[indexPath.section])]?[indexPath.row] ?? ContactCellViewModel(data: Contact(name: "Something went wrong...",
                                                                                                                                phoneNumber: "+6 666 666 66-66")))
        return cell
        
    }
    
}
