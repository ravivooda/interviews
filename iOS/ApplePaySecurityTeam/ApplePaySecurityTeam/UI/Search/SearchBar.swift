//
//  SearchBar.swift
//  ApplePaySecurityTeam
//
//  Created by Ravi Vooda on 12/10/20.
//  Copyright © 2020 Ravi Vooda. All rights reserved.
//

import UIKit

protocol SearchBarListener : class {
    func handleSearch(for text:String)
}

class SearchBar: UISearchBar, UISearchBarDelegate {
    weak var listener:SearchBarListener?
    init(listener: SearchBarListener) {
        self.listener = listener
        super.init(frame: .zero)
        self.delegate = self
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.listener?.handleSearch(for: searchText)
    }
}
