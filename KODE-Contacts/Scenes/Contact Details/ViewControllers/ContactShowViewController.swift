//
//  ContactShowViewController.swift
//  KODE-Contacts
//
//  Created by Developer on 12.10.2021.
//

import UIKit

class ContactShowViewController: UIViewController {
    // MARK: - Properties
    private let viewModel: ContactShowViewModel
    private let tableView = UITableView()
    
    // MARK: - Init
    init(viewModel: ContactShowViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bindToViewModel()
        viewModel.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.requestToCancel()
    }
    
    // MARK: - Actions
    @objc private func editContactRequest() {
        viewModel.requestToEdit()
    }
    
    // MARK: - Private Methods
    
    private func bindToViewModel() {
        viewModel.didFinishUpdating = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    private func setup() {
        setupTableView()
        setupNavigationController()
    }
    
    private func setupNavigationController() {
        let editBarButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editContactRequest))
        navigationItem.rightBarButtonItem = editBarButton
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ContactShowPartTableViewCell.self,
                           forCellReuseIdentifier: String(describing: ContactShowPartTableViewCell.self))
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}

extension ContactShowViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let viewModel = viewModel.headerViewModel else { return nil }
        let view = ContactHeaderView()
        view.configure(with: viewModel)
        return view
    }
    
}

extension ContactShowViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.showViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ContactShowPartTableViewCell.self))
                as? ContactShowPartTableViewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.configure(with: viewModel.showViewModels[indexPath.row])
        return cell
    }
    
}
