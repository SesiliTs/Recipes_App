//
//  ImageFromURL.swift
//  Recipes App
//
//  Created by Sesili Tsikaridze on 20.01.24.
//

import UIKit
import SwiftUI

extension UIImageView {
    func load(urlString: String) {
        let compressionQuality: CGFloat = 0.1
        
        if let url = URL(string: urlString) {
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: url) {
                    if var image = UIImage(data: data) {
                        if let compressedData = image.jpegData(compressionQuality: compressionQuality) {
                            image = UIImage(data: compressedData) ?? image
                        }
                        
                        DispatchQueue.main.async {
                            self?.image = image
                        }
                    }
                }
            }
        }
    }
}
