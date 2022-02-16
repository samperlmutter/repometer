//
//  WorkoutView.swift
//  Repometer
//
//  Created by Sam Perlmutter on 2/15/22.
//

import SwiftUI

struct WorkoutView: View {
    let workoutItem: WorkoutItem
    
    var body: some View {
        VStack {
            
        }
        .navigationBarTitle(workoutItem.name, displayMode: .inline)
    }
}
