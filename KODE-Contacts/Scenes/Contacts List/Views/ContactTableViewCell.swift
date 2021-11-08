//
//  TableViewContactCell.swift
//  KODE-Contacts
//
//  Created by Developer on 21.10.2021.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    // MARK: - Properties
    private var viewModel: CellViewModel?
    
    private let label = UILabel()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func configure(with viewModel: CellViewModel) {
        self.viewModel = viewModel
        setupData()
        viewModel.didUpdateData = { [weak self] in
            self?.setupData()
        }
    }
    
    // MARK: - Private Methods
    private func setupData() {
        guard let viewModel = viewModel else { return }
        label.attributedText = viewModel.attributedString
    }
    
    private func setupLabel() {
        addSubview(label)
        label.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Constants.horizontalInset)
            make.top.bottom.equalToSuperview().inset(Constants.verticalInset)
        }
    }
    
}

// MARK: - Constants
private extension Constants {
    static let horizontalInset = CGFloat(20)
    static let verticalInset = CGFloat(11.25)
    struct StackView {
        static let spacing = CGFloat(8)
        static let quotient = CGFloat(4 / 3)
    }
    
}
