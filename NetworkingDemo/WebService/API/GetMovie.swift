//
//  GetMovie.swift
//  NetworkingDemo
//
//  Created by Trinh Thai on 08/05/2021.
//

import UIKit

struct GetMovieRequest: CommonAPIRequest {
    typealias Response = Movie
    
    let pageNum: Int
    
    init(pageNum: Int) {
        self.pageNum = pageNum
    }

    var method: HTTPMethod {
        return .get
    }

    var path: String {
        return "/now_playing"
    }

    var url: URL? {
        return baseURL?.appendingPathComponent(self.path)
    }

    var parameters: Parameters {
        return [
            "page": pageNum,
            "api_key": ""
        ]
    }
    var body: Data? {
        return nil
    }
}

struct Movie: Codable {
    let page: Int
    let numberOfResults: Int
    let numberOfPages: Int
    
    private enum CodingKeys: String, CodingKey {
        case page
        case numberOfResults = "total_results"
        case numberOfPages = "total_pages"
    }
}


