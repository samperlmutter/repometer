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
            configuration.label.foregroundColor(.white).font(.system(size: 18))
            Spacer()
        }
        .padding()
        .background(Color.blue.cornerRadius(16))
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
                    Section(header: Text("Info")
                        .font(Font.headline)
                        .foregroundColor(.primary)
                        .textCase(nil)) {
                        TextField("Name", text: $name)
                        if #available(iOS 16.0, *) {
                            TextField("Description", text: $description, axis: .vertical)
                                .lineLimit(5)
                        } else {
                            TextField("Description", text: $description)
                        }
                    }
                    Section(header: Text("Routine")
                        .font(Font.headline)
                        .foregroundColor(.primary)
                        .textCase(nil)) {
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
                Button("Create") {
                    cwd.addWorkout(UUID(), name, description, holdTime ?? 0, numReps ?? 0, numSets ?? 0)
                    dismiss()
                }
                .buttonStyle(SaveButtonStyle())
            }
            .navigationBarTitle("Create Workout", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .background(Color(UIColor.systemGroupedBackground))
        }
    }
}

struct CreateWorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        CreateWorkoutView()
    }
}
