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
    func previousButtonDidTap()
    func nextButtonDidTap()
    func urlString() -> String
    func siteButtonDidTap() -> WebPageViewController
}

final class FullScreenPhotoViewPresenter {
    weak var view: FullScreenPhotoViewControllerProtocol?
    private let moduleBuilder: Builder
    private let imageArray: [ImagesResult]
    private var currentCellNumber: Int
    
    init(moduleBuilder: Builder, imageArray: [ImagesResult], currentCellNumber: Int) {
        self.moduleBuilder = moduleBuilder
        self.imageArray = imageArray
        self.currentCellNumber = currentCellNumber
    }
}

extension FullScreenPhotoViewPresenter: FullScreenPhotoViewPresenterProtocol {
    func setupImage() {
        view?.imageView?.downloadImage(imageArray[currentCellNumber].original, activityIndicator: nil)
    }
    func previousButtonDidTap() {
        guard currentCellNumber > 0 else { return }
        currentCellNumber -= 1
        setupImage()
    }
    func nextButtonDidTap() {
        guard currentCellNumber < imageArray.count else { return }
        currentCellNumber += 1
        setupImage()
    }
    func urlString() -> String {
        imageArray[currentCellNumber].original
    }
    func siteButtonDidTap() -> WebPageViewController {
        moduleBuilder.buildWebPageViewController(presenter: self)
    }
}
