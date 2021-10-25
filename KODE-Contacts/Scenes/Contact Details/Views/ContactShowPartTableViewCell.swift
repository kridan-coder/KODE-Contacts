//
//  ContactShowPartView.swift
//  KODE-Contacts
//
//  Created by Developer on 22.10.2021.
//

import UIKit

class ContactShowPartTableViewCell: UITableViewCell {
    // MARK: - Properties
    private var viewModel: ContactShowPartViewModel?
    private var view = DefaultViewCell()
    
    private var url: URL?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        createConstraints()
        initializeUI()
        addGestureRecognizer()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        createConstraints()
        initializeUI()
        addGestureRecognizer()
    }
    
    func configure(with viewModel: ContactShowPartViewModel) {
        self.viewModel = viewModel
        setupData()
        self.viewModel?.didUpdateData = {
            self.setupData()
        }
    }
    
    private func addGestureRecognizer() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedOnLink))
        gestureRecognizer.delegate = self
        view.isUserInteractionEnabled = true
        view.descriptionTextField.isUserInteractionEnabled = true
        //view.descriptionTextField.isenable
        view.descriptionTextField.addGestureRecognizer(gestureRecognizer)
    }
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    private func createConstraints() {
        contentView.addSubview(view)
        view.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(5)
        }
    }
    
    private func initializeUI() {
        view.underline?.isHidden = true
    }
    
    private func setupData() {
        view.descriptionTextField.text = viewModel?.description
        view.titleLabel.text = viewModel?.title
        guard let descriptionIsClickable = viewModel?.descriptionIsClickable,
              descriptionIsClickable else {
            return
        }

        let link = viewModel?.description ?? ""
        let range = NSRange(0..<link.count)
        let types: NSTextCheckingResult.CheckingType = [.phoneNumber, .link]
        let dataDetector = try? NSDataDetector(types: types.rawValue)
        
        dataDetector?.enumerateMatches(in: link, options: [], range: range) { match, _, _ in
            switch match?.resultType {
            case .some(let type):
                switch type {
                case .phoneNumber:
                    var myURL = URLComponents()
                    myURL.scheme = "tel"
                    myURL.path = match?.phoneNumber ?? ""
                    url = myURL.url
                default:
                    url = match?.url
                }
            case .none:
                break
            }
        }
    }
    
    @objc private func anotherFunc() {
        //
    }
    
    @objc private func tappedOnLink() {
        //
        guard let safeURL = url,
              UIApplication.shared.canOpenURL(safeURL) else { return }
        UIApplication.shared.open(safeURL)
    }
    
}
