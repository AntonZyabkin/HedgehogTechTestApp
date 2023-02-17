//
//  SerpAPIService.swift
//  PhotoSearchApp
//
//  Created by Anton Zyabkin on 17.02.2023.
//

import Foundation
protocol SerpAPIServiceProtocol {
    
}
final class SerpAPIService{
    private let networkService: Networkable

    init(networkService: Networkable) {
        self.networkService = networkService
    }
}

extension SerpAPIService: SerpAPIServiceProtocol {
    
}
