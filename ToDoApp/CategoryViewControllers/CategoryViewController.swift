//
//  CategoryViewController.swift
//  ToDoApp
//
//  Created by Vakhtang on 30.04.2023.
//

import UIKit
import CoreData

class CategoryViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var collectionView: UICollectionView!

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var categoryArray = [Category]()
    
    var indexPathforhendler: IndexPath?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(CategoryCollectionViewCell.nib(), forCellWithReuseIdentifier: CategoryCollectionViewCell.indetifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        loadCategories()
        setupGestureLongRecognizer()
        setupTapsGesture()
    }
    //MARK: - Data Manipulation Methods
    
    func saveCategories() {
        
        do {
            try context.save()
        } catch {
            print("Error saving category \(error)")
        }
       
        collectionView.reloadData()
    }
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context category \(error)")
        }
        collectionView.reloadData()
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add category", style: .default) { (action) in
            
            let newCategory = Category(context: self.context)
            
            newCategory.name = textField.text!
            self.categoryArray.append(newCategory)
            
            self.saveCategories()
            
        }
        
        alert.addTextField{ (alertTextfield) in
            alertTextfield.placeholder = "Create a new category"
            textField = alertTextfield
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
//    // MARK: - Setup LongPress Gestur recognizer
    private func setupGestureLongRecognizer() {
        let gesturLongPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        gesturLongPress.minimumPressDuration = 0.5
        gesturLongPress.delaysTouchesBegan = true
        gesturLongPress.delegate = self

        self.collectionView.addGestureRecognizer(gesturLongPress)
    }

    @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {

        guard gestureRecognizer.state != .began else { return }
        let point = gestureRecognizer.location(in: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: point)
        if indexPath != nil {
            print("long press")
        } else {
            print("Could not work long press")
        }
    }

    // MARK: - Setup Tap and Double Gesture
    func setupTapsGesture() {

//        // Single Tap
//        let singleTap = UITapGestureRecognizer(target: self, action: #selector(handleOneTap(_:)))
//        singleTap.numberOfTapsRequired = 1
//        collectionView.addGestureRecognizer(singleTap)

        // Double Tap
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        doubleTap.numberOfTapsRequired = 2
        collectionView.addGestureRecognizer(doubleTap)

//        singleTap.require(toFail: doubleTap)
//        singleTap.delaysTouchesBegan = true
        doubleTap.delaysTouchesBegan = true

    }

//    @objc func handleOneTap(_ sender: UITapGestureRecognizer) {
//
//        print("One Tap")
        
        
        
//    }

    @objc func handleDoubleTap() {
        print("Double Tap")
    }
}

// MARK: - TableView DataSource Methods

extension CategoryViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.indetifier, for: indexPath) as! CategoryCollectionViewCell
        cell.congigure(with: categoryArray[indexPath.row])
        return cell
    }
    
    
}


extension CategoryViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        collectionView.deselectItem(at: indexPath, animated: true)
//        print("Selected!! \(categoryArray[indexPath.row].name!)")
//        performSegue(withIdentifier: "goToItems", sender: self)
//        if let indexPath = collectionView.indexPathsForSelectedItems {
//            destinationVC.selectedCategory = categoryArray[indexPath.item]
//        }
//        collectionView.reloadData()
        let vc = storyboard?.instantiateViewController(withIdentifier: "ItemVC") as! ItemTableViewController
        
        self.navigationController?.pushViewController(vc, animated: true)

//        if let indexPath = collectionView.indexPathsForSelectedItems {
        vc.selectedCategory = categoryArray[indexPath.row]
//                }
        collectionView.reloadData()
        
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let destinationVC = segue.destination as! ItemTableViewController

        if let indexPath = collectionView.indexPathsForSelectedItems {
            destinationVC.selectedCategory = categoryArray[indexPath.endIndex]
        }
    }

}
