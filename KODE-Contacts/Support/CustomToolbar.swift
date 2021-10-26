//
//  CustomToolbar.swift
//  KODE-Contacts
//
//  Created by Developer on 15.10.2021.
//

import UIKit

protocol ToolbarPickerViewDelegate: AnyObject {
    func didTapFirstButton()
    func didTapSecondButton()
}

final class CustomToolbar: UIToolbar {
    public weak var buttonsDelegate: ToolbarPickerViewDelegate?
    
    init(frame: CGRect,
         firstButtonTitle: String = R.string.localizable.next(),
         secondButtonTitle: String = R.string.localizable.done()) {
        super.init(frame: frame)
        self.commonInit(firstButtonTitle: firstButtonTitle, secondButtonTitle: secondButtonTitle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit(firstButtonTitle: String, secondButtonTitle: String) {
        let firstButton = UIBarButtonItem(title: firstButtonTitle,
                                          style: UIBarButtonItem.Style.done,
                                          target: self,
                                          action: #selector(self.didTapFirstButton))
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace,
                                          target: nil,
                                          action: nil)
        
        let secondButton = UIBarButtonItem(title: secondButtonTitle,
                                           style: UIBarButtonItem.Style.plain,
                                           target: self,
                                           action: #selector(self.didTapSecondButton))
        
        self.barStyle = UIBarStyle.default
        self.sizeToFit()
        self.isTranslucent = true
        self.tintColor = .brightBlue
        self.setItems([firstButton, spaceButton, secondButton], animated: false)
        self.isUserInteractionEnabled = true
    }
    
    @objc func didTapFirstButton() {
        self.buttonsDelegate?.didTapFirstButton()
    }
    
    @objc func didTapSecondButton() {
        self.buttonsDelegate?.didTapSecondButton()
    }
    
}
