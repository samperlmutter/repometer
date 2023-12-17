//
//  WorkoutDetailView.swift
//  Repometer WatchKit Extension
//
//  Created by Sam Perlmutter on 1/17/23.
//

import SwiftUI

struct WorkoutDetailView: View {
    let workout: Workout
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(workout.name)
                    .foregroundStyle(Color("bluePrimaryColor"))
                    .font(.title3)
                Text("\(workout.numSets) sets of \(workout.numReps)")
                    .foregroundStyle(Color("orangePrimaryColor"))
                    .font(.headline)
                Text("Hold for \(workout.holdTime) seconds")
                    .foregroundStyle(Color("orangePrimaryColor"))
                    .font(.headline)
                Text(workout.desc ?? "")
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 15))
            }
        }
    }
}

struct WorkoutDetailView_Previews: PreviewProvider {
    static var previews: some View {
        return WorkoutDetailView(workout: Workout.example())
            .previewDevice(PreviewDevice(rawValue: "Apple Watch Series 8 - (45mm)"))
    }
}
