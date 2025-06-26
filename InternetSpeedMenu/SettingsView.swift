import SwiftUI
import ServiceManagement

struct SettingsView: View {
    @AppStorage("shouldStartMonitor") var shouldStartMonitor: Bool = true
    @AppStorage("launchAtLogin") var launchAtLogin: Bool = false

    var appDelegate: AppDelegate

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Toggle("Launch at Login", isOn: $launchAtLogin)
                .onChange(of: launchAtLogin) { _, newValue in
                    let service = SMAppService.loginItem(identifier: "com.digitaltalent.InternetSpeedLauncher")
                    do {
                        newValue ? try service.register() : try service.unregister()
                    } catch {
                        print("⚠️ Failed to update login item: \(error)")
                    }
                }

            Toggle("Monitor Internet Speed", isOn: $shouldStartMonitor)
                .onChange(of: shouldStartMonitor) { _, newValue in
                    if newValue {
                        print("✅ startMonitoring()")
                        appDelegate.startMonitoring()
                    } else {
                        print("🛑 stopMonitoring()")
                        appDelegate.stopMonitoring()
                    }
                }

            Text("Status: \(shouldStartMonitor ? "Running" : "Stopped")")
                .font(.subheadline)
                .foregroundColor(.secondary)

            Spacer()
        }
        .padding()
        .frame(width: 300, height: 180)
    }
}
