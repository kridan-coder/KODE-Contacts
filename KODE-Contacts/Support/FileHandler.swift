//
//  FileHandler.swift
//  KODE-Contacts
//
//  Created by Developer on 19.10.2021.
//

import UIKit

final class FileHandler {
    static func saveImageAndReturnFilePath(_ image: UIImage?, with key: String) -> String? {
        guard let safeImage = image,
              let documentsDirectory = FileManager.default.urls(for: .documentDirectory,
                                                                in: .userDomainMask).first else { return nil }
        let fileName = key
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        guard let data = safeImage.jpegData(compressionQuality: 1) else { return nil }
        if FileManager.default.fileExists(atPath: fileURL.path) {
            try? FileManager.default.removeItem(atPath: fileURL.path)
        }
        do {
            try data.write(to: fileURL)
            return fileURL.path
        } catch _ {
            return nil
        }
    }
    
    static func getSavedImage(with path: String) -> UIImage? {
        return UIImage(contentsOfFile: path)
    }
    
}
