//
//  ContentView.swift
//  gg
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
    @State private var status: String = "Henüz istenmedi"

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

            Text("Durum: \(status)")
                .font(.caption)
                .foregroundStyle(.secondary)

            Button("İzin İste & IDFA Al") {
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
            status = "İzin verildi"
            print("IDFA:", id.uuidString)
        case .denied:
            idfa = "—"
            status = "İzin reddedildi (IDFA hep sıfır döner)"
            print("İzin verilmedi, IDFA hep sıfır döner.")
        case .restricted:
            idfa = "—"
            status = "Kısıtlanmış"
        case .notDetermined:
            idfa = "—"
            status = "Henüz belirlenmedi"
        @unknown default:
            idfa = "—"
            status = "Bilinmeyen durum"
        }
        #else
        status = "Bu platformda IDFA desteklenmiyor"
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
