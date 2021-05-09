//
//  NetworkManager.swift
//  NetworkingDemo
//
//  Created by Trinh Thai on 08/05/2021.
//

import UIKit

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

typealias HTTPHeaders = [String: String]
typealias Parameters = [String : Any]

protocol Request {
    associatedtype Response

    var baseURL: URL? { get }
    var url: URL? { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders { get }
    var parameters: Parameters { get }
    var body: Data? { get }
}

protocol CommonAPIRequest: Request {}

extension CommonAPIRequest {
    var baseURL: URL? {
        return URL(string: "https://api.themoviedb.org/3/movie")
    }

    var headers: HTTPHeaders {
        return [
            "Accept": "application/json",
        ]
    }
}

enum ApiError: Error {
    case badRequest(Data)
    case unAuthorized(Data)
    case forbidden(Data)
    case gone
    case serverError
    case otherError(String)
    case unknownError
    case dataNotExist
    case invalidResponse
}

final class NetworkManager {
    func send<T: Request>(request: T, completion: @escaping (Result<T.Response, ApiError>) -> Void) where T.Response: Decodable {
        
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = TimeInterval(120)
        let session = URLSession(configuration: config)

        guard let urlRequest = URLRequestBuilder().build(request) else {
            completion(.failure(.otherError("URL err"))); return
        }
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            
            if let error = error {
                completion(.failure(.otherError(error.localizedDescription)))
                return
            }
            
            guard let res = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse)); return
            }

            guard let data = data else {
                completion(.failure(.dataNotExist)); return
            }
            
            switch res.statusCode {
            case 200:
                do {
                    let res = try JSONDecoder().decode(T.Response.self, from: data)
                    completion(.success(res))
                } catch {
                    completion(.failure(.otherError(error.localizedDescription)))
                }
            case 400:
                completion(.failure(.badRequest(data)))
            case 401:
                completion(.failure(.unAuthorized(data)))
            case 410:
                completion(.failure(.gone))
            case 403:
                completion(.failure(.forbidden(data)))
            case 500..<511:
                completion(.failure(.serverError))
            default:
                completion(.failure(.unknownError))
            }
        }
        task.resume()
    }
}


