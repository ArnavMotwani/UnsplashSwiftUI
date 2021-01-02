//
//  UnsplashObject.swift
//  UnsplashTest
//
//  Created by Arnav Motwani on 24/12/20.
//

import Foundation

class UnsplashAPI: ObservableObject {
    
    enum State {
        case loading
        case loaded(UnsplashData)
    }
    
    @Published var state = State.loading

    let url = URL(string: "https://api.unsplash.com/")!
    
    var clientId: String
    var query: String
    var orientation: String
    
    init(clientId: String, query: String = "", orientation: String = "") {
        self.clientId = clientId
        self.query = query
        self.orientation = orientation
    }
    
    func request() {
        guard var components = URLComponents(url: url.appendingPathComponent("photos/random"),
                                             resolvingAgainstBaseURL: true)
        else {
            fatalError("Couldn't append path component")
        }

        components.queryItems = [
            URLQueryItem(name: "client_id", value: clientId)
        ]
        
        if query != "" {
            components.queryItems?.append(URLQueryItem(name: "query", value: query))
        }
        
        if orientation != "" {
            components.queryItems?.append(URLQueryItem(name: "orientation", value: orientation))
        }

        let request = URLRequest(url: components.url!)

        let urlSession = URLSession(configuration: URLSessionConfiguration.default)
        urlSession.dataTask(with: request) { data, urlResponse, error in
            if let data = data {
                let decoder = JSONDecoder()
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                decoder.dateDecodingStrategy = .formatted(dateFormatter)
                do {
                    let response = try decoder.decode(UnsplashData.self, from: data)
                    DispatchQueue.main.async {
                        self.state = .loaded(response)
                    }
                } catch {
                    print(error)
                    fatalError("Couldn't decode")
                }
            } else if let error = error {
                print(error.localizedDescription)
            } else {
                fatalError("Didn't receive data")
            }
        }.resume()
    }
}
