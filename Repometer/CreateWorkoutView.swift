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
        .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}

struct CreateWorkoutView: View {
    @Environment(\.dismiss) var dismiss
    @State var name: String = ""
    @State var description: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("INFO")) {
                    TextField("Name", text: $name)
                    ZStack {
                        if description.isEmpty {
                            HStack {
                                Text("Description")
                                    .opacity(description.isEmpty ? 0.25 : 1)
                                Spacer()
                            }
                        }
                        TextEditor(text: $description)
                    }
                }
                Button("Save") {
                    
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
