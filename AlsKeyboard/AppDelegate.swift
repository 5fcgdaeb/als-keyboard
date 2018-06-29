//
//  AppDelegate.swift
//  AlsKeyboardTests
//
//  Created by Guven Bolukbasi on 29.06.2018.
//  Copyright © 2018 DorianLabs. All rights reserved.
//

import UIKit
import ARKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        var storyboard: UIStoryboard? = .none
        
        ALSEngine.arkitSupported = ARFaceTrackingConfiguration.isSupported
        
        if ARFaceTrackingConfiguration.isSupported { // Use ARKit 1.5 FaceTrackingConfiguration + TrueDepth Camera
            storyboard = UIStoryboard(name: "ARSceneKit", bundle: nil)
        }
        else { // Use Vision Framework
            storyboard = UIStoryboard(name: "Main", bundle: nil)
        }
        window?.rootViewController = storyboard?.instantiateInitialViewController()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) { }

    func applicationDidEnterBackground(_ application: UIApplication) { }

    func applicationWillEnterForeground(_ application: UIApplication) { }

    func applicationDidBecomeActive(_ application: UIApplication) { }

    func applicationWillTerminate(_ application: UIApplication) { }

}

