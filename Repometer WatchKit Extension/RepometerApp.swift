//
//  RepometerApp.swift
//  Repometer WatchKit Extension
//
//  Created by Sam Perlmutter on 2/15/22.
//

import SwiftUI

@main
struct RepometerApp: App {
    @StateObject private var workoutManager = WorkoutManager()
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                WorkoutsView()
            }
            .environmentObject(workoutManager)
        }
    }
}
