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
    
    private lazy var alertView: AlertView = {
        let alertView: AlertView = AlertView.loadFromNib()
        alertView.delegate = self
        return alertView
    }()
    
    // create property UIVisualEffect
    
    let visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(CategoryCollectionViewCell.nib(), forCellWithReuseIdentifier: CategoryCollectionViewCell.indetifier)
        collectionView.dataSource = self
        loadCategories()
        setupGestureLongRecognizer()
        setupTapsGesture()
        setupVisualEffect()
//        let alertView = AlertView()
//        let categoryCell = CategoryCollectionViewCell()
//        alertView.configureCell(with: categoryCell)
    }
    
    
    
    // MARK: - setup UIVisualEffect
    
    func setupVisualEffect() {
        view.addSubview(visualEffectView)
        visualEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        visualEffectView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        visualEffectView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        visualEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        visualEffectView.alpha = 0
    }
    
    func animateIn() {
        
        alertView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        alertView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.alpha = 1
            self.alertView.alpha = 1
            self.alertView.transform = CGAffineTransform.identity
        }
    }
    
    func animateOut() {
    
        UIView.animate(withDuration: 0.4, animations: {
            self.visualEffectView.alpha = 0
            self.alertView.alpha = 0
            self.alertView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        }) { _ in
            self.alertView.removeFromSuperview()
        }
        
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
    
 // MARK: - Add button setup
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add category", style: .default) { (action) in
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            newCategory.isSelected = false
            self.categoryArray.append(newCategory)
            
            self.saveCategories()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in}
        
        alert.addTextField{ (alertTextfield) in
            alertTextfield.placeholder = "Create a new category"
            textField = alertTextfield
        }
        alert.addAction(cancel)
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: - Set AlertView
    
    func setAlert() {
        view.addSubview(alertView)
        alertView.center = view.center
        alertView.configure()
    }
    
    // MARK: - Setup LongPress Gestur recognizer
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
        if let indexPath {
            alertView.data = categoryArray[indexPath.row]
            setAlert()
            animateIn()
            collectionView.reloadData()
            
            print("long press")
        } else {
            print("Could not work long press")
        }
    }

    // MARK: - Setup Tap and Double Gesture
    func setupTapsGesture() {

        // Single Tap
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(handleOneTap))
        singleTap.numberOfTapsRequired = 1
        collectionView.addGestureRecognizer(singleTap)

        // Double Tap
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        doubleTap.numberOfTapsRequired = 2
        collectionView.addGestureRecognizer(doubleTap)

        singleTap.require(toFail: doubleTap)
        singleTap.delaysTouchesBegan = true
        doubleTap.delaysTouchesBegan = true

    }

    @objc func handleOneTap(gestureRecognizer: UITapGestureRecognizer) {
        guard gestureRecognizer.state != .began else { return }
        let point = gestureRecognizer.location(in: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: point)
        if indexPath != nil {
            print("one tap")
            let vc = storyboard?.instantiateViewController(withIdentifier: "ItemVC") as! ItemTableViewController
            self.navigationController?.pushViewController(vc, animated: true)
            vc.selectedCategory = categoryArray[indexPath!.row]
            
            collectionView.reloadData()
        } else {
            print("Could not work one tap")
        }
    }

    @objc func handleDoubleTap(gestureRecognizer: UITapGestureRecognizer) {
        guard gestureRecognizer.state != .began else { return }
        let point = gestureRecognizer.location(in: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: point)
        if indexPath != nil {
            categoryArray[indexPath!.row].isSelected.toggle()
            collectionView.reloadData()
            print("double tap")
  
        } else {
            print("Could not work double tap")
        }
    }
}

// MARK: - TableView DataSource Methods

extension CategoryViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.indetifier, for: indexPath) as! CategoryCollectionViewCell
        
        cell.category = categoryArray[indexPath.row]
        cell.congigure()
        
        
        return cell
    }
    
    
}

// MARK: - AlertView Delegate
extension CategoryViewController: AlertDelegate {
    
    func deleteButtonPressed() {
        animateOut()
        
    }
    
    func saveButtonPressed() {
        animateOut()
        alertView.doneAction()
        collectionView.reloadData()
        saveCategories()
    }
    
    
}

