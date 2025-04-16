//  AppVersionChecker.swift
//  Handles App Store version validation and in-app update alerts
//
//  Created by Swarajmeet Singh on 27/06/23.
//  Updated and optimized on 16/04/25.

import UIKit

// MARK: - App Store API Response Models

struct AppStoreLookupResponse: Codable {
    let resultCount: Int
    let results: [AppStoreAppInfo]
}

struct AppStoreAppInfo: Codable {
    let version: String
    let trackViewUrl: String
    let trackName: String
}

// MARK: - Update Notifier Protocol

protocol AppUpdateNotifier: AnyObject {
    func notifyUserAboutUpdate(appInfo: AppStoreAppInfo, forceUpdate: Bool)
}

// MARK: - Version Checker

final class AppVersionChecker {
    
    private let bundle: Bundle
    private let session: URLSession
    private let notifier: AppUpdateNotifier

    init(
        bundle: Bundle = .main,
        session: URLSession = .shared,
        notifier: AppUpdateNotifier = DefaultAppUpdateNotifier()
    ) {
        self.bundle = bundle
        self.session = session
        self.notifier = notifier
    }

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

final class DefaultAppUpdateNotifier: AppUpdateNotifier {
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

