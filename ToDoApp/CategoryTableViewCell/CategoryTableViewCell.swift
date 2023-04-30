//
//  CategoryTableViewCell.swift
//  ToDoApp
//
//  Created by Vakhtang on 30.04.2023.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    static let identifier = "CategoryTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "CategoryTableViewCell", bundle: nil)
    }
    func configure(with categoryArray: [Category]) {
        self.categoryArray = categoryArray
        collectionView.reloadData()
    }
    @IBOutlet weak var collectionView: UICollectionView!
    var categoryArray = [Category]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(CategoryCollectionViewCell.nib(), forCellWithReuseIdentifier: CategoryCollectionViewCell.indetifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}

extension CategoryTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.indetifier, for: indexPath) as! CategoryCollectionViewCell
        cell.congigure(with: categoryArray[indexPath.row])
        return cell
    }
    
    
}

extension CategoryTableViewCell: UICollectionViewDelegate {
    
}
