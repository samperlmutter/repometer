//
//  ContentView.swift
//  Repometer
//
//  Created by Sam Perlmutter on 2/15/22.
//

import SwiftUI

struct WorkoutItem: Identifiable {
    let name: String
    let id = UUID()
}

struct ContentView: View {
    var workouts = [
        WorkoutItem(name: "Plank"),
        WorkoutItem(name: "Leg lift"),
        WorkoutItem(name: "Bridge")
    ]
    var body: some View {
        NavigationView {
            List (workouts) { workoutItem in
                NavigationLink(destination: WorkoutView(workoutItem: workoutItem)) {
                    Text(workoutItem.name)
                        .font(.headline)
                }
            }
            .navigationBarTitle("Workouts")
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Spacer()
                    NavigationLink(destination: CreateWorkoutView(), label: {
                        Image(systemName: "square.and.pencil")
                    })
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
