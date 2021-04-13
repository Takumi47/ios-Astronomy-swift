//
//  AppDelegate.swift
//  Astronomy
//
//  Created by xander on 2021/4/11.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        _ = CoreDataStack.apod.mainContext
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        CoreDataStack.apod.saveContext()
    }
}
