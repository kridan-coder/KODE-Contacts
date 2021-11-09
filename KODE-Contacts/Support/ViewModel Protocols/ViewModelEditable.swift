//
//  ViewModelEditable.swift
//  KODE-Contacts
//
//  Created by Developer on 08.11.2021.
//

import Foundation

protocol ViewModelEditable: AnyObject {
    var didUpdateData: (() -> Void)? { get set }
    
}
