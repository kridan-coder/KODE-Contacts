//
//  ViewModel.swift
//  KODE-Contacts
//
//  Created by Developer on 15.10.2021.
//

import Foundation

protocol ViewModel {
    var didUpdateData: (() -> Void)? { get set }
    
}

protocol ContactShowPartViewModel: ViewModel {
    var title: String { get set }
    var description: String { get set }
    var descriptionURL: URL? { get set }
    
}

protocol ContactCreateRedactPartViewModel: ViewModel {
    var didAskToFocusNextTextField: (() -> Void)? { get set }
    
}

protocol ContactCreateRedactPartViewModel1: ContactCreateRedactPartViewModel {
    var data: PartView1Data { get set }
    var didAskToShowImagePicker: (() -> Void)? { get set }
    var didFillNeededField: (() -> Void)? { get set }
    var didEmptyNeededField: (() -> Void)? { get set }
}

protocol ContactCreateRedactPartViewModel2: ContactCreateRedactPartViewModel {
    var data: PartView2Data { get set }
    
}

protocol ContactCreateRedactPartViewModel3: ContactCreateRedactPartViewModel {
    var data: PartView3Data { get set }
    
}
