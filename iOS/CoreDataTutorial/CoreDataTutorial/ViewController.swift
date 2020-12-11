//
//  ViewController.swift
//  CoreDataTutorial
//
//  Created by Ravi Vooda on 11/18/20.
//  Copyright © 2020 Ravi Vooda. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var container:NSPersistentContainer!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        container = AppDelegate.shared.persistentContainer
    }
    
    func reloadData() {
        self.tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 35
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "renderingTableViewCell", for: indexPath) as? RenderingTableViewCell else {
            return UITableViewCell()
        }
        cell.rTextLabel?.text = "\(indexPath.row)"
        return cell
    }

    @IBAction func addNew(_ sender: UIBarButtonItem) {
        let addController = AddItemViewController(listener: self)
        self.navigationController!.pushViewController(addController, animated: true)
    }
}


extension ViewController: AddItemListener {
    func add(item: Item) {
        <#code#>
    }
    
    
}
