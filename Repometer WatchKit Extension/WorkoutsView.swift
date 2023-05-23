//
//  WorkoutsView.swift
//  Repometer WatchKit Extension
//
//  Created by Sam Perlmutter on 2/15/22.
//

import SwiftUI

struct WorkoutsView: View {
    @ObservedObject private var connectivity = Connectivity.shared
    @EnvironmentObject var workoutManager: WorkoutManager
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(connectivity.workouts) { workout in
                        NavigationLink {
                            WorkoutTabView(workout: workout)
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
        }
    }
}

struct WorkoutsView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutsView()
    }
}
