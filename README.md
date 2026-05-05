# IDFA Finder — Get the IDFA on iOS with App Tracking Transparency (Swift / SwiftUI)

[![Platform](https://img.shields.io/badge/platform-iOS%2026.2%2B-blue)](https://developer.apple.com/ios/)
[![Swift](https://img.shields.io/badge/Swift-5.9%2B-orange)](https://swift.org)
[![License](https://img.shields.io/badge/license-MIT-green)](#license)

A minimal open-source **SwiftUI** iOS sample that requests **App Tracking Transparency (ATT)** authorization and displays the device's **IDFA** (Identifier for Advertisers / `advertisingIdentifier`).

Use this repo as a copy-paste reference for integrating **`ATTrackingManager`** and **`ASIdentifierManager`** in any Swift / SwiftUI iOS app.

## Features

- Request ATT permission with `ATTrackingManager.requestTrackingAuthorization`
- Read the IDFA via `ASIdentifierManager.shared().advertisingIdentifier`
- Modern Swift `async/await` wrapper around the ATT callback API
- Handles all four ATT statuses: `authorized`, `denied`, `restricted`, `notDetermined`
- Cross-platform safe — guarded with `#if canImport(AppTrackingTransparency)` so it builds for macOS / visionOS targets too
- `NSUserTrackingUsageDescription` configured via `INFOPLIST_KEY_*` (no separate `Info.plist` file needed with `GENERATE_INFOPLIST_FILE = YES`)
- SwiftUI UI with selectable IDFA text for easy copy

## Requirements

- Xcode 26.2+
- iOS 26.2+ deployment target
- Real device for a real IDFA (Simulator returns a synthetic UUID)
- Apple Developer account / team for code signing on device

## Quick Start

```bash
git clone https://github.com/albooren/idfa-finder.git
cd idfa-finder
open gg.xcodeproj
```

Set your development team in **Signing & Capabilities**, then run on a real iPhone or iPad.

## How to Request ATT Permission and Read IDFA in Swift

The complete flow lives in `gg/ContentView.swift`. The relevant snippet:

```swift
import AppTrackingTransparency
import AdSupport

let status = await ATTrackingManager.requestTrackingAuthorization()

switch status {
case .authorized:
    let idfa = ASIdentifierManager.shared().advertisingIdentifier
    print("IDFA:", idfa.uuidString)
case .denied, .restricted, .notDetermined:
    print("IDFA unavailable — returns all zeros")
@unknown default:
    break
}
```

`ATTrackingManager.requestTrackingAuthorization` ships only with a completion-handler API; this project wraps it in `withCheckedContinuation` for an `async` call site.

## How to Add `NSUserTrackingUsageDescription`

Without this key the ATT system dialog never appears and the App Store rejects the build. This repo sets it through the build settings (because `GENERATE_INFOPLIST_FILE = YES` means there's no manual `Info.plist`):

```
INFOPLIST_KEY_NSUserTrackingUsageDescription = "We need access to your device's advertising identifier (IDFA) to personalize ads and improve your app experience.";
```

If your project uses a manual `Info.plist`, add the same key/value there instead.

## Notes on iOS IDFA Behavior

- ATT shows the system prompt **only once per install**. After a denial, users must enable tracking in **Settings → Privacy & Security → Tracking**.
- When tracking is not authorized, `advertisingIdentifier` returns `00000000-0000-0000-0000-000000000000`.
- IDFA values on the iOS Simulator are not real device identifiers.
- macOS native builds skip ATT entirely via the `canImport` guard.

## Project Structure

```
gg/
├── ggApp.swift          # @main SwiftUI App entry
└── ContentView.swift    # ATT + IDFA logic and UI
gg.xcodeproj/            # Xcode project (auto-generated Info.plist)
```

## Keywords

iOS, Swift, SwiftUI, IDFA, advertising identifier, App Tracking Transparency, ATT, ATTrackingManager, ASIdentifierManager, AdSupport, advertisingIdentifier, privacy permission, NSUserTrackingUsageDescription, async/await, open source iOS sample.

## Contributing

Issues and pull requests welcome. If this sample helped you, a star on the repo helps others discover it.

## License

MIT. See [LICENSE](LICENSE) — free for personal and commercial use.
