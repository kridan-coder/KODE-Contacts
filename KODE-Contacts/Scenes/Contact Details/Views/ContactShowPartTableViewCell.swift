//
//  ContactShowPartView.swift
//  KODE-Contacts
//
//  Created by Developer on 22.10.2021.
//

import UIKit

class ContactShowPartTableViewCell: UITableViewCell {
    // MARK: - Properties
    private var viewModel: ContactShowPartViewModel?
    
    private let view = DefaultReadViewCell()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        createConstraints()
        initializeUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        createConstraints()
        initializeUI()
    }
    
    // MARK: - Public Methods
    func configure(with viewModel: ContactShowPartViewModel) {
        self.viewModel = viewModel
        setupData()
        self.viewModel?.didUpdateData = { [weak self] in
            self?.setupData()
        }
    }
    
    // MARK: - Actions
    @objc private func tappedOnLink() {
        guard let safeURL = viewModel?.descriptionURL,
              UIApplication.shared.canOpenURL(safeURL) else { return }
        UIApplication.shared.open(safeURL)
    }
    
    // MARK: - Private Methods
    private func makeDescriptionLabelClickable() {
        view.descriptionLabel.textColor = .brightBlue
        setupGestureRecognizer()
    }
    
    private func makeDescriptionLabelDefault() {
        view.descriptionLabel.textColor = .label
    }
    
    private func setupGestureRecognizer() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedOnLink))
        gestureRecognizer.delegate = self
        view.isUserInteractionEnabled = true
        view.descriptionLabel.isUserInteractionEnabled = true
        view.descriptionLabel.addGestureRecognizer(gestureRecognizer)
    }
    
    private func createConstraints() {
        contentView.addSubview(view)
        view.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(Constants.inset)
        }
    }
    
    private func initializeUI() {
        view.underline?.isHidden = true
    }
    
    private func setupData() {
        view.descriptionLabel.text = viewModel?.description
        view.titleLabel.text = viewModel?.title
        if viewModel?.descriptionURL != nil {
            makeDescriptionLabelClickable()
        } else {
            makeDescriptionLabelDefault()
        }
    }
    
}

// MARK: - Constants
private extension Constants {
    static let inset = CGFloat(5)
    
}
