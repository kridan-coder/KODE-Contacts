//
//  TableViewContactCell.swift
//  KODE-Contacts
//
//  Created by Developer on 21.10.2021.
//

import UIKit
import SnapKit

class TableViewContactCell: UITableViewCell {
    // MARK: - Properties
    private let firstLabel = UILabel()
    private let secondLabel = UILabel()
    private let stackView = UIStackView()
    
    private var viewModel: ContactCellViewModel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initializeUI()
        createConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initializeUI() {
        stackView.alignment = .leading
        stackView.spacing = 8
        stackView.axis = .horizontal
        
        firstLabel.font = UIFont.systemFont(ofSize: 20)
        secondLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
    }
    
    private func createConstraints() {
        addSubview(stackView)
        stackView.addArrangedSubview(firstLabel)
        stackView.addArrangedSubview(secondLabel)
        
        let horizontalOffset = max(separatorInset.left, separatorInset.right)
        let verticalInset = horizontalOffset / 1.33333
        
        stackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(horizontalOffset)
            make.trailing.lessThanOrEqualToSuperview().offset(horizontalOffset)
            make.top.bottom.equalToSuperview().inset(verticalInset)
        }
        
//        firstLabel.snp.makeConstraints { make in
//            make.leading.equalToSuperview()
//            make.top.bottom.equalToSuperview()
//        }
//
//        secondLabel.snp.makeConstraints { make in
//            make.leading.equalTo(firstLabel.snp.trailing).offset(10)
//            make.top.bottom.equalToSuperview()
//        }
    }
    
    func configure(with viewModel: ContactCellViewModel) {
        self.viewModel = viewModel
        setupData()
        viewModel.didUpdateData = {
            self.setupData()
        }
    }
    
    func setupData() {
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

}
