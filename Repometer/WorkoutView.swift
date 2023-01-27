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
        .navigationBarTitle(workout.name, displayMode: .inline)
        .onAppear() {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let decoder = JSONDecoder()
            decoder.userInfo[CodingUserInfoKey.managedObjectContext] = DataController.shared.container.viewContext
            do {
                let jsonWorkout = String(data: try encoder.encode(workout), encoding: .utf8)!
                print(jsonWorkout)
                
                let jsonWorkouData = try decoder.decode(Workout.self, from: Data(jsonWorkout.utf8))
                print("id: \(jsonWorkouData.id); name: \(jsonWorkouData.name)")
                let jsonWorkoutDataJson = String(data: try encoder.encode(jsonWorkouData), encoding: .utf8)!
                print(jsonWorkoutDataJson)
            } catch {
                print("json error")
            }
        }
    }
}
