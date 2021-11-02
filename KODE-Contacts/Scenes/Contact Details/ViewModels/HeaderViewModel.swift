//
//  HeaderViewModel.swift
//  KODE-Contacts
//
//  Created by Developer on 22.10.2021.
//

import UIKit

final class HeaderViewModel: ContactHeaderViewModel {
    let fullName: String
    let image: UIImage?
    
    init(image: UIImage?, fullName: String) {
        self.image = image ?? R.image.placeholderAvatar()
        self.fullName = fullName
    }
    
}
