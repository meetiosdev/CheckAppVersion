//
//  AppVersion.swift
//  Application Version
//
//  Created by Swarajmeet Singh on 27/06/23.
//  Copyright © 2023 Swarajmeet. All rights reserved.
//

import UIKit

struct AppleVersion: Codable {
    let resultCount: Int
    let results: [AppInfo]
}

struct AppInfo: Codable {
    let version: String
    let trackViewUrl: String
    let trackName: String
}

class AppVersion {
    
    static func checkForUpdate(forceUpdate: Bool) {
        guard let bundleId = Bundle.main.bundleIdentifier,
              let url = URL(string: "http://itunes.apple.com/lookup?bundleId=\(bundleId)") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let appVersion = try decoder.decode(AppleVersion.self, from: data)
                
                if let appInfo = appVersion.results.first {
                    let appStoreVersion = appInfo.version
                    
                    if let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                        if currentVersion.compare(appStoreVersion, options: .numeric) == .orderedAscending {
                            DispatchQueue.main.async {
                                showUpdateAlert(forceUpdate: forceUpdate, info: appInfo)
                            }
                        }
                    }
                } else {
                    print("Error: App is not live")
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
        
        task.resume()
    }
    
    private static func showUpdateAlert(forceUpdate: Bool, info: AppInfo) {
        let alertController = UIAlertController(title: "Update Available",
                                                message: "A new version(\(info.version)) of \(info.trackName) is available. Please update to the latest version.",
                                                preferredStyle: .alert)
        
        let updateAction = UIAlertAction(title: "Update", style: .default) { (action) in
            if let url = URL(string: info.trackViewUrl) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        
        alertController.addAction(updateAction)
        
        if !forceUpdate {
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
        }
        
        if let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }),
           let rootViewController = keyWindow.rootViewController {
            rootViewController.present(alertController, animated: true, completion: nil)
        }
    }
}
