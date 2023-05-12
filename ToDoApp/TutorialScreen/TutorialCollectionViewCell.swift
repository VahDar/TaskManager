//
//  TutorialCollectionViewCell.swift
//  ToDoApp
//
//  Created by Vakhtang on 12.05.2023.
//

import UIKit

class TutorialCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var titelLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    func setUp(_ slide: TutorialModel) {
        image.image = slide.image
        titelLabel.text = slide.title
        descriptionLabel.text = slide.description
    }
    
    
}
