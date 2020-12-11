//
//  SearchResultsTableView.swift
//  ApplePaySecurityTeam
//
//  Created by Ravi Vooda on 12/10/20.
//  Copyright © 2020 Ravi Vooda. All rights reserved.
//

import UIKit

protocol ResultDisplayable {
    var title:String { get }
    var posterURL:URL? { get }
    var description: String { get }
}

let searchResultsTableViewCellReuseIdentifier = "searchResultsTableViewCellReuseIdentifier"
class SearchResultsTableView: UITableView {
    init() {
        super.init(frame: .zero, style: .plain)
        self.tableFooterView = UIView(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
