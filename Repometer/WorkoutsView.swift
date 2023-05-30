//
//  WorkoutsView.swift
//  Repometer
//
//  Created by Sam Perlmutter on 2/15/22.
//

import SwiftUI

struct WorkoutsView: View {
    @ObservedObject private var cwd = CoreWorkoutData.shared
    @State var showingCreateSheet = false
    @StateObject var connectivity = Connectivity()

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(cwd.workouts) { workout in
                        NavigationLink {
                            WorkoutDetailView(workout: workout)
                        } label: {
                            Text(workout.name)
                                    .font(.headline)
                        }
                    }
                    .onDelete { i in
                        cwd.deleteWorkout(cwd.workouts[i.first!])
                    }
                }
            }
            .navigationTitle("Workouts")
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Spacer()
                    Button(action: {
                        showingCreateSheet.toggle()
                    }, label: {
                        Image(systemName: "square.and.pencil")
                    })
                    .sheet(isPresented: $showingCreateSheet, content: {
                        CreateWorkoutView()
                    })
                }
            }
        }
    }
}

struct WorkoutsView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutsView()
    }
}
