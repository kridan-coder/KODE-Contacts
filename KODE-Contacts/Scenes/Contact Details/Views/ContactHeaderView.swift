//
//  ContactTableViewHeader.swift
//  KODE-Contacts
//
//  Created by Developer on 12.10.2021.
//

import UIKit
import SnapKit

class ContactHeaderView: UIView {
    // MARK: - Properties
    private let contactImageView = UIImageView()
    private let fullNameLabel = UILabel()
    
    private var viewModel: HeaderViewModel?
    
    // MARK: - Init
    init() {
        super.init(frame: CGRect.zero)
        initializeUI()
        createConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configure(with viewModel: HeaderViewModel) {
        self.viewModel = viewModel
        setupData()
        self.viewModel?.didUpdateData = {
            self.setupData()
        }
    }
    
    func setupData() {
        contactImageView.image = viewModel?.image
        fullNameLabel.text = viewModel?.fullName
    }
    
    // MARK: - Private Methods
    private func initializeUI() {
        fullNameLabel.font = UIFont.systemFont(ofSize: 40)
    }
    
    private func createConstraints() {
        addSubview(contactImageView)
        addSubview(fullNameLabel)
        
        contactImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.width.equalTo(contactImageView.snp.height)
            make.width.equalToSuperview().dividedBy(4.36)
            make.centerX.equalToSuperview()
        }
        
        fullNameLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(40)
            make.top.equalTo(fullNameLabel.snp.bottom).offset(15)
            make.bottom.equalToSuperview().inset(15)
        }
    }
}
