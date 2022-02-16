//
//  ContentView.swift
//  Repometer
//
//  Created by Sam Perlmutter on 2/15/22.
//

import SwiftUI

struct ContentView: View {
    struct Workout: Identifiable {
        let name: String
        let id = UUID()
    }
    
    var workouts = [
        Workout(name: "Plank"),
        Workout(name: "Leg lift"),
        Workout(name: "Bridge")
    ]
    var body: some View {
        NavigationView {
            List (workouts) {
                Text($0.name)
            }
            .navigationTitle("Workouts")
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Spacer()
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "square.and.pencil")
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
