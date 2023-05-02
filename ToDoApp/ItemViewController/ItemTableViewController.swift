//
//  ItemTableViewController.swift
//  ToDoApp
//
//  Created by Vakhtang on 01.05.2023.
//

import UIKit
import CoreData

class ItemTableViewController: UITableViewController {
    
    var itemArray = [Item]()
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    // MARK : - TableView Datasource Method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row].titel
        
        cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
        
//        if itemArray[indexPath.row].done == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        
        return cell
    }
    
    //MARK: - TableView Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        itemArray[indexPath.row].done.toggle()
        saveItems()
        
//        if itemArray[indexPath.row].done == false {
//            itemArray[indexPath.row].done = true
//        } else {
//            itemArray[indexPath.row].done = false
//        }
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //Mark: - Add New Item
    
    @IBAction func addBarButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New ToDo Item", message: "New Item", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            
            let newItem = Item(context: self.context)
            newItem.titel = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            
            self.saveItems()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems() {
        
        do {
           try context.save()
        } catch {
           print("Error saving context \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
       
        // Two things happen within this block of code when it is called depending on the arguments supplied or not supplied when the method is called.
        // 1. Querry based on items belonging to selected category will be loaded up
        //2. Querry based on the search bar request will be loaded up
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionPredicate = predicate { // if here is a value present inside the variable "predicate", it means that the search bar request came in and the block of code here runs.
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionPredicate])
        } else {
            //Default request, load only items for selected category wich was querried.
            request.predicate = categoryPredicate
        }
        
        
        do {
            itemArray = try context.fetch(request) //Here, the context fetch our request from our db which will be loaded into the array of elements we created
        } catch {
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
    }
    
}
