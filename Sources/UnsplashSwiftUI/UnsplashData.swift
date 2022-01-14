//
//  UnsplashData.swift
//  UnsplashTest
//
//  Created by Arnav Motwani on 24/12/20.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let unsplashData = try? newJSONDecoder().decode(UnsplashData.self, from: jsonData)

import Foundation

// MARK: - UnsplashData
struct UnsplashData: Codable {
    let id: String
    let urls: Urls
    let links: UnsplashDataLinks
    let user: User

    enum CodingKeys: String, CodingKey {
        case id
        case urls, links
        case user
    }
}

// MARK: - UnsplashDataLinks
struct UnsplashDataLinks: Codable {
    let linksSelf, html, download, downloadLocation: String

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case html, download
        case downloadLocation = "download_location"
    }
}

// MARK: - Urls
struct Urls: Codable {
    let raw, full, regular, small: String
    let thumb: String
}

// MARK: - User
struct User: Codable {
    let id: String
    let username, name, firstName, lastName: String

    enum CodingKeys: String, CodingKey {
        case id
        case username, name
        case firstName = "first_name"
        case lastName = "last_name"
    }
}
