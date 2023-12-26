//
//  WorkoutCounterInterfaceView.swift
//  Repometer
//
//  Created by Sam Perlmutter on 12/25/23.
//

import Foundation
import SwiftUI

struct WorkoutCounterInterfaceView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var counterVM: WorkoutCounterViewModel

    var body: some View {
        let wcw = WorkoutCounterView(counterVM: counterVM)
        VStack {
            Spacer()

            wcw.scaledToFit()
            Spacer()

            HStack {
                Spacer()

                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 60))
                        .padding(15)
                        .foregroundColor(.pink)
                }
                .buttonStyle(.bordered)
                .clipShape(Circle())
                .tint(.red)

                Spacer()

                Button {
                    counterVM.isPaused ? wcw.resumeWorkout() : wcw.pauseWorkout()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 60))
                        .padding(15)
                        .foregroundColor(!counterVM.isPaused ? .green : .yellow)
                        .hidden()
                }
                .buttonStyle(.bordered)
                .clipShape(Circle())
                .tint(counterVM.isPaused ? .green : .yellow)
                .overlay {
                    GeometryReader { g in
                        PlayPauseIcon(center: CGPoint(x: g.size.width / 2, y: g.size.height / 2), isPaused: $counterVM.isPaused)
                    }
                }

                Spacer()
            }
        }
    }
}

struct WorkoutCounterInterfaceView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutCounterInterfaceView(counterVM: WorkoutCounterViewModel(Workout.example()))
    }
}
