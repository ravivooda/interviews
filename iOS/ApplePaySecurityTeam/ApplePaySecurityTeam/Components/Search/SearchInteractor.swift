//
//  SearchInteractor.swift
//  ApplePaySecurityTeam
//
//  Created by Ravi Vooda on 12/10/20.
//  Copyright © 2020 Ravi Vooda. All rights reserved.
//

import Foundation

protocol ResultsPresenter: class {
    func reload(movies: [ResultDisplayable])
    func extend(movies: [ResultDisplayable])
    func showNetworkError(message: String, alternative: String)
}

struct SearchState {
    let page:Int
    let totalPages:Int
    let text: String
}

class DelayTaskWorkerState {
    weak var prevSearchTask: URLSessionDataTask? = nil // While the task is in execution, URLSession will maintain strong reference. By making this weak, we will remove the retain cycle of referencing self in the completion blocks
    let workItem:DispatchWorkItem
    
    init(workItem: DispatchWorkItem) {
        self.workItem = workItem
    }
    
    func cancel() {
        self.workItem.cancel()
        self.prevSearchTask?.cancel()
    }
}

class SearchInteractor {
    let theMovieDBService:TheMovieDBService
    
    var delayTaskWorkerState:DelayTaskWorkerState? = nil
    
    weak var resultsPresenter: ResultsPresenter? = nil
    
    var currentSearchState:SearchState? = nil
    
    init(theMovieDBService: TheMovieDBService) {
        self.theMovieDBService = theMovieDBService
    }
    
    fileprivate func search(_ query: String, page:Int, successcallback: @escaping ((SearchResponse) -> Void)) {
        guard query.count != 0 else {
            self.resultsPresenter?.reload(movies: [])
            return
        }
        let searchRequest = SearchRequest(query: query, page: page)
        self.delayTaskWorkerState?.prevSearchTask = self.theMovieDBService.search(request: searchRequest, callback: { optionalSearchResponse, optionalError in
            guard optionalError == nil else {
                let error = optionalError!
                self.resultsPresenter?.showNetworkError(message: error.localizedDescription, alternative: "Please search again editing the text to refresh the results")
                return
            }
            
            guard let searchResponse = optionalSearchResponse else {
                return
            }
            
            self.currentSearchState = SearchState(page: searchResponse.page, totalPages: searchResponse.totalPages, text: query)
            
            successcallback(searchResponse)
        })
    }
}

extension SearchInteractor: SearchBarListener {
    func handleSearch(for text: String) {
        self.delayTaskWorkerState?.cancel()
        
        let delayTaskWorker = DispatchWorkItem {
            self.search(text, page: 0, successcallback: { (response) in
                self.resultsPresenter?.reload(movies: response.movies)
            })
        }
        
        let delayTaskWorkerState = DelayTaskWorkerState(workItem: delayTaskWorker)
        // Delaying by 1 sec to avoid calls while the user is typing
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: delayTaskWorkerState.workItem)
        self.delayTaskWorkerState = delayTaskWorkerState
    }
}

extension SearchInteractor: SearchResultsInteractionListener {
    func handleUserWillReachBottom() {
        guard let currentSearchState = self.currentSearchState else {
            return
        }
        
        if currentSearchState.page < currentSearchState.totalPages {
            // Fetch next page results
            search(currentSearchState.text, page: currentSearchState.page + 1) { (response) in
                self.resultsPresenter?.extend(movies: response.movies)
            }
        }
    }
    
    func handleSelection(atIndex: IndexPath) {
        // TBD
    }
}
