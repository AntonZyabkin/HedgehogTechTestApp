//
//  SerpPhotoResponse.swift
//  PhotoSearchApp
//
//  Created by Anton Zyabkin on 17.02.2023.
//

import Foundation

struct SerpPhotoResponse: Codable {
    let imageResults: [ImagesResult]
    
    enum CodingKeys: String, CodingKey {
        case imageResults = "images_results"
    }
}

struct ImagesResult: Codable {
    let thumbnail: String
    let link: String
    let original: String
}
struct Post: Codable {
    let userId: Int
    let postId: Int
    let title: String
    let body: String
    
    
    enum CodingKeys: String, CodingKey {
        case userId = "userId"
        case postId = "id"
        case title = "title"
        case body = "body"
    }
}
