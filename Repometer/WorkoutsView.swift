//
//  WorkoutsView.swift
//  Repometer
//
//  Created by Sam Perlmutter on 2/15/22.
//

import SwiftUI

struct WorkoutsView: View {
    @ObservedObject var connectivity = Connectivity.shared

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    ForEach(connectivity.workouts) { workout in
                        WorkoutListItem(workout: workout)
                            .padding([.leading, .trailing], 16)
                            .padding(.bottom, 5)
                    }
                }
            }
            .padding(.top, 16)
        }
        .navigationTitle("Workouts")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct WorkoutsView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutsView()
    }
}
