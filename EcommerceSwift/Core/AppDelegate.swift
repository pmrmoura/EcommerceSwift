//
//  AppDelegate.swift
//  EcommerceSwift
//
//  Created by Pedro Moura on 02/02/23.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var appCoordinator: AppCoordinator!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        self.appCoordinator = AppCoordinator(window: window!)
        self.appCoordinator.start()
        
        return true
    }
}

