//
//  InternetSpeedLauncherApp.swift
//  InternetSpeedLauncher
//
//  Created by Pisey Nguon on 26/6/25.
//

import SwiftUI

@main
struct InternetSpeedLauncherApp: App {
    var body: some Scene {
        WindowGroup {
            EmptyView() // no UI
        }
    }

    init() {
        let mainAppBundleID = "com.digitaltalent.InternetSpeedMenu"
        if !isMainAppRunning(bundleID: mainAppBundleID) {
            let url = URL(fileURLWithPath: "/Applications/InternetSpeedMenu.app")
            NSWorkspace.shared.openApplication(at: url, configuration: NSWorkspace.OpenConfiguration(), completionHandler: nil)
        }
        NSApp.terminate(nil)
    }

    private func isMainAppRunning(bundleID: String) -> Bool {
        return NSRunningApplication.runningApplications(withBundleIdentifier: bundleID).count > 0
    }
}
