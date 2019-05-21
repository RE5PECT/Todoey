//
//  ViewController.swift
//  Todoey
//
//  Created by Ricardo Vera Abarca on 5/9/19.
//  Copyright © 2019 Ricardo Vera Abarca. All rights reserved.
//

import UIKit
import CoreData


class TodoListViewController: UITableViewController {
    var itemArray = [Item]()
    
    var category: Category? {
        didSet{
            loadItems()
            self.navigationItem.title = category?.name!
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
        cell.textLabel?.text = itemArray[indexPath.row].title
        if itemArray[indexPath.row].done == false {
            cell.accessoryType = .none
        }else{
            cell.accessoryType = .checkmark
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        tableView.cellForRow(at: indexPath)!.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
        tableView.deselectRow(at: indexPath, animated: true)
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            context.delete(itemArray[indexPath.row])
            itemArray.remove(at: indexPath.row)
            saveData()
            
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.category
            
            self.itemArray.append(newItem)
            self.saveData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    func saveData(){
        
        do {
            try context.save()
        }catch{
            print("Error saving context \(error)")
        }
        tableView.reloadData()
    }
    
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil ) {
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", category!.name!)
        
        
        if let pred = predicate {
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, pred])
            request.predicate = compoundPredicate
        }else{
            request.predicate = categoryPredicate
        }
        
        do
        {
            itemArray = try context.fetch(request)
        }catch{
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
    }
    
    
}

extension TodoListViewController : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        if let text = searchBar.text {
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            
            loadItems(with: request, predicate: NSPredicate(format: "title CONTAINS[cd] %@", text))
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == ""{
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

