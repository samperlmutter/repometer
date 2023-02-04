//
//  WorkoutView.swift
//  Repometer WatchKit Extension
//
//  Created by Sam Perlmutter on 1/17/23.
//

import SwiftUI

struct WorkoutView: View {
    let workout: Workout
    var body: some View {
        VStack {
            Text(workout.desc ?? "")
                .multilineTextAlignment(.leading)
            Text("Hold for: \(workout.holdTime) sec")
            Text("Number of sets: \(workout.numSets)")
            Text("Number of reps: \(workout.numReps)")
        }
        .navigationTitle(workout.name)
        .navigationBarTitleDisplayMode(.inline)
//        Button("update", action: {
//            WKInterfaceDevice.current().play(WKHapticType.click)
//        })
    }
}

struct WorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        return WorkoutView(workout: Workout.example())
            .previewDevice(PreviewDevice(rawValue: "Apple Watch Series 8 (45mm)"))
    }
}
