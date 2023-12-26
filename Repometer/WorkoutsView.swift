//
//  WorkoutsView.swift
//  Repometer
//
//  Created by Sam Perlmutter on 2/15/22.
//

import SwiftUI

struct WorkoutsView: View {
    @ObservedObject var connectivity = Connectivity.shared
    @State var showingCreateSheet = false

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
            .navigationTitle("Workouts")
            .navigationBarTitleDisplayMode(.large)
            .overlay(alignment: .bottomTrailing) {
                Button(action: {
                    showingCreateSheet.toggle()
                }, label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 75))
                        .foregroundStyle(Color("orangePrimaryColor"), Color("bluePrimaryColor"))
                })
                .sheet(isPresented: $showingCreateSheet, content: {
                    CreateWorkoutView()
                })
            }
        }
    }
}

struct WorkoutsView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutsView()
    }
}
