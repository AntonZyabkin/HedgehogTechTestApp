//
//  UIImageView.swift
//  PhotoSearchApp
//
//  Created by Anton Zyabkin on 18.02.2023.
//

import Foundation
import UIKit

var imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    func downloadImage(_ urlString: String, activityIndicator: UIActivityIndicatorView?) {
        DispatchQueue.global().async {
            if let cachedImage = imageCache.object(forKey: urlString as NSString) {
                DispatchQueue.main.async {
                    self.image = cachedImage
                    activityIndicator?.stopAnimating()
                }
                return
            }
            
            guard let url = URL(string: urlString),
                  let data = try? Data(contentsOf: url),
                  let image = UIImage(data: data)
            else { return }
            
            DispatchQueue.main.async {
                self.image = image
                imageCache.setObject(image, forKey: urlString as NSString)
                activityIndicator?.stopAnimating()
            }
        }
    }
}
