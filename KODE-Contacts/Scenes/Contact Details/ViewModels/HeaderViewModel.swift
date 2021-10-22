//
//  HeaderViewModel.swift
//  KODE-Contacts
//
//  Created by Developer on 22.10.2021.
//

import UIKit

final class HeaderViewModel: ViewModel {
    var didUpdateData: (() -> Void)?
    
    var fullName: String
    var image: UIImage
    
    init(image: UIImage, fullName: String) {
        self.image = image
        self.fullName = fullName
    }
}
