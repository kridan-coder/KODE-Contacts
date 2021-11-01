//
//  ContactTableViewHeader.swift
//  KODE-Contacts
//
//  Created by Developer on 12.10.2021.
//

import UIKit

class ContactHeaderView: UIView {
    // MARK: - Properties
    private var viewModel: HeaderViewModel?
    
    private let contactImageView = UIImageView()
    private let fullNameLabel = UILabel()
    
    // MARK: - Init
    init() {
        super.init(frame: CGRect.zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overrides
    override func layoutSubviews() {
        super.layoutSubviews()
        setupDynamicUI()
    }
    
    // MARK: - Public Methods
    func configure(with viewModel: HeaderViewModel) {
        self.viewModel = viewModel
        setupData()
        self.viewModel?.didUpdateData = {
            self.setupData()
        }
    }
    
    // MARK: - Private Methods
    private func setupDynamicUI() {
        layoutIfNeeded()
        contactImageView.layer.cornerRadius = contactImageView.bounds.width / 2
        let layer = CALayer()
        layer.backgroundColor = UIColor.almostWhite.cgColor
        layer.frame = CGRect(x: 0, y: -Constants.layerSize, width: Constants.layerSize, height: Constants.layerSize)
        self.layer.addSublayer(layer)
    }
    
    private func setup() {
        initializeUI()
        createConstraints()
    }
    
    private func setupData() {
        fullNameLabel.text = viewModel?.fullName
        if let image = viewModel?.image {
            contactImageView.image = image
        }
    }
    
    private func initializeUI() {
        backgroundColor = .almostWhite
        contactImageView.clipsToBounds = true
        fullNameLabel.font = .header
        fullNameLabel.textAlignment = .center
        fullNameLabel.numberOfLines = 0
    }
    
    private func createConstraints() {
        addSubview(contactImageView)
        addSubview(fullNameLabel)
        
        contactImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Constants.defaultInset)
            make.width.equalTo(contactImageView.snp.height)
            make.width.equalToSuperview().dividedBy(Constants.division)
            make.centerX.equalToSuperview()
        }
        
        fullNameLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Constants.bigInset)
            make.top.equalTo(contactImageView.snp.bottom).offset(Constants.defaultInset)
            make.bottom.equalToSuperview().inset(Constants.defaultInset)
        }
    }
    
}

// MARK: - Constants
private extension Constants {
    static let defaultInset = CGFloat(15)
    static let bigInset = CGFloat(40)
    static let division = CGFloat(4)
    static let layerSize = CGFloat(1000)
    
}
