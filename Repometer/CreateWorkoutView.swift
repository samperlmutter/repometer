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
    @ObservedObject private var cwd = CoreWorkoutData.shared
    @Environment(\.dismiss) var dismiss
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
                    cwd.createWorkout(UUID(), name, description, holdTime ?? 0, numReps ?? 0, numSets ?? 0)
                    dismiss()
                }
                .buttonStyle(SaveButtonStyle())
            }
            .navigationBarTitle("Create Workout", displayMode: .inline)
            
        }
    }
}

struct CreateWorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        CreateWorkoutView()
    }
}
