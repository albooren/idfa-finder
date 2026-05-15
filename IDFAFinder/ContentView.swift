//
//  ContentView.swift
//  IDFAFinder
//
//  Created by AlperenKişi on 5/5/26.
//

import SwiftUI
#if canImport(AppTrackingTransparency)
import AppTrackingTransparency
import AdSupport
#endif

struct ContentView: View {
    @State private var idfa: String = "—"
    @State private var status: String = "Not requested yet"

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)

            Text("IDFA")
                .font(.headline)
            Text(idfa)
                .font(.system(.body, design: .monospaced))
                .multilineTextAlignment(.center)
                .textSelection(.enabled)

            Text("Status: \(status)")
                .font(.caption)
                .foregroundStyle(.secondary)

            Button("Request Permission & Get IDFA") {
                Task { await requestIDFA() }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .task { await requestIDFA() }
    }

    private func requestIDFA() async {
        #if canImport(AppTrackingTransparency)
        let attStatus = await ATTrackingManager.requestTrackingAuthorization()
        switch attStatus {
        case .authorized:
            let id = ASIdentifierManager.shared().advertisingIdentifier
            idfa = id.uuidString
            status = "Authorized"
            print("IDFA:", id.uuidString)
        case .denied:
            idfa = "—"
            status = "Denied (IDFA will always return zeros)"
            print("Permission denied, IDFA will always return zeros.")
        case .restricted:
            idfa = "—"
            status = "Restricted"
        case .notDetermined:
            idfa = "—"
            status = "Not determined"
        @unknown default:
            idfa = "—"
            status = "Unknown status"
        }
        #else
        status = "IDFA is not supported on this platform"
        #endif
    }
}

#if canImport(AppTrackingTransparency)
private extension ATTrackingManager {
    static func requestTrackingAuthorization() async -> AuthorizationStatus {
        await withCheckedContinuation { continuation in
            requestTrackingAuthorization { status in
                continuation.resume(returning: status)
            }
        }
    }
}
#endif

#Preview {
    ContentView()
}
