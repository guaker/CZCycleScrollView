//
//  AppDelegate.swift
//  CZCycleScrollView
//
//  Created by guaker on 2019/11/12.
//  Copyright © 2019 giantcro. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        self.window?.rootViewController = ViewController()
        self.window?.backgroundColor = .white
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
}

