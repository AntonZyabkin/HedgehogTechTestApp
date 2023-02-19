//
//  PhotoCollectionViewCell.swift
//  PhotoSearchApp
//
//  Created by Anton Zyabkin on 18.02.2023.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    static let identifier = "PhotoCollectionViewCell"
    var imageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage()
        imageView.image = image
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.frame.size = frame.size
        layer.masksToBounds = true
        contentView.addSubview(imageView)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    func configureCell(url: String) {
        imageView.downloadImage(url, activityIndicator: nil)
    }
}
