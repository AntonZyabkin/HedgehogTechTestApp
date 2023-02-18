//
//  SearchViewPresenter.swift
//  PhotoSearchApp
//
//  Created by Anton Zyabkin on 17.02.2023.
//

import Foundation
import UIKit
protocol SearchViewPresenterProtocol {
    func photoDidTaped(viewController: FullScreenPhotoViewController)
    func numberOfCells() -> Int
    func startLoadData(request: String)
    func dataForCellBy(_ indexPath: IndexPath) -> String
}

final class SearchViewPresenter {
    weak var view: SearchViewControllerProtocol?
    private let serpAPIService: SerpAPIServiceProtocol
    private let moduleBuilder: Builder
    private var imageArray: [ImagesResult] = []

    init(serpAPIService: SerpAPIServiceProtocol, moduleBuilder: Builder) {
        self.serpAPIService = serpAPIService
        self.moduleBuilder = moduleBuilder
    }
}

extension SearchViewPresenter: SearchViewPresenterProtocol {
    func numberOfCells() -> Int {
        imageArray.count
    }
    
    func startLoadData(request: String) {
        print("success DI: \(request)")
        serpAPIService.fetchPhotos(request: request) { [weak self] result in
            guard let self = self else { return }
            print(result)
            DispatchQueue.main.async {
                switch result {
                case .success(let responce):
                    self.imageArray = responce.imageResults
                    self.view?.imagesDidLoaded(result: result)
                case .failure(_):
                    self.view?.imagesDidLoaded(result: result)
                }
            }
        }
    }
    func dataForCellBy(_ indexPath: IndexPath) -> String {
        imageArray[indexPath.row].thumbnail
    }
    
    func photoDidTaped(viewController: FullScreenPhotoViewController) {
        moduleBuilder.configureFullScreenPhotoViewController(viewController: viewController)
    }
}
