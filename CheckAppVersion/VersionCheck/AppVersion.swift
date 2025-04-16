//  AppVersionChecker.swift
//  Handles App Store version validation and in-app update alerts
//
//  Created by Swarajmeet Singh on 27/06/23.
//  Updated and optimized on 16/04/25.

import UIKit

// MARK: - App Store API Response Models

/// Represents the response from the App Store API for a version lookup.
struct AppStoreLookupResponse: Codable {
    /// The number of results returned by the App Store lookup.
    let resultCount: Int
    
    /// The list of results containing the app information.
    let results: [AppStoreAppInfo]
}

/// Contains the metadata of the app fetched from the App Store.
struct AppStoreAppInfo: Codable {
    /// The version of the app available on the App Store.
    let version: String
    
    /// The URL to the app's page on the App Store.
    let trackViewUrl: String
    
    /// The name of the app.
    let trackName: String
}

// MARK: - Update Notifier Protocol

/// Protocol that defines a method for notifying users about app updates.
protocol AppUpdateNotifier: AnyObject {
    /// Notify the user about an available update.
    ///
    /// - Parameters:
    ///   - appInfo: Information about the latest version of the app.
    ///   - forceUpdate: Whether the user should be forced to update or not.
    func notifyUserAboutUpdate(appInfo: AppStoreAppInfo, forceUpdate: Bool)
}

// MARK: - Version Checker

/// A class responsible for checking the app version against the App Store and notifying users about updates.
final class AppVersionChecker {
    
    /// The bundle from which the app version is read.
    private let bundle: Bundle
    
    /// The session used for making the App Store lookup request.
    private let session: URLSession
    
    /// The notifier responsible for presenting the update alert.
    private let notifier: AppUpdateNotifier

    /// Initializes a new `AppVersionChecker` instance.
    ///
    /// - Parameters:
    ///   - bundle: The app's bundle (default: `.main`).
    ///   - session: The network session used for fetching data (default: `.shared`).
    ///   - notifier: The notifier used to display alerts (default: `DefaultAppUpdateNotifier`).
    init(
        bundle: Bundle = .main,
        session: URLSession = .shared,
        notifier: AppUpdateNotifier = DefaultAppUpdateNotifier()
    ) {
        self.bundle = bundle
        self.session = session
        self.notifier = notifier
    }

    /// Checks for an app update by comparing the installed version with the App Store version.
    ///
    /// - Parameter forceUpdate: If `true`, the user will be forced to update. If `false`, the user has the option to cancel the update.
    func checkForAppUpdate(forceUpdate: Bool) {
        Task {
            do {
                print("📡 Checking for app update...")

                let appInfo = try await fetchLatestAppInfo()

                if isNewerVersionAvailable(storeVersion: appInfo.version) {
                    print("🆕 Update available: \(appInfo.version)")
                    await MainActor.run {
                        notifier.notifyUserAboutUpdate(appInfo: appInfo, forceUpdate: forceUpdate)
                    }
                } else {
                    print("✅ App is up to date")
                }
            } catch {
                print("❌ Update check failed: \(error.localizedDescription)")
            }
        }
    }

    /// Fetches the latest version of the app from the App Store.
    ///
    /// - Returns: The app information retrieved from the App Store.
    /// - Throws: An error if the app information cannot be fetched or parsed.
    private func fetchLatestAppInfo() async throws -> AppStoreAppInfo {
        guard let bundleId = bundle.bundleIdentifier,
              let url = URL(string: "https://itunes.apple.com/lookup?bundleId=\(bundleId)") else {
            throw URLError(.badURL)
        }

        let (data, response) = try await session.data(from: url)
        if let httpResponse = response as? HTTPURLResponse {
            print("⬅️ HTTP Status: \(httpResponse.statusCode)")
        }

        let result = try JSONDecoder().decode(AppStoreLookupResponse.self, from: data)

        guard let appInfo = result.results.first else {
            throw NSError(domain: "AppVersionChecker", code: 404, userInfo: [
                NSLocalizedDescriptionKey: "App not found on the App Store"
            ])
        }

        return appInfo
    }

    /// Compares the current app version with the version available on the App Store.
    ///
    /// - Parameter storeVersion: The version of the app available on the App Store.
    /// - Returns: `true` if the current version is older than the version on the App Store.
    private func isNewerVersionAvailable(storeVersion: String) -> Bool {
        guard let currentVersion = bundle.infoDictionary?["CFBundleShortVersionString"] as? String else {
            print("⚠️ Couldn't read current version")
            return false
        }

        let isNewer = currentVersion.compare(storeVersion, options: .numeric) == .orderedAscending
        print("🔍 Current: \(currentVersion), Store: \(storeVersion), Needs update: \(isNewer)")
        return isNewer
    }
}

// MARK: - Default Notifier

/// A default implementation of the `AppUpdateNotifier` protocol that presents an update alert using `UIAlertController`.
final class DefaultAppUpdateNotifier: AppUpdateNotifier {
    
    /// Presents an alert notifying the user about an available update.
    ///
    /// - Parameters:
    ///   - appInfo: The app information containing the latest version and app name.
    ///   - forceUpdate: Whether the update is forced or optional.
    func notifyUserAboutUpdate(appInfo: AppStoreAppInfo, forceUpdate: Bool) {
        let alert = UIAlertController(
            title: "Update Available",
            message: "Version \(appInfo.version) of \(appInfo.trackName) is now available. Please update to continue.",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Update", style: .default) { _ in
            guard let url = URL(string: appInfo.trackViewUrl) else { return }
            UIApplication.shared.open(url)
        })

        if !forceUpdate {
            alert.addAction(UIAlertAction(title: "Later", style: .cancel))
        }

        if let rootVC = UIApplication.shared
            .connectedScenes
            .compactMap({ ($0 as? UIWindowScene)?.keyWindow?.rootViewController })
            .first {
            rootVC.present(alert, animated: true)
        } else {
            print("❌ Could not present alert: no root view controller")
        }
    }
}
