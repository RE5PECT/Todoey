//
//  ViewController.swift
//  Todoey
//
//  Created by Ricardo Vera Abarca on 5/9/19.
//  Copyright © 2019 Ricardo Vera Abarca. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    let itemArray = ["Find Mike","Buy Water","Destroy Demogorgon"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    //MARK: TableView Datasource Methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        let todo = itemArray[indexPath.row]
        cell.textLabel?.text = todo
        cell.detailTextLabel?.text = "Prueba lorem ipsum"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        if tableView.cellForRow(at: indexPath)!.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)!.accessoryType = .none
        }else{
            tableView.cellForRow(at: indexPath)!.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

