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
    var category: Category?
    
    static let indetifier = "CategoryCollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "CategoryCollectionViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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


