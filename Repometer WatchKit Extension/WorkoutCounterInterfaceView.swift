//
//  WorkoutCounterInterfaceView.swift
//  Repometer WatchKit Extension
//
//  Created by Sam Perlmutter on 12/25/23.
//

import Foundation
import SwiftUI

struct WorkoutCounterInterfaceView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var workoutManager: WorkoutManager
    @StateObject var counterVM: WorkoutCounterViewModel

    var body: some View {
        ZStack {
            let wcw = WorkoutCounterView(workoutManager: _workoutManager, counterVM: counterVM)
            wcw.scaledToFill()

            GeometryReader { g in
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 15))
                        .foregroundColor(.pink)
                }
                .buttonStyle(.bordered)
                .clipShape(Circle())
                .tint(.red)
                .frame(width: 25, height: 25)
                .position(x: g.size.width * 0.08, y: g.size.height * 0.92)

                Button {
                    counterVM.isPaused ? wcw.resumeWorkout() : wcw.pauseWorkout()
                } label: {
                    Image(systemName: "playpause")
                        .font(.system(size: min(g.size.width, g.size.height) * 0.12))
                        .foregroundColor(!counterVM.isPaused ? .green : .yellow)
                        .hidden()
                }
                .buttonStyle(.bordered)
                .clipShape(Circle())
                .tint(counterVM.isPaused ? .green : .yellow)
                .frame(width: 25, height: 25)
                .position(x: g.size.width * 0.92, y: g.size.height * 0.92)
                .overlay {
                    PlayPauseIcon(center: CGPoint(x: g.size.width * 0.92, y: g.size.height * 0.92), isPaused: $counterVM.isPaused)
                }
            }
        }
    }
}

struct WorkoutCounterInterfaceView_Previews: PreviewProvider {
    static var previews: some View {
        let workoutManager = WorkoutManager()
        WorkoutCounterInterfaceView(counterVM: WorkoutCounterViewModel(Workout.example()))
            .environmentObject(workoutManager)
    }
}
