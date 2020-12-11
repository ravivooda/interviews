//
//  SearchComponent.swift
//  ApplePaySecurityTeam
//
//  Created by Ravi Vooda on 12/10/20.
//  Copyright © 2020 Ravi Vooda. All rights reserved.
//

import UIKit

class SearchComponent {
    let navigationController:UINavigationController
    let searchBar:SearchBar
    let searchController:SearchViewController
    let searchResultsTableView:SearchResultsTableView
    let interactor:SearchInteractor
    
    init(theMovieDBService:TheMovieDBService) {
        self.interactor = SearchInteractor(theMovieDBService: theMovieDBService)
        self.searchBar = SearchBar(listener: self.interactor)
        self.searchResultsTableView = SearchResultsTableView()
        self.searchController = SearchViewController(searchBar: searchBar, searchResultsTableView: searchResultsTableView, listener: self.interactor)
        self.navigationController = UINavigationController(rootViewController: self.searchController)
        self.interactor.resultsPresenter = self.searchController
    }
    
    func getRootController() -> UIViewController {
        return self.navigationController
    }
}
