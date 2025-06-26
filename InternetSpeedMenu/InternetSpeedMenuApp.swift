//
//  InternetSpeedMenuApp.swift
//  InternetSpeedMenu
//
//  Created by Pisey Nguon on 26/6/25.
//

import SwiftUI

@main
struct InternetSpeedMenuApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            SettingsView(appDelegate: appDelegate)
        }
    }
}
