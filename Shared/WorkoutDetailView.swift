// WorkoutDetailView.swift
// Repometer
//
// Created by Sam Perlmutter on 12/24/23.

import SwiftUI

struct WorkoutDetailView: View {
    let workout: Workout
    #if os(watchOS)
    let onPhone = false
    #else
    let onPhone = true
    #endif

    var body: some View {
         ScrollView {
            VStack(alignment: .leading) {
                Text(workout.name)
                    .foregroundStyle(Color("bluePrimaryColor"))
                    .font(onPhone ? .largeTitle : .title3)
                    .bold()
                Text("\(workout.numSets) sets of \(workout.numReps)\nHold for \(workout.holdTime) seconds")
                    .foregroundStyle(Color("orangePrimaryColor"))
                    .font(onPhone ? .title2 : .headline)
                    .bold()
                Text(workout.desc ?? "")
                    .multilineTextAlignment(.leading)
                    .font(onPhone ? .body : .system(size: 15))
                    .padding(.top)
            }
        }
         .padding([.leading, .trailing], 16)
         .navigationBarTitleDisplayMode(.inline)
    }
}

struct WorkoutDetailView_Previews: PreviewProvider {
    static var previews: some View {
        return WorkoutDetailView(workout: Workout.example())
    }
}
