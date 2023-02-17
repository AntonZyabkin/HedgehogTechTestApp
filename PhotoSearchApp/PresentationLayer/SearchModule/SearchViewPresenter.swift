//
//  SearchViewPresenter.swift
//  PhotoSearchApp
//
//  Created by Anton Zyabkin on 17.02.2023.
//

import Foundation

protocol SearchViewPresenterProtocol {}

final class SearchViewPresenter {
    weak var view: SearchViewControllerProtocol?
    private let serpAPIService: SerpAPIServiceProtocol
    
    init(serpAPIService: SerpAPIServiceProtocol) {
        self.serpAPIService = serpAPIService
    }
}

extension SearchViewPresenter: SearchViewPresenterProtocol {}
