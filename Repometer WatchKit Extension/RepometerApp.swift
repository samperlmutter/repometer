//
//  RepometerApp.swift
//  Repometer WatchKit Extension
//
//  Created by Sam Perlmutter on 2/15/22.
//

import SwiftUI

@main
struct RepometerApp: App {
    @StateObject private var dataController = DataController()
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
