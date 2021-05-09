//
//  URLRequestBuilder.swift
//  NetworkingDemo
//
//  Created by Trinh Thai on 08/05/2021.
//

import Foundation

final class URLRequestBuilder {
    func build<T: Request>(_ request: T) -> URLRequest? {
        var reqUrl = request.url
        
        if !request.parameters.isEmpty, let url = reqUrl, var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            var queryItems: [URLQueryItem] = []
            for param in request.parameters {
                queryItems.append(URLQueryItem(name: param.key, value: "\(param.value)"))
            }
            urlComponents.queryItems = queryItems
            
            if let comUrl = urlComponents.url?.absoluteURL {
                reqUrl = comUrl
            }
        }
        
        guard let newUrl = reqUrl else { return nil }
        var urlRequest = URLRequest(url: newUrl)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.allHTTPHeaderFields = request.headers
        
        guard let body = request.body else { return urlRequest }
        urlRequest.httpBody = body
        return urlRequest
    }
}

