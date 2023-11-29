//
//  WorkoutTabView.swift
//  Repometer WatchKit Extension
//
//  Created by Sam Perlmutter on 2/15/23.
//

import SwiftUI
import WatchKit

struct WorkoutTabView: View {
    let workout: Workout
    @EnvironmentObject var workoutManager: WorkoutManager
    @Environment(\.isLuminanceReduced) var isLuminanceReduced
    @State private var selection: Tab = .counter
    
    enum Tab {
        case counter, nowPlaying
    }
    
    var body: some View {
        TabView(selection: $selection) {
            WorkoutCounterView(workout: workout)
                .tag(Tab.counter)
            NowPlayingView()
                .tag(Tab.nowPlaying)
        }
        .navigationTitle(workout.name)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarHidden(selection == .nowPlaying)
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: isLuminanceReduced ? .never : .automatic))
        .onChange(of: isLuminanceReduced) { _ in
            displayCounterView()
        }
        .onAppear() {
            workoutManager.startWorkout()
            print("start workout")
        }
        .onDisappear() {
            workoutManager.endWorkout()
            print("end workout")
        }
    }
    
    private func displayCounterView() {
        withAnimation {
            selection = .counter
        }
    }
}

struct WorkoutTabView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutTabView(workout: Workout.example())
    }
}
