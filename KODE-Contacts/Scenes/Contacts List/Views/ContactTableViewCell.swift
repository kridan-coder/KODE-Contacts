//
//  TableViewContactCell.swift
//  KODE-Contacts
//
//  Created by Developer on 21.10.2021.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    // MARK: - Properties
    private let firstLabel = UILabel()
    private let secondLabel = UILabel()
    private let stackView = UIStackView()
    
    private var viewModel: ContactCellViewModel?
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initializeUI()
        createConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func configure(with viewModel: ContactCellViewModel) {
        self.viewModel = viewModel
        setupData()
        viewModel.didUpdateData = { [weak self] in
            self?.setupData()
        }
    }
    
    // MARK: - Private Methods
    private func setupData() {
        guard viewModel?.data.lastName != nil else {
            firstLabel.text = nil
            firstLabel.isHidden = true
            secondLabel.text = viewModel?.data.name
            return
        }
        firstLabel.isHidden = false
        firstLabel.text = viewModel?.data.name
        secondLabel.text = viewModel?.data.lastName
    }
    
    private func initializeUI() {
        stackView.alignment = .leading
        stackView.spacing = Constants.StackView.spacing
        stackView.axis = .horizontal
        
        firstLabel.font = .contactName
        secondLabel.font = .contactLastName
    }
    
    private func createConstraints() {
        addSubview(stackView)
        stackView.addArrangedSubview(firstLabel)
        stackView.addArrangedSubview(secondLabel)
        
        let horizontalOffset = max(separatorInset.left, separatorInset.right)
        let verticalInset = horizontalOffset / Constants.StackView.quotient
        
        stackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(horizontalOffset)
            make.trailing.lessThanOrEqualToSuperview().offset(horizontalOffset)
            make.top.bottom.equalToSuperview().inset(verticalInset)
        }
    }
    
}

// MARK: - Constants
private extension Constants {
    struct StackView {
        static let spacing = CGFloat(8)
        static let quotient = CGFloat(4 / 3)
    }
}
