//
//  ContactShowViewController.swift
//  KODE-Contacts
//
//  Created by Developer on 12.10.2021.
//

import UIKit

class ContactShowViewController: UIViewController {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createConstraints()
        bindToViewModel()
        setupTableView()
        setupNavigationController()
        viewModel.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.requestToCancel()
    }
    
    // MARK: - Private Methods
    
    private func createConstraints() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupNavigationController() {
        let editBarButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editContactRequest))
        navigationItem.rightBarButtonItem = editBarButton
    }
    
    @objc private func editContactRequest() {
        viewModel.requestToEdit()
    }
    
    private func setupTableView() {
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ContactShowPartTableViewCell.self,
                           forCellReuseIdentifier: String(describing: ContactShowPartTableViewCell.self))
    }
    
    private func bindToViewModel() {
        viewModel.didFinishUpdating = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
}

extension ContactShowViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = ContactHeaderView()
        view.configure(with: viewModel.headerViewModel)
        view.layoutIfNeeded()
        view.initializeUI()
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 175
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
