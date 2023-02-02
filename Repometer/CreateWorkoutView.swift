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
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    @FetchRequest(sortDescriptors: []) var workouts: FetchedResults<Workout>
    @StateObject var connectivity = Connectivity()
    @State var name: String = ""
    @State var description: String = ""
    @State var holdTime: Int32? = nil
    @State var numReps: Int32? = nil
    @State var numSets: Int32? = nil
    
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
                    let workout = Workout(context: moc)
                    workout.id = UUID()
                    workout.name = name
                    workout.desc = description
                    workout.holdTime = holdTime ?? 0
                    workout.numReps = numReps ?? 0
                    workout.numSets = numSets ?? 0
                    try? moc.save()
                    connectivity.send(.add(workout))
                    dismiss()
                }
                .buttonStyle(SaveButtonStyle())
            }
            .navigationBarTitle("Create Workout", displayMode: .inline)
            
        }
    }
}
