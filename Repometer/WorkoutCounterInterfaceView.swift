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
    @StateObject var counterVM: WorkoutCounterViewModel

    var body: some View {
        let wcw = WorkoutCounterView(counterVM: counterVM)
        VStack {
            Text(counterVM.workout.name)
                .foregroundStyle(.bluePrimary)
                .font(.largeTitle)
                .bold()

            Text("\(counterVM.workout.numSets) sets of \(counterVM.workout.numReps)")
                .foregroundStyle(.orangePrimary)
                .font(.title2)
                .bold()

            Spacer()

            wcw
                .scaledToFit()
                .padding([.trailing, .leading], 10)

            Spacer()

            Text(counterVM.workout.desc ?? "")
            .multilineTextAlignment(.leading)
            .font(.headline)
            .padding([.trailing, .leading], 10)
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
        .navigationBarBackButtonHidden()
        .padding(.top, 10)
    }
}

struct WorkoutCounterInterfaceView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutCounterInterfaceView(counterVM: WorkoutCounterViewModel(Workout.example()))
    }
}
