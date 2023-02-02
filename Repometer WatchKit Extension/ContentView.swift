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
//            Button("update", action: {
//                WKInterfaceDevice.current().play(WKHapticType.click)
//            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
