//
//  SceneDelegate.swift
//  CheckAppVersion
//
//  Created by Swarajmeet Singh on 27/06/23.
//

import UIKit

/// The `SceneDelegate` class is responsible for managing the life cycle of the app's scenes.
/// It handles tasks such as setting up the window, responding to scene transitions, and managing resources.
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    /// The window of the app's user interface.
    /// This is where the root view controller and its view hierarchy are managed.
    var window: UIWindow?

    // MARK: - Scene Lifecycle

    /// Called when a new scene session is being created.
    /// Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    /// If you're using a storyboard, the window property will automatically be initialized and attached to the scene.
    /// - Parameters:
    ///   - scene: The scene being connected to the session.
    ///   - session: The session that defines the context for the scene.
    ///   - connectionOptions: The options for configuring the scene.
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Ensures the scene is a valid UIWindowScene before proceeding.
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    /// Called as the scene is being released by the system.
    /// This method is triggered shortly after the scene enters the background, or when its session is discarded.
    /// Use this to release any resources associated with the scene that can be re-created the next time the scene connects.
    /// - Parameter scene: The scene that is being disconnected.
    func sceneDidDisconnect(_ scene: UIScene) {
        // Perform any cleanup here, if necessary, for the scene that is being disconnected.
    }

    /// Called when the scene moves from an inactive state to an active state.
    /// Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    /// - Parameter scene: The scene that is becoming active.
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Restart tasks that were paused when the scene was inactive.
    }

    /// Called when the scene is about to move from an active state to an inactive state.
    /// This may occur due to temporary interruptions such as an incoming phone call.
    /// - Parameter scene: The scene that will resign activity.
    func sceneWillResignActive(_ scene: UIScene) {
        // Handle temporary interruptions here (e.g., phone calls).
    }

    /// Called as the scene transitions from the background to the foreground.
    /// Use this method to undo changes made when entering the background.
    /// - Parameter scene: The scene transitioning from the background to the foreground.
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Undo background-related changes here.
    }

    /// Called as the scene transitions from the foreground to the background.
    /// Use this method to save data, release shared resources, and store state information to restore the scene later.
    /// - Parameter scene: The scene transitioning to the background.
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Save data and release shared resources here before the scene enters the background.
    }
}
