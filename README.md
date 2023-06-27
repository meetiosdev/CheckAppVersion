# CheckAppVersion
AppVersion
AppVersion is a Swift utility that allows you to easily check for updates of your iOS application and prompt users to update to the latest version for an enhanced user experience.

Features
🔄 Seamlessly checks for updates by comparing the version on the App Store with the currently installed version.
⚡️ Simple integration with just a single line of code.
💪 Control the update behavior with the option to force users to update or provide the option to cancel.
🚀 Optimized and memory-efficient implementation.
🌟 Interactive and customizable alert presentation.
📲 Deep links users to the App Store for convenient updates.

How to Use
To check for updates and prompt users to update, simply call the checkForUpdate method with the desired force update option.

Force Update: Displays an alert to users with no option to cancel. Users are forced to update.

```
AppVersion.checkForUpdate(forceUpdate: true)
```

Optional Update: Displays an alert to users with the option to cancel. Users can choose to update or dismiss the alert.

```
AppVersion.checkForUpdate(forceUpdate: false)
```
Make sure to call the update alert after setting the root view controller. This ensures that the alert is presented correctly without being dismissed when a new root view controller is set.
```
self.view.window?.rootViewController = rootvc
AppVersion.checkForUpdate(forceUpdate: true)
```

Customize the update alert presentation:
✏️ Modify the alert title, message, and button labels to suit your app's branding and messaging.
✨ Customize the alert's appearance using the provided UIAlertController methods.
```
private static func showUpdateAlert(forceUpdate: Bool, info: AppInfo) {
    let alertController = UIAlertController(title: "📣 Update Available", message: "🆕 A new version(\(info.version)) of the \(info.trackName) is available. Please update to the latest version.", preferredStyle: .alert)
    
    // Update action
    let updateAction = UIAlertAction(title: "📲 Update", style: .default) { (action) in
        // Open App Store for update
        if let url = URL(string: info.trackViewUrl) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    alertController.addAction(updateAction)
    
    // Cancel action (only for optional update)
    if !forceUpdate {
        let cancelAction = UIAlertAction(title: "⛔️ Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
    }

    // Present the alert on the topmost view controller
    if let topViewController = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController?.topMostViewController() {
        topViewController.present(alertController, animated: true, completion: nil)
    }
}
```
Contributing
🤝 Contributions are welcome! If you have any ideas, suggestions, or bug fixes, please open an issue or submit a pull request.

License
📄 This project is licensed under the MIT License.

Credits
AppVersion is developed and maintained by Swarajmeet Singh.
