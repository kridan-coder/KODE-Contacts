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

enum CoreDataError: CustomError {
    case objectDoesNotExist
    case unhandled
}

enum ValidationError: CustomError {
    case incorrectPhoneNumber
    case repeatedPhoneNumber
    case noFirstName
    case unhandled
}

enum PermissionError: CustomError {
    case noAccessToCamera
    case noAccessToPhotos
    case unhandled
}

extension PermissionError {
    var errorTitle: String {
        switch self {
        case .noAccessToCamera:
            return R.string.localizable.noAccessToCameraErrorTitle()
        case .noAccessToPhotos:
            return R.string.localizable.noAccessToPhotosErrorTitle()
        default:
            return R.string.localizable.defaultErrorTitle()
        }
    }
}

extension CoreDataError {
    var errorTitle: String {
        switch self {
        case .objectDoesNotExist:
            return R.string.localizable.objectDoesNotExistErrorTitle()
        default:
            return R.string.localizable.defaultErrorTitle()
        }
    }
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

extension PermissionError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noAccessToCamera:
            return R.string.localizable.noAccessToCameraErrorDescription()
        case .noAccessToPhotos:
            return R.string.localizable.noAccessToPhotosErrorDescription()
        default:
            return R.string.localizable.defaultErrorDescription()
        }
    }
}

extension CoreDataError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .objectDoesNotExist:
            return R.string.localizable.objectDoesNotExistErrorDescription()
        default:
            return R.string.localizable.defaultErrorDescription()
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
