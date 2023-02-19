//
//  NetworkService.swift
//  PhotoSearchApp
//
//  Created by Anton Zyabkin on 17.02.2023.
//

import Foundation

protocol Networkable {
    func request<T>(request: String, complition: @escaping (Result<T, Error>) -> Void) where T: Decodable
}

final class NetworkService {
    private let decoderService: DecoderServicable
    init(decoderService: DecoderServicable) {
        self.decoderService = decoderService
    }
}

enum NetworkError: Error {
    case urlError
    case responseError
    case dataError
    case unknownError
}

extension NetworkService: Networkable {
    func request<T>(request: String, complition: @escaping (Result<T, Error>) -> Void) where T: Decodable {

        let baseURL = "https://serpapi.com"
        let endpoint = "/search.json"
        
        var components = URLComponents(string: baseURL)!
        components.path = endpoint
        components.queryItems = [
            URLQueryItem(name: "q", value: request),
            URLQueryItem(name: "tbm", value: "isch"),
            URLQueryItem(name: "engine", value: "google"),
            URLQueryItem(name: "api_key", value: "ba2be5f1e1111f8e964159b3a6e261dce7245018a6940f9840dd40eb026ab9f4")
        ]
        
        guard let url = components.url else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    complition(.failure(error))
                    return
                }
                guard let data = data else { return }
                self.decoderService.decode(data, complition: complition)
            }
        }.resume()
    }
}
