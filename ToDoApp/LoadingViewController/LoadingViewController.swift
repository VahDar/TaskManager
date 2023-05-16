//
//  LoadingViewController.swift
//  ToDoApp
//
//  Created by Vakhtang on 16.05.2023.
//

import UIKit

class LoadingViewController: UIViewController {
    
    private let isOnboardingSeen = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showInitialScreen()
    }
    
    func showInitialScreen() {
        if isOnboardingSeen {
            // go straight to main app
            showMainScreen()
        } else {
           // show onboarding screen
            showTutorialScreen()
        }
    }
    
    private func showTutorialScreen() {
        let tutorialAppViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TutorialViewController")
        if let sceneDelegate = view.window?.windowScene?.delegate as? SceneDelegate, let window = sceneDelegate.window {
            window.rootViewController = tutorialAppViewController
            UIView.transition(with: window,
                              duration: 0.5,
                              animations: nil,
                              completion: nil)
        }
    }
    
    private func showMainScreen() {
        let mainAppViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CategoryViewController")
        if let sceneDelegate = view.window?.windowScene?.delegate as? SceneDelegate, let window = sceneDelegate.window {
            window.rootViewController = mainAppViewController
            UIView.transition(with: window,
                              duration: 0.5,
                              animations: nil,
                              completion: nil)
        }
    }
}
