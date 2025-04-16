//
//  AppDelegate.swift
//  CheckAppVersion
//
//  Created by Swarajmeet Singh on 27/06/23.
//

import UIKit

@main
/// The `AppDelegate` class is the entry point for the app, and it conforms to the `UIApplicationDelegate` protocol.
/// It handles app-level events and acts as the central point for managing the application's lifecycle.
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Application Lifecycle

    /// Called when the application has completed its launch process.
    /// This method provides an opportunity to perform any final setup or initialization.
    ///
    /// - Parameters:
    ///   - application: The application instance.
    ///   - launchOptions: A dictionary containing launch options that might contain information on how the app was launched.
    ///
    /// - Returns: A Boolean value indicating whether the launch was successful.
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: - UISceneSession Lifecycle

    /// Called when a new scene session is being created.
    /// This method provides the opportunity to configure the scene before it is presented.
    ///
    /// - Parameters:
    ///   - application: The application instance.
    ///   - connectingSceneSession: The scene session being connected to the app.
    ///   - options: The options used to configure the new scene.
    ///
    /// - Returns: A `UISceneConfiguration` object that specifies the configuration for the new scene.
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    /// Called when a scene session is discarded by the system or user.
    /// This method provides the opportunity to clean up resources that were specific to the discarded scene sessions.
    ///
    /// - Parameters:
    ///   - application: The application instance.
    ///   - sceneSessions: A set of scene sessions that were discarded.
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
