//
//  TableViewContactCell.swift
//  KODE-Contacts
//
//  Created by Developer on 21.10.2021.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    // MARK: - Properties
    private var viewModel: ContactCellViewModel?
    
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
    func configure(with viewModel: ContactCellViewModel) {
        self.viewModel = viewModel
        setupData()
        viewModel.didUpdateData = { [weak self] in
            self?.setupData()
        }
    }
    
    // MARK: - Private Methods
    private func setupData() {
        guard let viewModel = viewModel else { return }
        let fullName = viewModel.contact.fullName
        
        let boldTextRange = (fullName as NSString).range(of: viewModel.contact.lastName ?? viewModel.contact.name)
        
        let attributedString = NSMutableAttributedString(string: fullName,
                                                         attributes: [NSAttributedString.Key.font: UIFont.contactName])
        
        attributedString.setAttributes([NSAttributedString.Key.font: UIFont.contactLastName], range: boldTextRange)
        
        label.attributedText = attributedString
    }
    
    private func setupLabel() {
        addSubview(label)
        
        let horizontalInset = max(separatorInset.left, separatorInset.right)
        let verticalInset = horizontalInset / Constants.StackView.quotient
        
        label.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(horizontalInset)
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
