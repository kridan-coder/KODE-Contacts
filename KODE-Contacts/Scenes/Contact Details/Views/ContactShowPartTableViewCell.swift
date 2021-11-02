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
    
    private let view = InfoView()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    // MARK: - Public Methods
    func configure(with viewModel: ContactShowPartViewModel) {
        self.viewModel = viewModel
        setupData()
    }
    
    // MARK: - Actions
    @objc private func tappedOnLink() {
        viewModel?.openLink()
    }
    
    // MARK: - Private Methods
    private func setup() {
        createConstraints()
    }
    
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
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview().inset(Constants.inset)
            make.top.bottom.equalToSuperview().inset(Constants.inset)
        }
    }
    
    private func setupData() {
        guard let viewModel = viewModel else { return }
        view.descriptionLabel.text = viewModel.description
        view.titleLabel.text = viewModel.title
        if viewModel.descriptionHasLink {
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
