//
//  ModuleBuilder.swift
//  PhotoSearchApp
//
//  Created by Anton Zyabkin on 17.02.2023.
//

import Foundation
protocol Builder {
    func configureSearchViewController(viewController: SearchViewController) -> Void
    func configureFullScreenPhotoViewController(viewController: FullScreenPhotoViewController) -> Void
}

final class ModuleBuilder {
    private let serpAPIService: SerpAPIServiceProtocol
    private let networkService: Networkable
    private let decoderService: DecoderServicable
    
    init() {
        decoderService = DecoderService()
        networkService = NetworkService(decoderService: decoderService)
        serpAPIService = SerpAPIService(networkService: networkService)
    }
}

extension ModuleBuilder: Builder {
    func configureSearchViewController(viewController: SearchViewController) -> Void {
        let presenter = SearchViewPresenter(serpAPIService: serpAPIService, moduleBuilder: self)
        presenter.view = viewController
        viewController.presenter = presenter
    }
    func configureFullScreenPhotoViewController(viewController: FullScreenPhotoViewController) -> Void {
        let presenter = FullScreenPhotoViewPresenter(moduleBuilder: self)
        presenter.view = viewController
        viewController.presenter = presenter
    }
}
