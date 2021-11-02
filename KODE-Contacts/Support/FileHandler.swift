//
//  FileHandler.swift
//  KODE-Contacts
//
//  Created by Developer on 19.10.2021.
//

import UIKit

final class FileHandler {
    static func getSavedImage(with path: String?) -> UIImage? {
        guard let path = path else { return nil }
        return UIImage(contentsOfFile: path)
    }
    
    static func getSavedImagePath(with key: String) -> String? {
        guard let safeURL = generateImageURL(with: key),
              FileManager.default.fileExists(atPath: safeURL.path) else { return nil }
        return safeURL.path
    }
    
    static func saveImageWithKey(_ image: UIImage?, key: String) -> Bool {
        guard let safeImageURL = generateImageURL(with: key),
              let safeImage = image,
              let data = safeImage.jpegData(compressionQuality: 1) else { return false }
        
        if FileManager.default.fileExists(atPath: safeImageURL.path) {
            try? FileManager.default.removeItem(atPath: safeImageURL.path)
        }
        
        do {
            try data.write(to: safeImageURL)
            return true
        } catch {
            return false
        }
    }
    
    private static func generateImageURL(with key: String) -> URL? {
        guard let documentsDirectory = FileManager
                .default
                .urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let fileURL = documentsDirectory.appendingPathComponent(key)
        return fileURL
    }
    
}
