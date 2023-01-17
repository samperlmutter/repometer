//
//  WorkoutView.swift
//  Repometer
//
//  Created by Sam Perlmutter on 2/15/22.
//

import SwiftUI

struct WorkoutView: View {
    let workout: Workout
    
    var body: some View {
        VStack {
            
        }
        .navigationBarTitle(workout.name ?? "Unknown", displayMode: .inline)
    }
}
