//
//  TextFieldWithSeparatorView.swift
//  KODE-Contacts
//
//  Created by Developer on 29.10.2021.
//

import UIKit

final class TextFieldWithSeparatorView: UITextField {
    // MARK: - Properties
    var separatorColor: UIColor = .darkGraySeparatorColor {
        didSet {
            separatorView.backgroundColor = separatorColor
        }
    }
    
    private let separatorView = UIView()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        setupTextField()
        setupSeparator()
    }
    
    private func setupTextField() {
        self.borderStyle = .none
    }
    
    private func setupSeparator() {
        addSubview(separatorView)
        separatorView.backgroundColor = separatorColor
        separatorView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.snp.bottom)
            make.height.equalTo(1)
        }
    }
    
}
