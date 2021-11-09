//
//  ContactHeaderViewModel.swift
//  KODE-Contacts
//
//  Created by Developer on 08.11.2021.
//

import UIKit

protocol ContactHeaderViewModel: AnyObject {
    var image: UIImage? { get }
    var fullName: String { get }
    
}
