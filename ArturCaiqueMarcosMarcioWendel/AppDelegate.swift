//
//  AppDelegate.swift
//  ArturCaiqueMarcosMarcioWendel
//
//  Created by Artur Clemente on 03/10/22.
//

import UIKit
import FirebaseCore

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        return true
    }
}
