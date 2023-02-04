//
//  ContentView.swift
//  Repometer WatchKit Extension
//
//  Created by Sam Perlmutter on 2/15/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var connectivity = Connectivity()
    @State private var showingAlert = false
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(connectivity.workouts) { workout in
                        NavigationLink {
                            WorkoutView(workout: workout)
                        } label: {
                            Text(workout.name)
                                .font(.headline)
                        }
                    }
                }
            }
            .navigationTitle("Workouts")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
