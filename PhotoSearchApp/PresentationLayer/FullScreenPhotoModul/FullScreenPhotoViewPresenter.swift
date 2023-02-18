//
//  FullScreenPhotoViewPresenter.swift
//  PhotoSearchApp
//
//  Created by Anton Zyabkin on 18.02.2023.
//

import Foundation
import UIKit
protocol FullScreenPhotoViewPresenterProtocol {
    func setupImage()
    var image: UIImage { get set }
}

final class FullScreenPhotoViewPresenter {
    weak var view: FullScreenPhotoViewControllerProtocol?
    private let moduleBuilder: Builder
    var image: UIImage = UIImage()

    init(moduleBuilder: Builder) {
        self.moduleBuilder = moduleBuilder
    }

}

extension FullScreenPhotoViewPresenter: FullScreenPhotoViewPresenterProtocol {
    func setupImage() {
        view?.imageView?.image = image
    }
}
