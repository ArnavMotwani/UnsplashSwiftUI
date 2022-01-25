//
//  FetchImage.swift
//  
//
//  Created by Arnav Motwani on 1/14/22.
//

import SwiftUI

@MainActor
class UnsplashApi: ObservableObject {
    enum LoadingState {
        case idle
        case loading
        case loaded(UnsplashData)
        case failed(Error)
    }
    
    @Published var state: LoadingState = .idle
    
    func fetchImage(clientId: String, query: String, orientation: String) async {
        let baseUrl = URL(string: "https://api.unsplash.com/")
        guard var components = URLComponents(url: baseUrl!.appendingPathComponent("photos/random"), resolvingAgainstBaseURL: true)
        else { state = .failed(URLError(.badURL)); return }
        components.queryItems = [URLQueryItem(name: "client_id", value: clientId)]
        if query != "" {components.queryItems?.append(URLQueryItem(name: "query", value: query))}
        if orientation != "" {components.queryItems?.append(URLQueryItem(name: "orientation", value: orientation))}
        guard let url = components.url else { state = .failed(URLError(.badURL)); return }
        self.state = .loading
        do {
            let (data, _) = try await URLSession(configuration: .ephemeral).data(from: url)
            let response = try JSONDecoder().decode(UnsplashData.self, from: data)
            self.state = .loaded(response)
        } catch {
            state = .failed(error)
        }
    }
}
