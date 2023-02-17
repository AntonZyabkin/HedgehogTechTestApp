//
//  SearchViewPresenter.swift
//  PhotoSearchApp
//
//  Created by Anton Zyabkin on 17.02.2023.
//

import Foundation

protocol SearchViewPresenterProtocol {
    func test()
}

final class SearchViewPresenter {
    weak var view: SearchViewControllerProtocol?
    private let serpAPIService: SerpAPIServiceProtocol
    private let moduleBuilder: Builder

    init(serpAPIService: SerpAPIServiceProtocol, moduleBuilder: Builder) {
        self.serpAPIService = serpAPIService
        self.moduleBuilder = moduleBuilder
    }
}

extension SearchViewPresenter: SearchViewPresenterProtocol {
    func test() {
        print("success DI")
    }
}
