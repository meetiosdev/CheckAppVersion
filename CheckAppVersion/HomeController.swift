//
//  HomeController.swift
//  CheckAppVersion
//
//  Created by Swarajmeet Singh on 27/06/23.
//  Updated and optimized on 16/04/25.
//

import UIKit

/// The main entry point for the app's UI.
/// This controller checks for app updates as soon as it's presented.
class HomeController: UIViewController {

    // MARK: - Lifecycle

    /// Called when the view is loaded into memory.
    ///
    /// Override this method to set up any additional UI components or perform initial setup.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup any additional UI here if needed
    }

    /// Called when the view has appeared on screen.
    ///
    /// This method triggers the check for app updates immediately when the view appears.
    ///
    /// - Parameter animated: A boolean indicating whether the view appearance was animated.
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 🔍 Check for a forced app update using AppVersionChecker
        let versionChecker = AppVersionChecker()
        versionChecker.checkForAppUpdate(forceUpdate: true)
    }
}
