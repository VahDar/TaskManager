//
//  TutorialViewController.swift
//  ToDoApp
//
//  Created by Vakhtang on 12.05.2023.
//

import UIKit

class TutorialViewController: UIViewController {

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var slides: [TutorialModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
  
    @IBAction func nextButtonPressed(_ sender: UIButton) {
    }
    
}
