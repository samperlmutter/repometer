//
//  ContentView.swift
//  Repometer
//
//  Created by Sam Perlmutter on 2/15/22.
//

import SwiftUI

struct WorkoutItem: Identifiable {
    let name: String
    let id = UUID()
}

struct ContentView: View {
    @State var showingCreateSheet = false
    @State var workouts = [Workout]()
    @State var reachable = "No"
    @State var messageText = ""

    var body: some View {
        NavigationView {
            List {
                ForEach(workouts) { workout in
                    NavigationLink(destination: WorkoutView(workout: workout)) {
                        Text(workout.name)
                                .font(.headline)
                    }
                }
                .onDelete { i in
                    workouts.remove(atOffsets: i)
                    if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: workouts, requiringSecureCoding: false) {
                        UserDefaults.standard.set(savedData, forKey: "workouts")
                    }
                }
            }
            .onAppear {
                let defaults = UserDefaults.standard
                if let savedWorkouts = defaults.object(forKey: "workouts") as? Data {
                    if let decodedWorkouts = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedWorkouts) as? [Workout] {
                        workouts = decodedWorkouts
                    }
                }
            }
            }
            .navigationBarTitle("Workouts")
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Spacer()
                    Button(action: {
                        showingCreateSheet.toggle()
                    }, label: {
                        Image(systemName: "square.and.pencil")
                    })
                        .sheet(isPresented: $showingCreateSheet, content: {
                            CreateWorkoutView(workouts: $workouts)
                        })
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
