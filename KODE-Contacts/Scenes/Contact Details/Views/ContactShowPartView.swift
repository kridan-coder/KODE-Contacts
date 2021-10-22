//
//  ContactShowPartView.swift
//  KODE-Contacts
//
//  Created by Developer on 22.10.2021.
//

import UIKit

class ContactShowPartView: DefaultCellView {
    // MARK: - Properties
    private var viewModel: ContactShowPartViewModel?
    func configure(with viewModel: ContactShowPartViewModel) {
        self.viewModel = viewModel
        setupData()
        self.viewModel?.didUpdateData = {
            self.setupData()
        }
    }
    
    private func setupData() {
        descriptionTextField.text = viewModel?.description
        titleLabel.text = viewModel?.title
        guard let descriptionIsClickable = viewModel?.descriptionIsClickable,
              descriptionIsClickable else { return }
        let gestureRecognizer = UIGestureRecognizer(target: self, action: #selector(tappedOnLink))
        descriptionTextField.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc private func tappedOnLink() {
        let tel = "tel://"
        let link = tel + (viewModel?.description ?? "")
        guard let url = URL(string: link),
              UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url)
    }
    
}
