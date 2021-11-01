//
//  ShowViewModel.swift
//  KODE-Contacts
//
//  Created by Developer on 22.10.2021.
//

import Foundation

final class ShowViewModel: ContactShowPartViewModel {
    // MARK: - Properties
    var didUpdateData: (() -> Void)?
    var didAskToOpenLink: ((URL?) -> Void)?
    var title: String
    var description: String
    var descriptionHasLink: Bool = false
    var descriptionURL: URL?
    
    // MARK: - Init
    init(title: String, description: String) {
        self.title = title
        self.description = description
        validateForLink()
    }
    
    // MARK: - Public Methods
    func openLink() {
        didAskToOpenLink?(descriptionURL)
    }
    
    // MARK: - Private Methods
    private func validateForLink() {
        let range = NSRange(0..<description.count)
        let types: NSTextCheckingResult.CheckingType = [.phoneNumber, .link]
        let dataDetector = try? NSDataDetector(types: types.rawValue)
        
        dataDetector?.enumerateMatches(in: description, options: [], range: range) { match, _, _ in
            switch match?.resultType {
            case .some(let type):
                descriptionHasLink = true
                switch type {
                case .phoneNumber:
                    var myURL = URLComponents()
                    myURL.scheme = "tel"
                    myURL.path = match?.phoneNumber ?? ""
                    descriptionURL = myURL.url
                default:
                    descriptionURL = match?.url
                }
            case .none:
                descriptionHasLink = false
            }
        }
    }
    
}
