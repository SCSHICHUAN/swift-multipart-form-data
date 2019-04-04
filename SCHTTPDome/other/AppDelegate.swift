//
//  AppDelegate.swift
//  Travel
//
//  Created by SHICHUAN on 2019/3/22.
//  Copyright © 2019 SHICHUAN. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      
        self.window  = UIWindow.init(frame: UIScreen.main.bounds);
        self.window?.rootViewController = ViewController()
        self.window?.makeKeyAndVisible()
    
        return true
    }
}

