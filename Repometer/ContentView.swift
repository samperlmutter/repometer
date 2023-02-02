//
//  ContentView.swift
//  Repometer
//
//  Created by Sam Perlmutter on 2/15/22.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @State var showingCreateSheet = false
    @FetchRequest(sortDescriptors: []) var workouts: FetchedResults<Workout>
    @StateObject var connectivity = Connectivity()

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(workouts) { workout in
                        NavigationLink {
                            WorkoutView(workout: workout)
                        } label: {
                            Text(workout.name)
                                    .font(.headline)
                        }
                    }
                    .onDelete { i in
                        moc.delete(workouts[i.first!])
                        try? moc.save()
                        // TODO: send delete
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
                            CreateWorkoutView()
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
