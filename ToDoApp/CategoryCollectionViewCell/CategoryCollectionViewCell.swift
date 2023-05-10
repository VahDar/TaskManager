//
//  CategoryCollectionViewCell.swift
//  ToDoApp
//
//  Created by Vakhtang on 30.04.2023.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var collectionViewCell: CategoryCollectionViewCell!
    @IBOutlet weak var nameLael: UILabel!
    @IBOutlet var imageCheckMark: UIImageView!
    @IBOutlet weak var dayField: UITextField!
    @IBOutlet weak var monthField: UITextField!
    @IBOutlet weak var viewCell: UIView!
    @IBOutlet weak var timeField: UITextField!
   
    var category: Category!
    
    var alertView: AlertView!
    static let indetifier = "CategoryCollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "CategoryCollectionViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        setupGestureLongRecognizer()
        // Initialization code
    }
    
   
    
    public func setTexField(dayField: String, dayAndMonthField: String, timeField: String ) {
        self.dayField.text = dayField
        self.monthField.text = dayAndMonthField
        self.timeField.text = timeField
    }
    
    public func congigure() {
        self.nameLael.text = category!.name
        dayField.borderStyle = .none
        monthField.borderStyle = .none
        timeField.borderStyle = .none
        viewCell.layer.cornerRadius = 25
        
        layer.cornerRadius = 25
        layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        layer.borderWidth = 1
        layer.shadowColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        layer.shadowRadius = 9
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 5, height: 8)
        clipsToBounds = false
        switch category.isSelected {
        case true:
            self.imageCheckMark.image = UIImage(named: "done")
        case false:
            self.imageCheckMark.image = .none
        }
        self.dayField.text = category.dayField
        self.monthField.text = category.monthField
        self.timeField.text = category.timeField
    }
    private func setupGestureLongRecognizer() {
        let gesturLongPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        gesturLongPress.minimumPressDuration = 0.5
        gesturLongPress.delaysTouchesBegan = true
//        gesturLongPress.delegate = self

        self.addGestureRecognizer(gesturLongPress)
    }
    
    @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {

        guard gestureRecognizer.state != .began else { return }

            print("long press")
        }
    

}


