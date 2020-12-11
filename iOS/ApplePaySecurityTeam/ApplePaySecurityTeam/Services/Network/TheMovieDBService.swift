//
//  TheMovieDBService.swift
//  ApplePaySecurityTeam
//
//  Created by Ravi Vooda on 12/11/20.
//  Copyright © 2020 Ravi Vooda. All rights reserved.
//

import Foundation

struct SearchResponse {
    let page:Int
    let movies:[Movie]
    let totalPages:Int
    let totalResults:Int
}

struct SearchRequest {
    let query:String
    let page:Int
}

struct SearchServiceConfiguration {
    let key:String
    let queryPath:String
    let imagePrefix:String
}

protocol TheMovieDBService {
    func search(request:SearchRequest, callback: @escaping ((SearchResponse?, TheMovieDBServiceError?) -> Void)) -> URLSessionDataTask?
}

final class TheMovieDBServiceImpl: TheMovieDBService {
    let webClient:WebClient
    let config:SearchServiceConfiguration
    
    init(webClient:WebClient, config:SearchServiceConfiguration) {
        self.webClient = webClient
        self.config = config
    }
    
    func search(request:SearchRequest, callback: @escaping ((SearchResponse?, TheMovieDBServiceError?) -> Void)) -> URLSessionDataTask? {
        var params = [
            "query": request.query,
            "api_key": self.config.key,
        ]
        
        if request.page > 0 {
            params["page"] = "\(request.page)"
        }
        
        return self.webClient.load(path: self.config.queryPath, method: .get, params: params) { (result, error) in
            guard error == nil else {
                callback(nil, .other("api error"))
                return
            }
            
            guard let jsonPayload = result as? [String: Any] else {
                callback(nil, .parsing("could not jsonify"))
                return
            }
            
            let (response, parseError) = self.parse(payload: jsonPayload)
            
            callback(response, parseError)
        }
    }
    
    private func parse(payload: [String: Any]) -> (SearchResponse?, TheMovieDBServiceError?) {
        guard let page = payload["page"] as? Int,
            let totalPages = payload["total_pages"] as? Int,
            let totalResults = payload["total_results"] as? Int else {
                return (nil, .parsing("could not find the page information"))
        }
        
        guard let results = payload["results"] as? [[String:Any]] else {
            return (nil, .parsing("results not formatted"))
        }
        
        var availableResults = [Movie]()
        for result in results {
            guard let title = result["original_title"] as? String,
                let description = result["overview"] as? String else {
                    return (nil, .parsing("expected information unavailable \(result)"))
            }
            
            var posterURL:URL? = nil
            if let posterPath = result["poster_path"] as? String {
                posterURL = URL(string: self.config.imagePrefix + posterPath)
            }
            
            availableResults.append(Movie(title: title, posterURL: posterURL, description: description))
        }
        
        return (SearchResponse(page: page, movies: availableResults, totalPages: totalPages, totalResults: totalResults), nil)
    }
}

enum TheMovieDBServiceError: Error {
    case parsing(String)
    case other(String)
}
