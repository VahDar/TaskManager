//
//  TutorialViewController.swift
//  ToDoApp
//
//  Created by Vakhtang on 12.05.2023.
//

import UIKit

class TutorialViewController: UIViewController {

    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let storageManager = StorageManager()
    private let navigationManager = NavigationManager()
    
    var currentPage = 0 {
        didSet {
            if currentPage == slides.count - 1 {
                nextButton.setTitle("Get Started", for: .normal)
            } else {
                nextButton.setTitle("Next", for: .normal)
            }
        }
    }
    var slides: [TutorialModel] = [TutorialModel(image: UIImage(named: "plus"), title: "", description: "Add your task to manage your daily schedule"),
                TutorialModel(image: UIImage(named: "tap"), title: "One tap", description: "one tap on your task to open a screen with to do list where you can add items for your task"),
                TutorialModel(image: UIImage(named: "Doubletap"), title: "Double tap", description: "Double click to mark completed task"),
                TutorialModel(image: UIImage(named: "holdtouch"), title: "Long press", description: "Long press the task to edit or delete in one"),
                TutorialModel(image: UIImage(named: "notification"), title: "Notification", description: "Let us give you a notification of your task on time"),
                TutorialModel(image: UIImage(named: "list"), title: "To do list", description: "One tap to mark completed, swipe to delete it.")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.layer.cornerRadius = 15
        collectionView.dataSource = self
        collectionView.delegate = self
        updateFlag()
    }
    
    private func updateFlag() {
        storageManager.setOnboardingSeen()
    }
  
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        if currentPage == slides.count - 1 {
            navigationManager.show(screen: .mainApp, inController: self)
            print("last page")
        } else {
            currentPage += 1
            collectionView.isPagingEnabled = false
            let indexPath = IndexPath(item: currentPage, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            collectionView.isPagingEnabled = false
            collectionView.reloadData()
        }
        
        
    }
    
    
}


extension TutorialViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TutorialCollectionViewCell", for: indexPath) as! TutorialCollectionViewCell
        cell.setUp(slides[indexPath.row])
        return cell
    }
    
    
}
extension TutorialViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
        pageControl.currentPage = currentPage
        
    }
}

extension TutorialViewController: UICollectionViewDelegate {
    
}
