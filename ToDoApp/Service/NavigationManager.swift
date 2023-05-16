//
//  NavigationManager.swift
//  ToDoApp
//
//  Created by Vakhtang on 16.05.2023.
//

import UIKit

class NavigationManager {
    enum Screen {
        case onboarding
        case mainApp
    }
    
    func show(screen: Screen, inController: UIViewController) {
        var viewController: UIViewController!
        switch screen {
        case .onboarding:
            viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TutorialViewController")
        case .mainApp:
            viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NavigationController")
        }
        if let sceneDelegate =
            inController.view.window?.windowScene?.delegate as? SceneDelegate, let window = sceneDelegate.window {
            window.rootViewController = viewController
            UIView.transition(with: window,
                              duration: 0.5,
                              animations: nil,
                              completion: nil)
        }
    }
}

