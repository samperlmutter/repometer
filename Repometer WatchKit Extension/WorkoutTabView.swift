//
//  WorkoutTabView.swift
//  Repometer WatchKit Extension
//
//  Created by Sam Perlmutter on 2/15/23.
//

import SwiftUI
import WatchKit

struct WorkoutTabView: View {
    let counterVM: WorkoutCounterViewModel
    @EnvironmentObject var workoutManager: WorkoutManager
    @Environment(\.isLuminanceReduced) var isLuminanceReduced
    @State private var selection: Tab = .counter
    
    enum Tab {
        case counter, nowPlaying, details
    }

    var body: some View {
        TabView(selection: $selection) {
            WorkoutDetailView(workout: counterVM.workout)
                .tag(Tab.details)
            WorkoutCounterView(counterVM: counterVM)
                .tag(Tab.counter)
            NowPlayingView()
                .tag(Tab.nowPlaying)
        }
        .navigationBarBackButtonHidden()
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: isLuminanceReduced ? .never : .automatic))
        .onChange(of: isLuminanceReduced) {
            withAnimation {
                selection = .counter
            }
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
}

struct WorkoutTabView_Previews: PreviewProvider {
    static var previews: some View {
        let workoutManager = WorkoutManager()
        WorkoutTabView(counterVM: WorkoutCounterViewModel(Workout.example()))
            .environmentObject(workoutManager)
    }
}
