# 📲 AppVersion

**AppVersion** is a Swift utility that makes it effortless to check for updates on the App Store and prompt users to install the latest version—ensuring your users always experience the best your app has to offer.

---

## ✨ Features

- 🔄 **Automatic Update Detection**  
  Compares the installed version with the App Store version using Apple’s Lookup API.

- ⚡️ **Simple Integration**  
  Just one line of code to trigger an update check.

- 💪 **Force or Optional Updates**  
  Choose whether users can skip or must install the update.

- 🚀 **Optimized & Lightweight**  
  Built with async/await and UIKit alerts—no external dependencies.

- 🌟 **Customizable Alert UI**  
  Tailor the alert’s message, buttons, and appearance to fit your branding.

- 📲 **App Store Deep Linking**  
  Redirects users to your app's App Store page for quick updating.

---

## 🛠️ How to Use

### 1. Integrate the Utility

Add the following files to your Xcode project:

- `AppVersionChecker.swift`
- `DefaultAppUpdateNotifier.swift` (optional, or use your own)

### 2. Check for Updates

#### 🔒 Force Update (no cancel option)

```swift
AppVersionChecker().checkForAppUpdate(forceUpdate: true)
