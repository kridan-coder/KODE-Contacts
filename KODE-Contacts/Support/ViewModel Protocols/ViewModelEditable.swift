//
//  ViewModelEditable.swift
//  KODE-Contacts
//
//  Created by Developer on 08.11.2021.
//

import Foundation

protocol ViewModelEditable {
    var didUpdateData: (() -> Void)? { get set }
    
}
