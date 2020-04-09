//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation
import Combine

public enum AppStoreServiceError: LocalizedError {
    case httpStatusCode(Int)
    case invalidData
    case missingKey

    public var errorDescription: String? {
        switch self {
        case .httpStatusCode(let statusCode):
            return "HTTP request failed with status code \(statusCode)."
        case .invalidData:
            return "The data is invalid."
        case .missingKey:
            return "The key is missing."
        }
    }
}

public class AppStoreService {

    public let baseURL = URL(validString: "https://api.appstoreconnect.apple.com/v1")
    
    public let configuration: AppStoreAPIConfiguration
    
    public init(configuration: AppStoreAPIConfiguration) {
        self.configuration = configuration
    }
}

extension AppStoreService {
    
    internal func getJSON<T: Decodable>(_ endpoint: String, parameters: [String: Any] = [:]) throws -> AnyPublisher<T, Error> {
        
        let bearerToken = try Self.makeBearerToken(configuration: configuration)
        
        let url = URLBuilder.buildURL(baseURL, endpoint, parameters)
        var urlRequest = URLRequest(url: url,
                                    cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                    timeoutInterval: 60)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap { (data, response) in
                if let response = response as? HTTPURLResponse {
                    guard 200...299 ~= response.statusCode else {
                        throw AppStoreServiceError.httpStatusCode(response.statusCode)
                    }
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    internal func getData(_ endpoint: String, parameters: [String: Any] = [:]) throws -> AnyPublisher<Data, Error> {
        
        let bearerToken = try Self.makeBearerToken(configuration: configuration)
        
        let url = URLBuilder.buildURL(baseURL, endpoint, parameters)
        var urlRequest = URLRequest(url: url,
                                    cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                    timeoutInterval: 60)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/a-gzip", forHTTPHeaderField: "Accept")
        urlRequest.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap { (data, response) in
                if let response = response as? HTTPURLResponse {
                    guard 200...299 ~= response.statusCode else {
                        throw AppStoreServiceError.httpStatusCode(response.statusCode)
                    }
                }
                return data
            }
            .tryMap { data in
                try gunzip(data: data)
            }
            .eraseToAnyPublisher()
    }
    
    public static func makeBearerToken(configuration: AppStoreAPIConfiguration) throws -> String {
        let token = AppStoreToken(keyID: configuration.privateKeyID,
                                  issuerID: configuration.issuerID)
        let tokenAsString = try token.sign(with: configuration.privateKey)
        return tokenAsString
    }
}

class URLBuilder {
    
    static func buildURL(_ baseURL: URL?, _ path: String, _ parameters: [String: Any]) -> URL {
        
        let placeholderBaseURL = URL(string: "/missing-base-url")!
        
        let url = (baseURL ?? placeholderBaseURL).appendingPathComponent(path)
        
        guard !parameters.isEmpty else {
            return url
        }
        
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let queryItems = parameters.map {
            return URLQueryItem(name: "\($0)", value: "\($1)")
        }
        urlComponents?.queryItems = queryItems
        let urlWithComponents = urlComponents?.url
        return urlWithComponents ?? url
    }

}
