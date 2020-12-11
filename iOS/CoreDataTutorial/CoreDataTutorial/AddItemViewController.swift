//
//  AddItemViewController.swift
//  CoreDataTutorial
//
//  Created by Ravi Vooda on 11/19/20.
//  Copyright © 2020 Ravi Vooda. All rights reserved.
//

import UIKit

class AddItemViewController: UIViewController {
    
    init(listener:AddItemListener) {
        self.listener = listener
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var listener: AddItemListener?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}

protocol AddItemListener : class {
    func add(item:Item)
}
