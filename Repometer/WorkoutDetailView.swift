//
//  WorkoutDetailView.swift
//  Repometer
//
//  Created by Sam Perlmutter on 2/15/22.
//

import SwiftUI

struct WorkoutDetailView: View {
    let workout: Workout

    var body: some View {
        VStack {
            Text(workout.desc ?? "")
                .multilineTextAlignment(.leading)
            Text("Hold for: \(workout.holdTime) sec")
            Text("Number of reps: \(workout.numReps)")
            Text("Number of sets: \(workout.numSets)")
        }
        .navigationTitle(workout.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct WorkoutDetailView_Previews: PreviewProvider {
    static var previews: some View {
        return WorkoutDetailView(workout: Workout.example())
            .previewDevice(PreviewDevice(rawValue: "iPhone 13 Pro Max"))
    }
}
