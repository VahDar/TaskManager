//
//  LoadingViewController.swift
//  ToDoApp
//
//  Created by Vakhtang on 16.05.2023.
//

import UIKit

class LoadingViewController: UIViewController {
    
    private var isOnboardingSeen: Bool!
    private let navigationManager = NavigationManager()
    private let storageManager = StorageManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isOnboardingSeen = storageManager.isOnboardingSeen()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showInitialScreen()
    }
    
    func showInitialScreen() {
        if isOnboardingSeen {
            // go straight to main app
            navigationManager.show(screen: .mainApp, inController: self)
        } else {
           // show onboarding screen
            navigationManager.show(screen: .onboarding, inController: self)
        }
    }
}
