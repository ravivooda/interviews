//
//  SearchViewController.swift
//  ApplePaySecurityTeam
//
//  Created by Ravi Vooda on 12/10/20.
//  Copyright © 2020 Ravi Vooda. All rights reserved.
//

import UIKit

protocol SearchResultsInteractionListener : class {
    func handleSelection(atIndex:IndexPath)
    func handleUserWillReachBottom()
}

// It probably makes more sense to move all TableView related logic to a separate view which can maintain the state of the results, populate data, handle delegate than clubbing them with View Controller logic; Blaming it on time for now
class SearchViewController: UIViewController {
    let searchBar:SearchBar
    
    var results = [ResultDisplayable]()
    let searchResultsTableView:SearchResultsTableView
    
    weak var listener: SearchResultsInteractionListener?
    
    var hasUserReachedBottom = false
    
    init(searchBar:SearchBar, searchResultsTableView:SearchResultsTableView, listener: SearchResultsInteractionListener) {
        self.searchBar = searchBar
        self.searchResultsTableView = searchResultsTableView
        self.listener = listener
        super.init(nibName: nil, bundle: nil)
        
        self.searchResultsTableView.delegate = self
        self.searchResultsTableView.dataSource = self
        
        
        self.searchResultsTableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.searchResultsTableView.estimatedRowHeight = 100
        self.searchResultsTableView.rowHeight = UITableView.automaticDimension
        self.searchResultsTableView.register(SearchResultsTableViewCell.self, forCellReuseIdentifier: searchResultsTableViewCellReuseIdentifier)
        
        self.navigationItem.title = "Search for a movie!"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.searchBar)
        self.view.addSubview(self.searchResultsTableView)
        self.view.backgroundColor = .white
        
        setupConstraints()
    }
    
    func setupConstraints() {
        let margins = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            // Search bar constraints
            self.searchBar.topAnchor.constraint(equalTo: margins.topAnchor),
            self.searchBar.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            self.searchBar.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            
            // Search results table view constraints
            self.searchResultsTableView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            self.searchResultsTableView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            self.searchResultsTableView.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
            self.searchResultsTableView.topAnchor.constraint(equalTo: self.searchBar.bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension SearchViewController: ResultsPresenter {
    func showNetworkError(message: String, alternative: String) {
        let fullMessage = message + "\n" + alternative
        let alertController = UIAlertController(title: "An error occurred", message: fullMessage, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "OK", style: .cancel) { (action) -> Void in
            
        }
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func extend(movies: [ResultDisplayable]) {
        self.results.append(contentsOf: movies)
        self.refresh()
    }
    
    func reload(movies: [ResultDisplayable]) {
        self.results = movies
        self.refresh()
    }
    
    func refresh() {
        hasUserReachedBottom = false
        self.searchResultsTableView.reloadData()
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.listener?.handleSelection(atIndex: indexPath)
    }
}


extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: searchResultsTableViewCellReuseIdentifier, for: indexPath) as? SearchResultsTableViewCell else {
            return UITableViewCell()
        }
        cell.render(displayable: self.results[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row >= results.count - 3 && !hasUserReachedBottom {
            // Inform listener that user is about to reach bottom
            self.listener?.handleUserWillReachBottom()
            hasUserReachedBottom = true
        }
    }
}
