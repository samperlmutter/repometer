//
//  WorkoutsView.swift
//  Repometer WatchKit Extension
//
//  Created by Sam Perlmutter on 2/15/22.
//

import SwiftUI

struct WorkoutsView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @StateObject var connectivity = Connectivity()
    @State private var showingAlert = false
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(connectivity.workouts) { workout in
                        NavigationLink {
                            WorkoutActiveView(workout: workout)
                        } label: {
                            Text(workout.name)
                                .font(.headline)
                        }
                    }
                }
                .listStyle(.carousel)
            }
            .navigationTitle("Workouts")
        }
        .onAppear() {
            workoutManager.requestAuthorization()
            #if DEBUG
            connectivity.workouts.append(Workout.example())
            connectivity.workouts.append(Workout.example())
            connectivity.workouts.append(Workout.example())
            connectivity.workouts.append(Workout.example())
            connectivity.workouts.append(Workout.example())
            #endif
        }
    }
}

struct WorkoutsView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutsView()
    }
}
