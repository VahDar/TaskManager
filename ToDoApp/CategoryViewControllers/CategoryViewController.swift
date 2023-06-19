
//  CategoryViewController.swift
//  ToDoApp
//
//  Created by Vakhtang on 30.04.2023.
import UIKit
import CoreData

class CategoryViewController: UIViewController, UIGestureRecognizerDelegate {
   
    
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var button: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var labelTaks: UILabel!
    @IBOutlet weak var labelManager: UILabel!
    
    var category: Category?
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
        view.layer.borderColor = #colorLiteral(red: 0.990247786, green: 0.8528698683, blue: 0.008418501355, alpha: 1)
        view.layer.borderWidth = 1
        collectionView.dataSource = self
        loadCategories()
        setupGestureLongRecognizer()
        setupTapsGesture()
        setupVisualEffect()
        dateSetup()
    }
    
    // MARK: - Setup Date
    func dateSetup() {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"
        let dateString = dateFormatter.string(from: currentDate)
        dateLabel.text = dateString
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
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add category", style: .default) { (action) in
            
            let categoryName = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                   let isUnique = self.categoryArray.allSatisfy { $0.name != categoryName }
                   if isUnique {
                       let newCategory = Category(context: self.context)
                       if categoryName.isEmpty {
                           let categoryCount = self.categoryArray.count
                           newCategory.name = "New Category \(categoryCount + 1)"
                       } else {
                           newCategory.name = categoryName
                       }
                       newCategory.isSelected = false
                       self.categoryArray.append(newCategory)
                       self.saveCategories()
                   } else {
                       let errorAlert = UIAlertController(title: "Error", message: "Category name must be unique", preferredStyle: .alert)
                       let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                       errorAlert.addAction(okAction)
                       self.present(errorAlert, animated: true, completion: nil)
                   }
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
    
    func setAlert() {
        view.addSubview(alertView)
        alertView.center = view.center
        alertView.configure()
}
    
//     MARK: - Setup LongPress Gestur recognizer
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
        
        if let indexPath = self.collectionView.indexPathForItem(at: point) {
            
            let alert = UIAlertController(title: "options", message: "", preferredStyle: .alert)
            let delete = UIAlertAction(title: "Delete", style: .destructive) { delete in
                let deleteCategory = self.categoryArray[indexPath.row]
                
                self.context.delete(deleteCategory)
                self.categoryArray.remove(at: indexPath.row)
                self.collectionView.deleteItems(at: [indexPath])
                if let notificationId = deleteCategory.notificationId {
                    print("Notification ID: \(notificationId)")
                    self.alertView.notificationCenter.removePendingNotificationRequests(withIdentifiers: [notificationId])
                } else {
                    print("Notification ID is nil or not set")
                }
                self.saveCategories()
            }

            let edit = UIAlertAction(title: "Edit", style: .default) { (_) in
                        let selectedCategory = self.categoryArray[indexPath.row]
                        self.alertView.data = selectedCategory
                        self.alertView.switchButton.isOn = false
                        self.setAlert()
                        self.animateIn()
                    }
                    alert.addAction(delete)
                    alert.addAction(edit)
                    present(alert, animated: true, completion: nil)
                    collectionView.reloadData()
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

            let vc = storyboard?.instantiateViewController(identifier: "ItemVC") as! ItemTableViewController
            self.navigationController?.pushViewController(vc, animated: true)
            vc.selectedCategory = categoryArray[indexPath!.row]
            print("one tap")
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
        cell.configure()
        
        return cell
    }
}


// MARK: - AlertView Delegate
extension CategoryViewController: AlertDelegate {
    
    func switchButton(_ sender: UISwitch) {
        if sender.isOn {
            alertView.scheduleLocalNotification()
        } else {
            
    }
}
    
    func deleteButtonPressed() {
        
        animateOut()
        
}
    
    func saveButtonPressed() {
        alertView.doneAction()
        animateOut()
        saveCategories()
        collectionView.reloadData()
    }
}

