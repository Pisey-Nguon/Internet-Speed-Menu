//
//  AppDelegate.swift
//  InternetSpeedMenu
//
//  Created by Pisey Nguon on 26/6/25.
//

import Cocoa
import ServiceManagement
import Cocoa
import ServiceManagement

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    var timer: Timer?
    let monitor = NetworkMonitor()

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem?.button?.title = "Speed: --"

        let launchAtLogin = UserDefaults.standard.bool(forKey: "launchAtLogin")
        if launchAtLogin {
            try? SMAppService.loginItem(identifier: "com.digitaltalent.InternetSpeedLauncher").register()
        }

        if UserDefaults.standard.bool(forKey: "shouldStartMonitor") {
            startMonitoring()
        }
    }

    func startMonitoring() {
        stopMonitoring()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            let speed = self.monitor.getSpeed()
            DispatchQueue.main.async {
                self.statusItem?.button?.title = "↓ \(speed.download) ↑ \(speed.upload)"
            }
        }
    }

    func stopMonitoring() {
        timer?.invalidate()
        timer = nil
        DispatchQueue.main.async {
            self.statusItem?.button?.title = "Speed: --"
        }
    }
}
