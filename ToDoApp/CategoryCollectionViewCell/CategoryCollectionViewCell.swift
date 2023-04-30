//
//  CategoryCollectionViewCell.swift
//  ToDoApp
//
//  Created by Vakhtang on 30.04.2023.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLael: UILabel!
    
    static let indetifier = "CategoryCollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "CategoryCollectionViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
   public func congigure(with categoryArray: Category) {
        self.nameLael.text = categoryArray.name
    }

}


