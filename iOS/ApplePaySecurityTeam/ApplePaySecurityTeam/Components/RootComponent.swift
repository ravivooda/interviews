//
//  RootComponent.swift
//  ApplePaySecurityTeam
//
//  Created by Ravi Vooda on 12/11/20.
//  Copyright © 2020 Ravi Vooda. All rights reserved.
//

import UIKit

class RootComponent {
    var searchComponent: SearchComponent
    init() {
        let (baseURL, searchServiceConfig) = RootComponent.getSearchServiceConfiguration()
        
        let webClient = WebClient(baseUrl: baseURL)
        let theMovieDBService = TheMovieDBServiceImpl(webClient: webClient, config: searchServiceConfig)
        
        self.searchComponent = SearchComponent(theMovieDBService: theMovieDBService)
    }
    
    func getAttachController() -> UIViewController {
        return self.searchComponent.getRootController()
    }
    
    fileprivate static func getSearchServiceConfiguration() -> (String, SearchServiceConfiguration) {
        guard let filePath = Bundle.main.path(forResource: "TMDB-Info", ofType: "plist") else {
            fatalError("Couldn't find file 'TMDB-Info.plist'.")
        }
        
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let apiKey = plist?.object(forKey: "API_KEY") as? String else {
            fatalError("Couldn't find key 'API_KEY' in 'TMDB-Info.plist'.")
        }
        
        guard let baseURL = plist?.object(forKey: "BASE_URL") as? String else {
            fatalError("Couldn't find key 'BASE_URL' in 'TMDB-Info.plist'.")
        }
        
        guard let queryPath = plist?.object(forKey: "QUERY_PATH") as? String else {
            fatalError("Couldn't find key 'QUERY_PATH' in 'TMDB-Info.plist'.")
        }
        
        guard let imagePrefix = plist?.object(forKey: "IMAGE_PREFIX") as? String else {
            fatalError("Couldn't find key 'IMAGE_PREFIX' in 'TMDB-Info.plist'.")
        }
        
        return (baseURL, SearchServiceConfiguration(key: apiKey, queryPath: queryPath, imagePrefix: imagePrefix))
    }
}
