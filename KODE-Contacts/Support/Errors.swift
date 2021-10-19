//
//  Errors.swift
//  KODE-Weather
//
//  Created by Developer on 28.09.2021.
//

import Foundation

protocol CustomError: Error {
    var errorTitle: String { get }
}

enum ValidationError: CustomError {
    case incorrectPhoneNumber
    case repeatedPhoneNumber
    case noFirstName
}

extension ValidationError {
    var errorTitle: String {
        switch self {
        case .incorrectPhoneNumber:
            return R.string.localizable.incorrectPhoneNumberErrorTitle()
        case .repeatedPhoneNumber:
            return R.string.localizable.repeatedPhoneNumberErrorTitle()
        case .noFirstName:
            return R.string.localizable.noFirstNameErrorTitle()
        default:
            return R.string.localizable.defaultErrorTitle()
        }
    }
    
}

extension ValidationError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .incorrectPhoneNumber:
            return R.string.localizable.incorrectPhoneNumberErrorDescription()
        case .repeatedPhoneNumber:
            return R.string.localizable.repeatedPhoneNumberErrorDescription()
        case .noFirstName:
            return R.string.localizable.noFirstNameErrorDescription()
        default:
            return R.string.localizable.defaultErrorDescription()
        }
    }
    
}
