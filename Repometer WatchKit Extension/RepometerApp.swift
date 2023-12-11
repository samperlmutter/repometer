//
//  RepometerApp.swift
//  Repometer WatchKit Extension
//
//  Created by Sam Perlmutter on 2/15/22.
//

import SwiftUI

@main
struct RepometerApp: App {
    private var workoutManager = WorkoutManager()
    @SceneBuilder var body: some Scene {
        WindowGroup {
            WorkoutsView()
                .environmentObject(workoutManager)
                .task {
                    Connectivity.shared.send(.syncCheck(Connectivity.shared.workouts.map { $0.id }))
                }
        }
    }
}
