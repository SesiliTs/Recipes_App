//
//  ImageFromURL.swift
//  Recipes App
//
//  Created by Sesili Tsikaridze on 20.01.24.
//

import UIKit
import SwiftUI

var imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    func load(urlString: String) {
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            self.image = cachedImage
            return
        }
        
        URLSession.shared.invalidateAndCancel()
        
        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
                guard let self = self else { return }
                if error != nil {
                    print("Failed to load image:", error?.localizedDescription ?? "")
                    return
                }
                
                guard let data = data, let image = UIImage(data: data) else { return }
                
                imageCache.setObject(image, forKey: urlString as NSString)
                
                DispatchQueue.main.async {
                    self.image = image
                }
            }
            task.resume()
        }
    }
}
