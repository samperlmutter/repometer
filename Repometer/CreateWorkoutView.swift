//
//  CreateWorkoutView.swift
//  Repometer
//
//  Created by Sam Perlmutter on 2/15/22.
//

import SwiftUI

struct SaveButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Spacer()
            configuration.label.foregroundColor(.white)
            Spacer()
        }
        .padding()
        .background(Color.blue.cornerRadius(8))
        .padding()
        .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}

struct CreateWorkoutView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var workouts: [Workout]
    @State var name: String = ""
    @State var description: String = ""
    @State var holdTime: Int? = nil
    @State var numReps: Int? = nil
    @State var numSets: Int? = nil
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("INFO")) {
                        TextField("Name", text: $name)
                        TextField("Description", text: $description)
                    }
                    Section(header: Text("ROUTINE")) {
                        HStack {
                            Text("Hold for")
                            Spacer()
                            TextField("", value: $holdTime, format: .number)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.trailing)
                            Text("sec")
                        }
                        HStack {
                            Text("Number of reps")
                            Spacer()
                            TextField("", value: $numReps, format: .number)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.trailing)
                        }
                        HStack {
                            Text("Number of sets")
                            Spacer()
                            TextField("", value: $numSets, format: .number)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.trailing)
                        }
                    }
                }
                Button("Save") {
                    let workout = Workout(name: name,
                            desc: description,
                            holdTime: holdTime ?? 0,
                            numReps: numReps ?? 0,
                            numSets: numSets ?? 0)
                    save(workout: workout)
                    dismiss()
                }
                .buttonStyle(SaveButtonStyle())
            }
            .navigationBarTitle("Create Workout", displayMode: .inline)
            
        }
    }

    func save(workout: Workout) {
        workouts.append(workout)
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: workouts, requiringSecureCoding: false) {
            UserDefaults.standard.set(savedData, forKey: "workouts")
        }
    }
}
