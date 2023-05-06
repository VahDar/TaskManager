//
//  ItemTableViewController.swift
//  ToDoApp
//
//  Created by Vakhtang on 01.05.2023.
//

import UIKit
import CoreData
import AVFoundation

class ItemTableViewController: UITableViewController {
    
    @IBOutlet weak var mic: UIButton!
    @IBOutlet weak var micButton: UIBarButtonItem!
    
    var itemArray = [Item]()
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var numberOfRecords: Int = 0
    var audioPlayer: AVAudioPlayer!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        //Setting up session
        recordingSession = AVAudioSession.sharedInstance()
        
        if let number: Int = UserDefaults.standard.object(forKey: "myNumer") as? Int {
            numberOfRecords = number
        }
        
        AVAudioSession.sharedInstance().requestRecordPermission { hasPermission in
            if hasPermission {
                print("ACCEPTED")
            }
        }
    }
    // MARK : - TableView Datasource Method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemArray.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row].titel
        
        cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
        
        
        return cell
    }
    
    //MARK: - TableView Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let path = getDirectory().appendingPathComponent("\(indexPath.row + 1).m4a")
        itemArray[indexPath.row].done.toggle()
        saveItems()
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: path)
            audioPlayer.play()
        } catch {
            
        }
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
    
    // MARK: - Func that gets path to directory
    func getDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        return documentDirectory
    }
    
    // MARK: - Func that displays an alert
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "dismiss", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    

    // MARK: - Recording Button
    @IBAction func recordButtonPressed(_ sender: Any) {
        var textField = UITextField()
        
        
        
        //Checkig we have an active recorder
        if audioRecorder == nil {
            numberOfRecords += 1
            let filename = getDirectory().appendingPathComponent("\(numberOfRecords).m4a")
            
            let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC), AVSampleRateKey: 1200, AVNumberOfChannelsKey: 1, AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
            
            
            //Start audio recording

            do {
                
                audioRecorder = try AVAudioRecorder(url: filename, settings: settings)
                
                audioRecorder.delegate = self
                audioRecorder.record()
                micButton.image = UIImage(named: "microfill")
            } catch {
                displayAlert(title: "Ups!", message: "Something went wrong!")
            }
        }
        else {
            //Stopping audio recording
            audioRecorder.stop()
            audioRecorder = nil
            let alert = UIAlertController(title: "Add New Voice Record", message: "New Voice Record", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Add Voice Record", style: .default) { (action) in
                
                
                let newItem = Item(context: self.context)
                newItem.titel = textField.text!
                newItem.done = false
                newItem.parentCategory = self.selectedCategory
                self.itemArray.append(newItem)
                
                self.saveItems()
            }
            
            
            alert.addTextField { (alertTextField) in
                alertTextField.placeholder = "Create new Record"
                textField = alertTextField
            }
            
            alert.addAction(action)
            
            present(alert, animated: true, completion: nil)
//            UserDefaults.standard.set(numberOfRecords, forKey: "myNumber")
            
            micButton.image = UIImage(named: "micro")
            
        }
    }
    
    
}


extension ItemTableViewController: AVAudioRecorderDelegate {
    
}
