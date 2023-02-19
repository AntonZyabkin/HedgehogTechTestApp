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
            URLQueryItem(name: "api_key", value: "0a35bb0f097de4b756d939e31557b83e9fcbe1d6d340cd482146c1e6e1651923")
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
