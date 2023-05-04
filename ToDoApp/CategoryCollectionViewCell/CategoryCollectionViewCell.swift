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
    @IBOutlet weak var dayAndMonthField: UITextField!
    @IBOutlet weak var timeField: UITextField!
    
    var category: Category?
    
    static let indetifier = "CategoryCollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "CategoryCollectionViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func setTexField(dayField: String, dayAndMonthField: String, timeField: String) {
        self.dayField.text = dayField
        self.dayAndMonthField.text = dayAndMonthField
        self.timeField.text = timeField
    }
    
    public func congigure() {
        self.nameLael.text = category!.name
        
        switch category!.isSelected {
        case true:
            self.imageCheckMark.image = UIImage(named: "done")
        case false:
            self.imageCheckMark.image = UIImage(named: "no")
        }
    }
    

}


