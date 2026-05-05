# IDFA Finder

A minimal SwiftUI iOS app that requests App Tracking Transparency (ATT) authorization and displays the device's IDFA (Identifier for Advertisers).

## What It Does

- Prompts the user with the system ATT permission dialog on launch
- Displays the IDFA UUID when permission is granted
- Reports status for `denied` / `restricted` / `notDetermined` cases
- Lets you copy the IDFA via long-press (text selection enabled)
- Includes a button to re-trigger the request flow

## Requirements

- Xcode 26.2+
- iOS 26.2+ deployment target
- A real device for a real IDFA (Simulator returns a synthetic value)
- A development team for code signing if running on device

## Setup

```bash
git clone https://github.com/albooren/idfa-finder.git
cd idfa-finder
open gg.xcodeproj
```

Set your development team in the target's Signing & Capabilities tab, then run on a device.

## How It Works

The app uses `ATTrackingManager.requestTrackingAuthorization` (wrapped in an async helper) to ask the user for tracking permission, then reads `ASIdentifierManager.shared().advertisingIdentifier` if the status is `.authorized`.

`NSUserTrackingUsageDescription` is configured via `INFOPLIST_KEY_*` build settings — the project uses `GENERATE_INFOPLIST_FILE = YES`, so there is no separate `Info.plist` file.

`AppTrackingTransparency` and `AdSupport` are guarded with `#if canImport(...)` because the project also targets macOS, where ATT is unavailable.

## Notes

- ATT shows the system dialog **once per install**. If the user denies, they must enable tracking from Settings → Privacy & Security → Tracking → IDFA Finder.
- Without authorization, IDFA returns `00000000-0000-0000-0000-000000000000`.
- On a Simulator, IDFA may not reflect a real device identifier.

## License

MIT
