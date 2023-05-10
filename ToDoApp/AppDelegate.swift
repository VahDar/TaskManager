//
//  AppDelegate.swift
//  ToDoApp
//
//  Created by Vakhtang on 27.04.2023.
//

import UIKit
import CoreData
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    

    let notificationCenter = UNUserNotificationCenter.current()
    let alertView = AlertView()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            
            guard granted else { return }
            
            
        }
       
//        alertView.scheduleLocalNotification()
        return true
    }
    
    
//    func sendNotification() {
//        // create content
//        let content = UNMutableNotificationContent()
//        content.title = "Complete your task"
//        content.body = "body"
//        content.sound = UNNotificationSound.default
//
//        // create trigger
//        let dateInfo = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: self.alertView.datePicker.date)
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: false)
//
//        // make request
//        let request = UNNotificationRequest(identifier: "notification", content: content, trigger: trigger)
//        notificationCenter.add(request) { error in
//            if error != nil {
//                print(error?.localizedDescription)
//            }
//        }
//
//    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

